//
//  ObjectCaptureDataModel.swift
//  Organize
//
//  Created by Yuhao Chen on 2/3/24.
//

import Combine
import RealityKit
import SwiftUI
import os

// TODO: Decouple DataModel and ViewModel
// TODO: Adapt Observation framework
#if !(targetEnvironment(simulator) || targetEnvironment(macCatalyst))
@MainActor
@available(iOS 17.0, *)
final class ObjectCaptureDataModel: ObservableObject, Identifiable {
    let logger = Logger(subsystem: OrganizeApp.bundleId,
                        category: "AppDataModel")
    
    static let instance = ObjectCaptureDataModel()
    
    /// The session that manages the object capture phase.
    ///
    /// Set the correct folder locations for the capture session using ``scanFolderManager``.
    @Published var objectCaptureSession: ObjectCaptureSession? {
        willSet {
            detachListeners()
        }
        didSet {
            guard objectCaptureSession != nil else { return }
            attachListeners()
        }
    }
    
    static let minNumImages = 10
    
    static let bundleForLocalizedStrings = { return Bundle.main }()
    
    /// The object that manages the reconstruction process of a set of images of an object into a 3D model.
    ///
    /// When the ``ReconstructionPrimaryView`` is active, hold the session here.
    private(set) var photogrammetrySession: PhotogrammetrySession?
    
    /// The folder set when a new capture session starts.
    private(set) var scanFolderManager: CaptureFolderManager!
//    @Published var modelName = "Untitled"
    @Published var messageList = TimedMessageList()
    
    @Published var state: ModelState = .notSet {
        didSet {
            logger.debug("didSet AppDataModel.state to \(self.state)")
            
            if state != oldValue {
                performStateTransition(from: oldValue, to: state)
            }
        }
    }
    
    @Published var orbitState: OrbitState = .initial
    @Published var orbit: Orbit = .orbit1
    @Published var isObjectFlipped: Bool = false
    
    var preventRestartOnCancel : Bool = false
    var hasIndicatedObjectCannotBeFlipped: Bool = false
    var hasIndicatedFlipObjectAnyway: Bool = false
    var isObjectFlippable: Bool {
        // Overrides the `objectNotFlippable` feedback if the user indicates
        // the object can flip or if they want to flip the object anyway.
//        guard !hasIndicatedObjectCannotBeFlipped else { return false }
        guard !hasIndicatedFlipObjectAnyway else { return true }
        guard let session = objectCaptureSession else { return true }
        return !session.feedback.contains(.objectNotFlippable)
    }
    
    /// The error that indicates the object capture session failed.
    ///
    /// This error moves  ``state`` to ``ModelState/failed``.
    private(set) var error: Swift.Error?
    
    /// A Boolean value that determines whether the view shows a preview model.
    ///
    /// Default value is `false`.
    ///
    /// Uses ``setPreviewModelState(shown:)`` to properly maintain the pause state of
    /// the ``objectCaptureSession`` while showing the ``CapturePrimaryView``.
    /// Alternatively, hiding the ``CapturePrimaryView`` pauses the
    /// ``objectCaptureSession``.
    @Published private(set) var showPreviewModel = false
    
    
    private convenience init(objectCaptureSession: ObjectCaptureSession) {
        self.init()
        self.objectCaptureSession = objectCaptureSession
    }
    
    // Leaves the model state in ready.
    private init() {
        state = .ready
    }
    
    deinit {
        DispatchQueue.main.async {
            self.detachListeners()
        }
    }
    
    /// Informs your app to rerun to the new capture view after recontruction and viewing.
    ///
    /// After reconstruction and viewing are complete, call `endCapture()` to
    /// inform the app it can go back to the new capture view.
    /// You can also call ``endCapture()`` after a canceled or failed
    /// reconstruction to go back to the start screen.
    func endCapture() {
        state = .completed
    }
    
