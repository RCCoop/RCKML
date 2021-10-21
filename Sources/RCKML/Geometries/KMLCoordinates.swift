//
//  KMLCoordinates.swift
//  RCKML
//
//  Created by Ryan Linn on 6/17/21.
//

import Foundation
import AEXML

//MARK:- Individual Coordinate Struct

/// A single point on Earth represented by latitude and longitude,
/// plus an optional altitude (expressed in meters above sea level).
///
/// In KML instances of KMLGeometry, coordinates are usually represented
/// as an array of KMLCoordinate, although in reading or writing
/// geometries to/from KML files they are stored as KMLCoordinateSequence.
///
/// - SeeAlso:
/// KMLCoordinateSequence
public struct KMLCoordinate {
    public let latitude: Double
    public let longitude: Double
    public let altitude: Double?
    
    public init(latitude: Double,
                longitude: Double,
                altitude: Double? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
    }
}

//MARK: CustomStringConvertible
extension KMLCoordinate: CustomStringConvertible {
    public var description: String {
        if let altitude = altitude {
            return String(format: "%6f,%.6f,%.1f", longitude, latitude, altitude)
        } else {
            return String(format: "%.6f,%.6f", longitude, latitude)
        }
    }
}

//MARK:- KMLCoordinateSequence

/// A wrapper around an array of KMLCoordinate used for storage
/// in KML files. This is generally only used in reading/writing
/// KML files, whereas the KMLGeometry structs in this library
/// would use an array of KMLCoordinate instead.
public struct KMLCoordinateSequence {
    public var coordinates: [KMLCoordinate]
    
    public init(coordinates: [KMLCoordinate]) {
        self.coordinates = coordinates
    }
}

//MARK: KmlElement
extension KMLCoordinateSequence: KmlElement {
    public static var kmlTag: String { "coordinates" }

    public init(xml: AEXMLElement) throws {
        try Self.verifyXmlTag(xml)
        self.coordinates = try Self.parseCoordinates(xml.string)
    }
    
    public var xmlElement: AEXMLElement {
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
