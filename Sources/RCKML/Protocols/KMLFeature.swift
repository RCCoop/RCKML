//
//  KMLFeature.swift
//  KMLTester
//
//  Created by Ryan Linn on 6/18/21.
//

import Foundation
import AEXML

protocol KMLFeature : KmlElement {
    var name: String { get }
    var description: String? { get }
}

extension KMLFeature {
    static func nameFromXml(_ xml:AEXMLElement) throws -> String {
        try xml.requiredXmlChild(name: "name").string
    }
    
    static func descriptionFromXml(_ xml:AEXMLElement) -> String? {
        xml.optionalXmlChild(name: "description")?.string
    }
}
