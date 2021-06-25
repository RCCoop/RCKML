//
//  KMLMultiGeometry.swift
//  KMLTester
//
//  Created by Ryan Linn on 6/18/21.
//

import Foundation
import AEXML

struct KMLMultiGeometry {
    var geometries: [KMLGeometry]
}

//MARK: KMLElement

extension KMLMultiGeometry: KmlElement {
    
    init(xml: AEXMLElement) throws {
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
    
    var xmlElement: AEXMLElement {
        let element = AEXMLElement(name: Self.kmlTag)
        for geo in geometries {
            element.addChild(geo.xmlElement)
        }
        return element
    }
}

//MARK: KMLGeometry

extension KMLMultiGeometry: KMLGeometry {
    static var geometryType: KMLGeometryType { .MultiGeometry }
}
