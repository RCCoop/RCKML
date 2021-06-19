//
//  KMLPoint.swift
//  KMLTester
//
//  Created by Ryan Linn on 6/17/21.
//

import Foundation
import AEXML

struct KMLPoint {
    var coordinate: KMLCoordinate
}

//MARK: KMLElement

extension KMLPoint : KmlElement {

    init(xml: AEXMLElement) throws {
        try Self.verifyXmlTag(xml)
        let coordElement = try xml.requiredKmlChild(ofType: KMLCoordinateSequence.self)
        guard let firstCoord = coordElement.coordinates.first
        else {
            throw KMLError.missingRequiredElement(elementName: "coordinates")
        }
        
        self.coordinate = firstCoord
    }

}

//MARK: KMLGeometry

extension KMLPoint : KMLGeometry {
    static var geometryType: KMLGeometryType {
        .Point
    }
}