    // This sample doesn't modify the `showPreviewModel` directly. The `CapturePrimaryView`
    // remains on screen and blurred underneath, it doesn't pause.  So, pause
    // the `objectCaptureSession` after showing the model and start it before
    // dismissing the model.
    func setPreviewModelState(shown: Bool) {
        guard shown != showPreviewModel else { return }
        if shown {
            showPreviewModel = true
            objectCaptureSession?.pause()
        } else {
            objectCaptureSession?.resume()
            showPreviewModel = false
        }
    }
    
    // - MARK: Private Interface
    
    private var currentFeedback: Set<Feedback> = []
    
    private typealias Feedback = ObjectCaptureSession.Feedback
    private typealias Tracking = ObjectCaptureSession.Tracking
    
    private var tasks: [ Task<Void, Never> ] = []
    
    @MainActor
    private func attachListeners() {
        logger.debug("Attaching listeners...")
        guard let model = objectCaptureSession else {
            fatalError("Logic error")
        }
        
        tasks.append(Task<Void, Never> { [weak self] in
            for await newFeedback in model.feedbackUpdates {
                self?.logger.debug("Task got async feedback change to: \(String(describing: newFeedback))")
                self?.updateFeedbackMessages(for: newFeedback)
            }
            self?.logger.log("^^^ Got nil from stateUpdates iterator!  Ending observation task...")
        })
        tasks.append(Task<Void, Never> { [weak self] in
            for await newState in model.stateUpdates {
                self?.logger.debug("Task got async state change to: \(String(describing: newState))")
                self?.onStateChanged(newState: newState)
            }
            self?.logger.log("^^^ Got nil from stateUpdates iterator!  Ending observation task...")
        })
    }
    
    private func detachListeners() {
        logger.debug("Detaching listeners...")
        for task in tasks {
            task.cancel()
        }
        tasks.removeAll()
    }
    
    /// Creates a new object capture session.
    private func startNewCapture() -> Bool {
        logger.log("startNewCapture() called...")
        if !ObjectCaptureSession.isSupported {
            logger.warning("ObjectCapture is not supported on this device")
            return false
        }
        
        guard let folderManager = CaptureFolderManager() else {
            return false
        }
        
        scanFolderManager = folderManager
        objectCaptureSession = ObjectCaptureSession()
        
        guard let session = objectCaptureSession else {
            preconditionFailure("startNewCapture() got unexpectedly nil session!")
        }
        
        var configuration = ObjectCaptureSession.Configuration()
        configuration.checkpointDirectory = scanFolderManager.snapshotsFolder
        configuration.isOverCaptureEnabled = true
        logger.log("Enabling overcapture...")
        
        // Starts the initial segment and sets the output locations.
        session.start(imagesDirectory: scanFolderManager.imagesFolder,
                      configuration: configuration)
        
        if case let .failed(error) = session.state {
            logger.error("Got error starting session! \(String(describing: error))")
            switchToErrorState(error: error)
        } else {
            state = .capturing
        }
        
        return true
    }
    
    public func stopSession() {
        guard let session = objectCaptureSession else {
            logger.warning("Couldn't pause session because session is nil")
            return
        }
        if session.state == .ready {
            preventRestartOnCancel = true
            session.cancel()
        }
        session.pause()  
    }
    
    public func resumeSession() {
        guard let session = objectCaptureSession else {
            logger.warning("Couldn't pause session because session is nil")
            return
        }
        
        if preventRestartOnCancel {
            state = .restart
            preventRestartOnCancel = false
        }
        session.resume()
    }
    
    private func switchToErrorState(error: Swift.Error) {
        // Sets the error first since the transitions assume it's non-`nil`.
        self.error = error
        state = .failed
    }
    
