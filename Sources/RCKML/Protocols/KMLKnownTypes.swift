//
//  KMLKnownTypes.swift
//  RCKML
//
//  Created by Ryan Linn on 6/18/21.
//

import Foundation
import AEXML

//TODO: Documentation

//MARK:- Known Geometry Types

enum KMLGeometryType: String, CaseIterable {
    case LineString
    case Polygon
    case Point
    case MultiGeometry
    
    var concreteType: KMLGeometry.Type {
        switch self {
        case .LineString:
            return KMLLineString.self
        case .Polygon:
            return KMLPolygon.self
        case .Point:
            return KMLPoint.self
        case .MultiGeometry:
            return KMLMultiGeometry.self
        }
    }

}

//MARK:- Known Feature Types
enum KMLFeatureType : String, CaseIterable {
    case Folder
    case Placemark
    
    var concreteType: KMLFeature.Type {
        switch self {
        case .Folder:
            return KMLFolder.self
        case .Placemark:
            return KMLPlacemark.self
        }
    }
    
    static func elementIsRecognizedType(_ xml:AEXMLElement) -> Bool {
        guard let type = KMLFeatureType(rawValue: xml.name) else {
            return false
        }
        
        if type == .Placemark,
           xml.children.first(where: { KMLGeometryType(rawValue: $0.name) != nil }) == nil {
            return false
        }
        
        return true
    }
}
