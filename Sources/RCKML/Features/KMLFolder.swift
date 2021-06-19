//
//  KMLFolder.swift
//  KMLTester
//
//  Created by Ryan Linn on 6/17/21.
//

import Foundation
import AEXML

struct KMLFolder {
    var name: String
    var description: String?
    var features: [KMLFeature]
}

extension KMLFolder : KmlElement {
    static var kmlTag: String {
        "Folder"
    }
    
    init(xml: AEXMLElement) throws {
        try Self.verifyXmlTag(xml)
        self.name = try Self.nameFromXml(xml)
        self.description = Self.descriptionFromXml(xml)
        self.features = try Self.features(from: xml)
    }
    
    
}

extension KMLFolder : KMLFeature {
    
}

extension KMLFolder: KMLContainer {
    
}
