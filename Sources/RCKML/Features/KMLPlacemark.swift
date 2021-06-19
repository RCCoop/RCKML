//
//  KMLPlacemark.swift
//  KMLTester
//
//  Created by Ryan Linn on 6/17/21.
//

import Foundation
import AEXML

struct KMLPlacemark {
    var name: String
    var description: String?
    var geometry: KMLGeometry
    
    var styleUrl: KMLStyleUrl?
    var style: KMLStyle?
}

extension KMLPlacemark : KmlElement {
    static var kmlTag: String {
        "Placemark"
    }
    
    init(xml: AEXMLElement) throws {
        try Self.verifyXmlTag(xml)
        self.name = try Self.nameFromXml(xml)
        self.description = Self.descriptionFromXml(xml)
        guard let childGeometryType = KMLGeometryType.allCases.first(where: { xml[$0.rawValue].error == nil })
        else {
            throw KMLError.missingRequiredElement(elementName: "Geometry")
        }
        let childGeometry = try childGeometryType.concreteType.init(xml: xml[childGeometryType.rawValue])
        if let multiGeom = childGeometry as? KMLMultiGeometry,
           multiGeom.geometries.count == 1 {
            self.geometry = multiGeom.geometries[0]
        } else {
            self.geometry = childGeometry
        }
        
        if let style = xml.optionalKmlChild(ofType: KMLStyle.self) {
            self.style = style
        } else if let styleUrl = xml.optionalKmlChild(ofType: KMLStyleUrl.self) {
            self.styleUrl = styleUrl
        }
    }
    
}

extension KMLPlacemark : KMLFeature {
    
}
