//
//  KMLLineString.swift
//  RCKML
//
//  Created by Ryan Linn on 6/17/21.
//

import Foundation
import AEXML

//TODO: Documentation

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
    
    var xmlElement: AEXMLElement {
        let element = AEXMLElement(name: Self.kmlTag)
        let coordRep = KMLCoordinateSequence(coordinates: coordinates)
        element.addChild(coordRep.xmlElement)
        return element
    }
    
}

//MARK: KMLGeometry

extension KMLLineString : KMLGeometry {
    static var geometryType: KMLGeometryType {
        .LineString
    }
}
