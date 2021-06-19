//
//  KMLLineString.swift
//  KMLTester
//
//  Created by Ryan Linn on 6/17/21.
//

import Foundation
import AEXML

struct KMLLineString {
    
    let coordinates: [KMLCoordinate]
    
}

//MARK: KMLElement

extension KMLLineString : KmlElement {
    
    init(xml: AEXMLElement) throws {
        try Self.verifyXmlTag(xml)
        let kmlCoords = try xml.requiredKmlChild(ofType: KMLCoordinateSequence.self)
        self.coordinates = kmlCoords.coordinates
    }
    
}

//MARK: KMLGeometry

extension KMLLineString : KMLGeometry {
    static var geometryType: KMLGeometryType {
        .LineString
    }
}
