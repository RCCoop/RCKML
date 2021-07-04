//
//  KMLCoordinates.swift
//  RCKML
//
//  Created by Ryan Linn on 6/17/21.
//

import Foundation
import AEXML

//MARK:- Individual Coordinate Struct

//TODO: Documentation

struct KMLCoordinate {
    let latitude: Double
    let longitude: Double
    let altitude: Double?
}

extension KMLCoordinate: CustomStringConvertible {
    var description: String {
        if let altitude = altitude {
            return String(format: "%6f,%.6f,%.1f", longitude, latitude, altitude)
        } else {
            return String(format: "%.6f,%.6f", longitude, latitude)
        }
    }
}

//MARK:- KMLCoordinates XML Struct

struct KMLCoordinateSequence {
    var coordinates: [KMLCoordinate]
}

extension KMLCoordinateSequence: KmlElement {
    static var kmlTag: String { "coordinates" }

    init(xml: AEXMLElement) throws {
        try Self.verifyXmlTag(xml)
        self.coordinates = try Self.parseCoordinates(xml.string)
    }
    
    var xmlElement: AEXMLElement {
        AEXMLElement(name: Self.kmlTag, value: coordinates.map(\.description).joined(separator: "\n"))
    }
    
    private static func parseCoordinates(_ coordString:String) throws -> [KMLCoordinate] {
        let splits = coordString.components(separatedBy: .whitespacesAndNewlines)
        let coords = splits.compactMap { str -> KMLCoordinate? in
            if str.isEmpty { return nil }
            let components = str.components(separatedBy: ",")
            if components.count < 2 { return nil }

            let long = Double(components[0])!
            let lat = Double(components[1])!
            let alt = components.count > 2 ? Double(components[2]) : nil
            return KMLCoordinate(latitude: lat, longitude: long, altitude: alt)
        }
        
        if coords.isEmpty {
            throw KMLError.coordinateParseFailed
        }
        return coords
    }
}
