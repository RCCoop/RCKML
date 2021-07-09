//
//  KMLMultiGeometry.swift
//  RCKML
//
//  Created by Ryan Linn on 6/18/21.
//

import Foundation
import AEXML


/// A geometry type representing a collection of other geometries.
///
/// For reference, see [KML Documentation](https://developers.google.com/kml/documentation/kmlreference#multigeometry)
public struct KMLMultiGeometry {
    public var geometries: [KMLGeometry]
}

//MARK: KMLElement

extension KMLMultiGeometry: KmlElement {
    
    public init(xml: AEXMLElement) throws {
        try Self.verifyXmlTag(xml)
        geometries = try xml.children.compactMap({ xmlChild -> KMLGeometry? in
            guard let type = KMLGeometryType(rawValue: xmlChild.name)
            else {
                return nil
            }
            let object = try type.concreteType.init(xml: xmlChild)
            return object
        })
    }
    
    public var xmlElement: AEXMLElement {
        let element = AEXMLElement(name: Self.kmlTag)
        for geo in geometries {
            element.addChild(geo.xmlElement)
        }
        return element
    }
}

//MARK: KMLGeometry

extension KMLMultiGeometry: KMLGeometry {
    public static var geometryType: KMLGeometryType { .MultiGeometry }
}
