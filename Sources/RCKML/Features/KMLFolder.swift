//
//  KMLFolder.swift
//  RCKML
//
//  Created by Ryan Linn on 6/17/21.
//

import Foundation
import AEXML

/// A feature to be included in KML files, which can contain any number of
/// other KML features, including sub-folders.
///
/// For reference, see [KML Spec](https://developers.google.com/kml/documentation/kmlreference#folder)
public struct KMLFolder {
    public var name: String
    public var description: String?
    public var features: [KMLFeature]
    
    public init(name: String,
                description: String? = nil,
                features: [KMLFeature] = []) {
        self.name = name
        self.description = description
        self.features = features
    }
}

//MARK:- KmlElement
extension KMLFolder : KmlElement {
    public static var kmlTag: String {
        "Folder"
    }
    
    public init(xml: AEXMLElement) throws {
        try Self.verifyXmlTag(xml)
        self.name = try Self.nameFromXml(xml)
        self.description = Self.descriptionFromXml(xml)
        self.features = try Self.features(from: xml)
    }
    
    public var xmlElement: AEXMLElement {
        let element = AEXMLElement(name: Self.kmlTag)
        element.addChild(name: "name", value: name)
        let _ = description.map({ element.addChild(name: "description", value: $0) })
        for item in features {
            element.addChild(item.xmlElement)
        }
        return element
    }
}

//MARK:- KMLFeature
extension KMLFolder : KMLFeature {}

//MARK:- KMLContainer
extension KMLFolder: KMLContainer {}
