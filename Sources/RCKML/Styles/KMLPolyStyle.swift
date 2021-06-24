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
    
    
}

extension KMLPolyStyle: KMLColorStyle {
    
}

