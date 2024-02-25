//
//  CapturedObject.swift
//  Organize
//
//  Created by Yuhao Chen on 2/3/24.
//

import Foundation
import OSLog
import QuickLookThumbnailing
import SwiftData
import UIKit
import SceneKit.ModelIO

@Model
final class CapturedObject: Identifiable, ModelDirectory {
    var id: UUID
    var filename: String
    /// This is a string of a path component that will be used to build full URL of
    /// captured object's Root folder.
    ///
    /// The PATH should look like ``"Scans/2000-01-01T01-01-01Z"``
    ///
    /// - Warning: This is only the `PATH` section of the URL, and can't be used to build
    /// a URL alone.
    var captureRootFolderPathComponentString: String
    var item: Item?
    /// The data store for thumbnail, mainly for SwiftData
    private var thumbnailData: Data?
    /// The data store for thumbnail, mainly for SwiftData
    private var previewImageData: Data?

    var modelURL: URL? {
        guard let url = modelsFolderURL?.appendingPathComponent(filename + ".usdz") else {
            logger.warning("Fail to create model url because root scan directory is nil")
            return nil
        }

        guard FileManager.default.fileExists(atPath: url.relativePath) else {
            logger.warning("model url created but file don't seems to exists: \(url)")
            return nil
        }

        return url
    }

    /// URL for root folder of captured object.
    /// Assembled URL based on ``captureRootFolderPathComponentString``
    var capturedObjectRootURL: URL? {
        guard let documentUrl = CapturedObject.getDocumentsDirectory() else {
            logger.warning("Fail to create root scan folder because documents directory couldn't be found")
            return nil
        }

        let rootScanUrl = documentUrl.appendingPathComponent(captureRootFolderPathComponentString)

        guard rootScanUrl.isDirectory else {
            logger.warning("Root Scan URL created but directory don't seems to exists: \(rootScanUrl)")
            return nil
        }

        return rootScanUrl
    }

    var imageFolderURL: URL? {
        guard let url = capturedObjectRootURL?.appendingPathComponent("Images/") else {
            logger.warning("Fail to create images folder because root scan directory is nil")
            return nil
        }
        
        guard url.isDirectory else {
            logger.warning("Images url created but directory don't seems to exists: \(url)")
            return nil
        }
        
        return url
    }

    var snapshotsFolderURL: URL? {
        guard let url = capturedObjectRootURL?.appendingPathComponent("Snapshots/") else {
            logger.warning("Fail to create snapshot folder because root scan directory is nil")
            return nil
        }
        
        guard url.isDirectory else {
            logger.warning("Snapshot url created but directory don't seems to exists: \(url)")
            return nil
        }
        
        return url
    }

    var modelsFolderURL: URL? {
        guard let url = capturedObjectRootURL?.appendingPathComponent("Models/") else {
            logger.warning("Fail to create models folder because root scan directory is nil")
            return nil
        }
        
        guard url.isDirectory else {
            logger.warning("Models url created but directory don't seems to exists: \(url)")
            return nil
        }
        
        return url
    }
    
    @Attribute(.ephemeral) var thumbnail : UIImage? {
        set {
            self.thumbnailData = newValue?.pngData()
        } get {
            guard let data = self.thumbnailData else {
                return nil
            }
            return UIImage(data: data)
        }
    }
    
    @Attribute(.ephemeral) var previewImage : UIImage? {
        set {
            self.previewImageData = newValue?.pngData()
        } get {
            guard let data = self.previewImageData else {
                return nil
            }
            
            return UIImage(data: data)
        }
    }
    
    @Attribute(.ephemeral) var modelNode: SCNNode? {
        guard let modelURL else {
            return nil
        }
        let asset = MDLAsset(url: modelURL)
        asset.loadTextures()
        let object = asset.object(at: 0)
        let node = SCNNode(mdlObject: object)
        
        return node
    }
    
    
    /// Create a new captured object with the name and the filename you specify
    /// - Parameters:
    ///   - filename: the name of the `.usdz` model file that will be saved to disk
    ///   - id: optional UUID, if not assigned a random UUID will be automatically generated
    ///   - relativePath:
    ///   An alias of  ``captureRootFolderPathComponentString``.
    ///   This is a string of a path component that will be used to build full URL of
    ///   captured object's Root folder.
    ///   The PATH should look like: ``"Scans/2000-01-01T01-01-01Z"``
    ///       - Note: This should not be the full path but a segment of the full path relative path
    init(_ filename: String, id: UUID = UUID(), at relativePath: String) {
        self.id = id
        self.filename = filename
        self.captureRootFolderPathComponentString = relativePath
    }

    static func generateThumbnailFromURL(with modelURL: URL, size: CGSize, completion: @escaping (UIImage?) -> Void) {
        let request = QLThumbnailGenerator.Request(fileAt: modelURL, size: size, scale: 1.0, representationTypes: .thumbnail)

        let generator = QLThumbnailGenerator.shared
        generator.generateRepresentations(for: request) { thumbnail, _, error in
            DispatchQueue.main.async {
                if thumbnail == nil || error != nil {
                    logger.warning("Couldn't generate thumbnail \(error)")
                    completion(nil)
                } else {
                    completion(thumbnail?.uiImage)
                }
            }
        }
    }

    private static func extractPath(from url: URL, after targetDirectory: String) -> String? {
        let pathComponents = url.pathComponents

        // Finding the index of the target directory
        guard let targetIndex = pathComponents.firstIndex(of: targetDirectory) else { return nil }

        // Extracting the path from the target directory onwards
        let requiredPathComponents = pathComponents[targetIndex...]
        let requiredPath = requiredPathComponents.joined(separator: "/")

        return requiredPath
    }

    private static func getDocumentsDirectory() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }

}

fileprivate let logger = Logger(subsystem: OrganizeApp.bundleId, category: "CapturedObject")
