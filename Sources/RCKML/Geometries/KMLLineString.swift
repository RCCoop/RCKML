//
//  KMLLineString.swift
//  RCKML
//
//  Created by Ryan Linn on 6/17/21.
//

import Foundation
import AEXML

/// A series of KMLCoordinates connected in order to form
/// a line on the map.
///
/// For reference, see [KML Documentation](https://developers.google.com/kml/documentation/kmlreference#linestring)
public struct KMLLineString {
    public let coordinates: [KMLCoordinate]
}

//MARK: KMLElement

extension KMLLineString : KmlElement {
    
    public init(xml: AEXMLElement) throws {
        try Self.verifyXmlTag(xml)
        let kmlCoords = try xml.requiredKmlChild(ofType: KMLCoordinateSequence.self)
        self.coordinates = kmlCoords.coordinates
    }
    
    public var xmlElement: AEXMLElement {
        let element = AEXMLElement(name: Self.kmlTag)
        let coordRep = KMLCoordinateSequence(coordinates: coordinates)
        element.addChild(coordRep.xmlElement)
        return element
    }
    
}

//MARK: KMLGeometry

extension KMLLineString : KMLGeometry {
    public static var geometryType: KMLGeometryType {
        .LineString
    }
}
