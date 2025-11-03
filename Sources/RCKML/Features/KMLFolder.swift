//
//  KMLFolder.swift
//  RCKML
//
//  Created by Ryan Linn on 6/17/21.
//

import AEXML
import Foundation

/// A feature to be included in KML files, which can contain any number of
/// other KML features, including sub-folders.
///
/// For reference, see [KML Spec](https://developers.google.com/kml/documentation/kmlreference#folder)
public struct KMLFolder {
    public var name: String?
    public var featureDescription: String?
    public var features: [KMLFeature]

    public init(
        name: String? = nil,
        featureDescription: String? = nil,
        features: [KMLFeature] = []
    ) {
        self.name = name
        self.featureDescription = featureDescription
        self.features = features
    }
}

// MARK: - KmlElement

extension KMLFolder: KmlElement {
    public static var kmlTag: String {
        "Folder"
    }

    public init(xml: AEXMLElement) throws {
        try Self.verifyXmlTag(xml)
        name = Self.nameFromXml(xml)
        featureDescription = Self.descriptionFromXml(xml)
        features = try Self.features(from: xml)
    }

    public var xmlElement: AEXMLElement {
        let element = AEXMLElement(name: Self.kmlTag)
        element.addChild(name: "name", value: name)
        if let featureDescription {
            element.addChild(name: "description", value: featureDescription)
        }
        for item in features {
            element.addChild(item.xmlElement)
        }

        return element
    }
}

// MARK: - KMLFeature

extension KMLFolder: KMLFeature {}

// MARK: - KMLContainer

extension KMLFolder: KMLContainer {}
