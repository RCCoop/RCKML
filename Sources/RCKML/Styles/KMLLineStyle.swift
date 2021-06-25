//
//  KMLLineStyle.swift
//  KMLTester
//
//  Created by Ryan Linn on 6/18/21.
//

import Foundation
import AEXML

struct KMLLineStyle {
    var id: String?
    var width: Double
    var color: KMLColor?
}

extension KMLLineStyle: KmlElement {
    static var kmlTag: String {
        "LineStyle"
    }
    
    init(xml: AEXMLElement) throws {
        try Self.verifyXmlTag(xml)
        self.id = xml.attributes["id"]
        self.width = xml.optionalXmlChild(name: "width")?.double! ?? 1.0
        self.color = xml.optionalKmlChild(ofType: KMLColor.self)
    }
    
    var xmlElement: AEXMLElement {
        let element = AEXMLElement(name: Self.kmlTag, attributes: Self.xmlAttributesWithId(id))
        element.addChild(name: "width", value: String(format: "%.1f", width))
        let _ = color.map({ element.addChild($0.xmlElement) })
        return element
    }
}

extension KMLLineStyle: KMLColorStyle {}