    // This sample calls `startReconstruction()` from the `ReconstructionPrimaryView` asynchronous
    // task after it's on the screen.
    /// Moves model state from prepare to reconstruct to reconstructing
    ///
    /// See ``ModelState/prepareToReconstruct``
    /// and ``ModelState/reconstructing``.
    private func startReconstruction() throws {
        logger.debug("startReconstruction() called.")
        
        var configuration = PhotogrammetrySession.Configuration()
        configuration.checkpointDirectory = scanFolderManager.snapshotsFolder
        photogrammetrySession = try PhotogrammetrySession(
            input: scanFolderManager.imagesFolder,
            configuration: configuration)
        
        state = .reconstructing
    }
    
    private func reset() {
        logger.info("reset() called...")
        photogrammetrySession = nil
        objectCaptureSession = nil
        scanFolderManager = nil
        showPreviewModel = false
        orbit = .orbit1
        orbitState = .initial
        isObjectFlipped = false
        state = .ready
    }
    
    private func onStateChanged(newState: ObjectCaptureSession.CaptureState) {
        logger.info("ObjectCaptureSession switched to state: \(String(describing: newState))")
        if case .completed = newState {
            logger.log("ObjectCaptureSession moved to .completed state.  Switch app model to reconstruction...")
            state = .prepareToReconstruct
        } else if case let .failed(error) = newState {
            logger.error("ObjectCaptureSession moved to error state \(String(describing: error))...")
            if case ObjectCaptureSession.Error.cancelled = error {
                if !preventRestartOnCancel {
                    state = .restart
                }
            } else {
                switchToErrorState(error: error)
            }
        }
    }
    
    private func updateFeedbackMessages(for feedback: Set<Feedback>) {
        // Compares the incoming feedback with the previous feedback to find
        // the intersection.
        let persistentFeedback = currentFeedback.intersection(feedback)
        
        // Finds the feedback that's no longer active.
        let feedbackToRemove = currentFeedback.subtracting(persistentFeedback)
        for thisFeedback in feedbackToRemove {
            if let feedbackString = FeedbackMessages.getFeedbackString(for: thisFeedback) {
                messageList.remove(feedbackString)
            }
        }
        
        // Finds new feedback.
        let feebackToAdd = feedback.subtracting(persistentFeedback)
        for thisFeedback in feebackToAdd {
            if let feedbackString = FeedbackMessages.getFeedbackString(for: thisFeedback) {
                messageList.add(feedbackString)
            }
        }
        
        currentFeedback = feedback
    }
    
    private func performStateTransition(from fromState: ModelState, to toState: ModelState) {
        if fromState == .failed {
            error = nil
        }
        
        switch toState {
        case .ready:
            guard startNewCapture() else {
                logger.error("Starting new capture failed!")
                break
            }
        case .capturing:
            orbitState = .initial
        case .prepareToReconstruct:
            // Cleans up the session to free GPU and memory resources.
            objectCaptureSession = nil
            do {
                try startReconstruction()
            } catch {
                logger.error("Reconstructing failed!")
            }
        case .restart, .completed:
            reset()
        case .viewing:
            photogrammetrySession = nil
            
            // Removes snapshots folder to free up space after generating the model.
            let snapshotsFolder = scanFolderManager.snapshotsFolder
            DispatchQueue.global(qos: .background).async {
                try? FileManager.default.removeItem(at: snapshotsFolder)
            }
            
        case .failed:
            logger.error("App failed state error=\(String(describing: self.error!))")
        default:
            break
        }
    }
    
    func determineCurrentOnboardingState() -> CaptureOnboardingState? {
        guard let session = objectCaptureSession else { return nil }
        let orbitCompleted = session.userCompletedScanPass
        var currentState = CaptureOnboardingState.tooFewImages
        if session.numberOfShotsTaken >= ObjectCaptureDataModel.minNumImages {
            switch orbit {
            case .orbit1:
                currentState = orbitCompleted ? .firstSegmentComplete : .firstSegmentNeedsWork
            case .orbit2:
                currentState = orbitCompleted ? .secondSegmentComplete : .secondSegmentNeedsWork
            case .orbit3:
                currentState = orbitCompleted ? .thirdSegmentComplete : .thirdSegmentNeedsWork
            }
        }
        return currentState
    }
    
}

#endif