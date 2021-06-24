//
//  KMLStyle.swift
//  KMLTester
//
//  Created by Ryan Linn on 6/18/21.
//

import Foundation
import AEXML

struct KMLStyle {
    var id: String?
    var lineStyle: KMLLineStyle?
    var polyStyle: KMLPolyStyle?
    
    var isEmpty: Bool {
        if lineStyle == nil && polyStyle == nil {
            return true
        } else if lineStyle?.color == nil && polyStyle?.color == nil {
            return true
        }
        return false
    }
}

extension KMLStyle: KmlElement, KMLStyleSelector {
    static var kmlTag: String {
        "Style"
    }
    
    init(xml: AEXMLElement) throws {
        try Self.verifyXmlTag(xml)
        self.id = xml.attributes["id"]
        
        let lineStyleElement = xml[KMLLineStyle.kmlTag]
        if lineStyleElement.error == nil {
            self.lineStyle = try KMLLineStyle(xml: lineStyleElement)
        }
        
        let polyStyleElement = xml[KMLPolyStyle.kmlTag]
        if polyStyleElement.error == nil {
            self.polyStyle = try KMLPolyStyle(xml: polyStyleElement)
        }
    }
}
