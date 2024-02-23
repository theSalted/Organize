//
//  Item.swift
//  Organize
//
//  Created by Yuhao Chen on 1/21/24.
//

import Foundation
import SwiftData
import SwiftUI
import RoomPlan
import CoreLocation

@Model
final class Space : Identifiable, Meta {
    var id: UUID
    var name: String
    var createdAt : Date
    var pattern: PatternDesign
    @Relationship(deleteRule: .cascade, inverse: \Storage.space)
    var storages = [Storage]()
    var _location: CodableLocation?
//    var location: CLLocationCoordinate2D?
    
    private var _colorComponents : ColorComponents
    private var systemImage: String?
    private var emoji: String?
    
    @Attribute(.externalStorage) var imageData: Data?
    
    @Transient var location: CLLocationCoordinate2D? {
        get {
            guard let latitude = _location?.latitude, let longitude = _location?.longitude else {
                return nil
            }
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        
        set {
            if let newValue {
                _location = .init(latitude: newValue.latitude, longitude: newValue.longitude)
            }
            _location = nil
        }
    }
    
    @Transient var image: UIImage? {
        get {
            if let data = imageData,
               let uiImage = UIImage(data: data) {
                return uiImage
            }
            return nil
        }
        set {
            imageData = newValue?.pngData()
        }
    }
   
    // TODO: Find a way to save `CapturedRoom.Object`
    
    var symbol: String {
        get {
            if let systemImage {
                return systemImage
            } else if let emoji {
                return emoji
            } else {
                systemImage = "square.split.bottomrightquarter"
                return systemImage!
            }
        }
        
        set {
            if newValue.isSingleEmoji {
                systemImage = nil
                emoji = newValue
            } else {
                emoji = nil
                systemImage = newValue
            }
        }
    }
    
    @Transient var color : Color {
        get { _colorComponents.color }
        set { _colorComponents = ColorComponents.fromColor(newValue) }
    }
    
    @Transient lazy var storedIn: String? = {
        nil
    }()
    
    init(name: String = "Untitled", symbol : String = "square.split.bottomrightquarter") {
        self.name = name
        self.id = UUID()
        self.createdAt = Date()
        self.pattern = PatternDesign.getRandomDesign()
        self._colorComponents = ColorComponents.fromColor(templateColors.randomElement(or: .accent))
        self.symbol = symbol
    }
}
