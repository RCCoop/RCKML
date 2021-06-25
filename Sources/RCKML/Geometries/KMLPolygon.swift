//
//  KMLPolygon.swift
//  KMLTester
//
//  Created by Ryan Linn on 6/17/21.
//

import Foundation
import AEXML

struct KMLPolygon {
        
    let outerBoundaryIs: LinearRing
    let innerBoundaryIs: [LinearRing]?
    
}

//MARK: KMLElement

extension KMLPolygon : KmlElement {
    
    private static var outerBoundaryKey: String { "outerBoundaryIs" }
    private static var innerBoundaryKey: String { "innerBoundaryIs" }
    
    init(xml: AEXMLElement) throws {
        try Self.verifyXmlTag(xml)
        
        let outerBoundsElement = try xml.requiredXmlChild(name: Self.outerBoundaryKey)
        let outerBoundsLineRing = try outerBoundsElement.requiredKmlChild(ofType: LinearRing.self)
        self.outerBoundaryIs = outerBoundsLineRing
                
        let innerBoundsElements = xml.children.filter({ $0.name == Self.innerBoundaryKey })
        if innerBoundsElements.isEmpty == false {
            self.innerBoundaryIs = innerBoundsElements.compactMap({ try? $0.requiredKmlChild(ofType: LinearRing.self) })
        } else {
            self.innerBoundaryIs = nil
        }
    }
    
    var xmlElement: AEXMLElement {
        let element = AEXMLElement(name: Self.kmlTag)
        element.addChild(name: Self.outerBoundaryKey, value: outerBoundaryIs.xmlElement.xml)
        innerBoundaryIs?.forEach({ oneInner in
            element.addChild(name: Self.innerBoundaryKey, value: oneInner.xmlElement.xml)
        })
        return element
    }
}

//MARK: KMLGeometry

extension KMLPolygon : KMLGeometry {
    static var geometryType: KMLGeometryType { .Polygon }
}

//MARK:- Linear Ring

extension KMLPolygon {
    struct LinearRing {
        let coordinates: [KMLCoordinate]
    }
}

//MARK: KMLElement

extension KMLPolygon.LinearRing : KmlElement {
    static var kmlTag: String {
        "LinearRing"
    }
    
    init(xml: AEXMLElement) throws {
        try Self.verifyXmlTag(xml)
        let kmlCoords = try xml.requiredKmlChild(ofType: KMLCoordinateSequence.self)
        self.coordinates = kmlCoords.coordinates
    }
    
    var xmlElement: AEXMLElement {
        let element = AEXMLElement(name: Self.kmlTag)
        element.addChild(KMLCoordinateSequence(coordinates: coordinates).xmlElement)
        return element
    }
}
