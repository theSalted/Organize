//
//  CaptureOverlayView+Buttons.swift
//  Organize
//
//  Created by Yuhao Chen on 2/4/24.
//

import SwiftUI
import RealityKit
import UniformTypeIdentifiers
import os

#if !targetEnvironment(simulator)
extension CaptureOverlayView {
    static let logger = Logger(subsystem: OrganizeApp.bundleId,
                               category: "CaptureOverlayView+Buttons")

    @available(iOS 17.0, *)
    @MainActor
    struct CaptureButton: View {
        var session: ObjectCaptureSession
        var isObjectFlipped: Bool
        @Binding var hasDetectionFailed: Bool

        var body: some View {
            Button {
                performAction()
            } label: {
                buttonLabel
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .bold()
                    .foregroundStyle(buttonColor)
            }
            .buttonStyle(OverlayCircularStyle())
            .accessibilityLabel(buttonDescription)
//            Button(
//                action: {
//                    performAction()
//                },
//                label: {
//                    Text(buttonDescription)
//                        .font(.body)
//                        .fontWeight(.bold)
//                        .foregroundColor(.white)
//                        .padding(.horizontal, 25)
//                        .padding(.vertical, 20)
//                        .background(.blue)
//                        .clipShape(Capsule())
//                })
        }
        
        private var buttonColor : Color {
            if case .ready = session.state {
                return Color.gray
            } else {
                if !isObjectFlipped {
                    return Color.accentColor
                } else {
                    return Color.gray
                }
            }
        }
        
        private var buttonLabel : Image {
            if case .ready = session.state {
                return Image(systemName: "viewfinder")
            } else {
                if !isObjectFlipped {
                    return Image(systemName: "cube")
                } else {
                    return Image(systemName: "viewfinder")
                }
            }
            
        }

        private var buttonDescription: String {
            if case .ready = session.state {
                return LocalizedString.continue
            } else {
                if !isObjectFlipped {
                    return LocalizedString.startCapture
                } else {
                    return LocalizedString.continue
                }
            }
        }

        private func performAction() {
            if case .ready = session.state {
                logger.debug("here")
                hasDetectionFailed = !(session.startDetecting())
            } else if case .detecting = session.state {
                session.startCapturing()
            }
        }
    }

    @available(iOS 17.0, *)
    struct ResetBoundingBoxButton: View {
        var session: ObjectCaptureSession

        var body: some View {
            Button(
                action: { session.resetDetection() },
                label: {
                    VStack(spacing: 6) {
                        Image("ResetBbox")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30)

                        Text(LocalizedString.resetBox)
                            .font(.footnote)
                            .opacity(0.7)
                    }
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                })
        }
    }

    @available(iOS 17.0, *)
    struct NextButton: View {
        @EnvironmentObject var objectCaptureModel: ObjectCaptureDataModel

        var body: some View {
            Button(action: {
                logger.log("\(LocalizedString.next) button clicked!")
                objectCaptureModel.setPreviewModelState(shown: true)
            },
                   label: {
                Text(LocalizedString.next)
//                    .modifier(VisualEffectRoundedCorner())
            })
        }
    }

    @available(iOS 17.0, *)
    struct ManualShotButton: View {
        var session: ObjectCaptureSession

        var body: some View {
            Button(
                action: {
                    session.requestImageCapture()
                },
                label: {
                    if session.canRequestImageCapture {
                        Text(Image(systemName: "button.programmable"))
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    } else {
                        Text(Image(systemName: "button.programmable"))
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    }
                }
            )
            .disabled(!session.canRequestImageCapture)
        }
    }

    struct DocumentBrowser: UIViewControllerRepresentable {
        let startingDir: URL

        func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentBrowser>) -> UIDocumentPickerViewController {
            let controller = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.item])
            controller.directoryURL = startingDir
            return controller
        }

        func updateUIViewController(
            _ uiViewController: UIDocumentPickerViewController,
            context: UIViewControllerRepresentableContext<DocumentBrowser>) {}
    }

    @available(iOS 17.0, *)
    struct FilesButton: View {
        @EnvironmentObject var objectCaptureModel: ObjectCaptureDataModel
        @State private var showDocumentBrowser = false

        var body: some View {
            Button(
                action: {
                    logger.log("Files button clicked")
                    showDocumentBrowser = true
                },
                label: {
                    Image(systemName: "folder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22)
                        .foregroundColor(.white)
                })
            .padding(.bottom, 20)
            .padding(.horizontal, 10)
            .sheet(isPresented: $showDocumentBrowser,
                   onDismiss: { showDocumentBrowser = false },
                   content: { DocumentBrowser(startingDir: objectCaptureModel.scanFolderManager.rootScanFolder) })
        }
    }

    struct HelpButton: View {
        // This sample passes this binding in from the parent to allow the button to stop showing the panel.
        @Binding var showInfo: Bool

        var body: some View {
            Button(action: {
                logger.log("\(LocalizedString.help) button clicked!")
                withAnimation {
                    showInfo = true
                }
            }, label: {
                VStack(spacing: 10) {
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22)

                    Text(LocalizedString.help)
                        .font(.footnote)
                        .opacity(0.7)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
            })
        }
    }

    @available(iOS 17.0, *)
    struct CancelButton: View {
        @EnvironmentObject var objectCaptureModel: ObjectCaptureDataModel

        var body: some View {
            Button(action: {
                logger.log("\(LocalizedString.cancel) button clicked!")
                objectCaptureModel.objectCaptureSession?.cancel()
            }, label: {
                Text(LocalizedString.cancel)
                    
//                    .modifier(VisualEffectRoundedCorner())
            })//.buttonStyle(OverlayButtonStyle())
        }
    }

    @available(iOS 17.0, *)
    struct NumOfImagesButton: View {
        var session: ObjectCaptureSession

        var body: some View {
            VStack(spacing: 8) {
                Text(Image(systemName: "photo"))

                Text(String(format: LocalizedString.numOfImages,
                            session.numberOfShotsTaken,
                            session.maximumNumberOfInputImages))
                .font(.footnote)
                .fontWidth(.condensed)
                .fontDesign(.rounded)
                .bold()
            }
            .foregroundColor(session.feedback.contains(.overCapturing) ? .red : .white)
        }
    }

    struct VisualEffectRoundedCorner: ViewModifier {
        func body(content: Content) -> some View {
            content
                .padding(16.0)
                .font(.subheadline)
                .bold()
                .foregroundColor(.white)
                .background(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)
                .cornerRadius(15)
                .multilineTextAlignment(.center)
        }
    }

    struct VisualEffectView: UIViewRepresentable {
        var effect: UIVisualEffect?
        func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
        func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
    }
    
    struct OverlayButtonStyle : ButtonStyle {
        @Environment(\.isEnabled) private var isEnabled: Bool
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .modifier(VisualEffectRoundedCorner())
                .opacity(isEnabled ? 1 : 0.5)
                .foregroundStyle(isEnabled ? .white : .gray)
            
        }
    }
    
    struct OverlayCircularStyle : ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(25)
                .background {
                    Circle()
                }
        }
    }
}
#endif
