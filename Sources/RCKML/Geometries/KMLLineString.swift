//
//  KMLLineString.swift
//  RCKML
//
//  Created by Ryan Linn on 6/17/21.
//

import AEXML
import Foundation

/// A series of KMLCoordinates connected in order to form
/// a line on the map.
///
/// For reference, see [KML Documentation](https://developers.google.com/kml/documentation/kmlreference#linestring)
public struct KMLLineString {
    public let coordinates: [KMLCoordinate]

    public init(coordinates: [KMLCoordinate]) {
        self.coordinates = coordinates
    }
}

// MARK: KMLElement

extension KMLLineString: KmlElement {
    public init(xml: AEXMLElement) throws {
        try Self.verifyXmlTag(xml)
        coordinates = try xml.requiredKmlChild(ofType: [KMLCoordinate].self)
    }

    public var xmlElement: AEXMLElement {
        let element = AEXMLElement(name: Self.kmlTag)
        element.addChild(coordinates.xmlElement)
        return element
    }
}

// MARK: KMLGeometry

extension KMLLineString: KMLGeometry {
    public static var geometryType: KMLGeometryType {
        .LineString
    }
}
