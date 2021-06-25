//
//  KMLPolyStyle.swift
//  KMLTester
//
//  Created by Ryan Linn on 6/18/21.
//

import Foundation
import AEXML

struct KMLPolyStyle {
    var id: String?
    var fill: Bool
    var outline: Bool
    var color: KMLColor?
}

extension KMLPolyStyle: KmlElement {
    static var kmlTag: String {
        "PolyStyle"
    }
    
    init(xml: AEXMLElement) throws {
        try Self.verifyXmlTag(xml)
        self.id = xml.attributes["id"]
        self.color = xml.optionalKmlChild(ofType: KMLColor.self)
        self.fill = xml["fill"].bool ?? true
        self.outline = xml["outline"].bool ?? true
    }
    
    var xmlElement: AEXMLElement {
        let element = AEXMLElement(name: Self.kmlTag, attributes: Self.xmlAttributesWithId(id))
        element.addChild(name: "fill", value: (fill ? "1" : "0"))
        element.addChild(name: "outline", value: (outline ? "1" : "0"))
        let _ = color.map({ element.addChild($0.xmlElement) })
        return element
    }
}

extension KMLPolyStyle: KMLColorStyle {
    
}

