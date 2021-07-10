//
//  KMLPolygon.swift
//  RCKML
//
//  Created by Ryan Linn on 6/17/21.
//

import Foundation
import AEXML

/// A geometry representing an enclosed region, possibly including
/// inner boundaries as well.
///
/// For reference, see [KML Documentation](https://developers.google.com/kml/documentation/kmlreference#polygon)
public struct KMLPolygon {
    
    /// The outer boundary of the polygon.
    public let outerBoundaryIs: LinearRing
    
    /// An optional array of internal boundaries inside the
    /// polygon, which represent holes in the polygon.
    public let innerBoundaryIs: [LinearRing]?
    
}

//MARK: KMLElement

extension KMLPolygon : KmlElement {
    
    private static var outerBoundaryKey: String { "outerBoundaryIs" }
    private static var innerBoundaryKey: String { "innerBoundaryIs" }
    
    public init(xml: AEXMLElement) throws {
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
    
    public var xmlElement: AEXMLElement {
        let element = AEXMLElement(name: Self.kmlTag)
        
        //Outer Boundary Ring
        let outerRingElement = AEXMLElement(name: Self.outerBoundaryKey)
        outerRingElement.addChild(outerBoundaryIs.xmlElement)
        element.addChild(outerRingElement)
        
        innerBoundaryIs?.forEach({ innerBound in
            let innerElement = AEXMLElement(name: Self.innerBoundaryKey)
            innerElement.addChild(innerBound.xmlElement)
            element.addChild(innerElement)
        })
        
        return element
    }
}

//MARK: KMLGeometry

extension KMLPolygon : KMLGeometry {
    public static var geometryType: KMLGeometryType { .Polygon }
}

//MARK:- Linear Ring

extension KMLPolygon {
    /// A closed version of LineString, where the first
    /// and last points connect, forming an enclosed area.
    ///
    /// For reference, see [KML Documentation](https://developers.google.com/kml/documentation/kmlreference#polygon)
    public struct LinearRing {
        public let coordinates: [KMLCoordinate]
    }
}

//MARK: KMLElement

extension KMLPolygon.LinearRing : KmlElement {
    public static var kmlTag: String {
        "LinearRing"
    }
    
    public init(xml: AEXMLElement) throws {
        try Self.verifyXmlTag(xml)
        let kmlCoords = try xml.requiredKmlChild(ofType: KMLCoordinateSequence.self)
        self.coordinates = kmlCoords.coordinates
    }
    
    public var xmlElement: AEXMLElement {
        let element = AEXMLElement(name: Self.kmlTag)
        element.addChild(KMLCoordinateSequence(coordinates: coordinates).xmlElement)
        return element
    }
}
