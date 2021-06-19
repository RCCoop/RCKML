//
//  KMLStyleMap.swift
//  KMLTester
//
//  Created by Ryan Linn on 6/18/21.
//

import Foundation
import AEXML

struct KMLStyleMap {
    var id: String?
    var styleUrl: KMLStyleUrl?
    var style: KMLStyle?
//    var highlighted: KMLStyleUrl //ignore highlighted    
}
extension KMLStyleMap: KmlElement, KMLStyleSelector {
    static var kmlTag: String {
        "StyleMap"
    }
    
    init(xml: AEXMLElement) throws {
        try? Self.verifyXmlTag(xml)
        self.id = xml.attributes["id"]
        if let normalPair = xml.children.first(where: { $0["key"].string == "normal" }) {
            if let styleUrl = normalPair.optionalKmlChild(ofType: KMLStyleUrl.self) {
                self.styleUrl = styleUrl
            } else if let style = normalPair.optionalKmlChild(ofType: KMLStyle.self) {
                self.style = style
            }
        }
    }
    
}

