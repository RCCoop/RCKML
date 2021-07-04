//
//  KMLStyleUrl.swift
//  RCKML
//
//  Created by Ryan Linn on 6/18/21.
//

import Foundation
import AEXML

//TODO: Documentation

struct KMLStyleUrl: Hashable {
    var styleUrl: String
}

extension KMLStyleUrl: KMLStyleSelector {
    var id: String? { nil }
    
    static var kmlTag: String {
        "styleUrl"
    }
    
    init(xml: AEXMLElement) throws {
        try Self.verifyXmlTag(xml)
        var urlString = xml.string
        if urlString.first == "#" {
            urlString.removeFirst()
        }
        self.styleUrl = urlString
    }
    
    var xmlElement: AEXMLElement {
        AEXMLElement(name: Self.kmlTag, value: "#" + styleUrl)
    }
    
}
