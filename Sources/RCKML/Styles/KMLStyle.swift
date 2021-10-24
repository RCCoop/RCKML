//
//  KMLStyle.swift
//  RCKML
//
//  Created by Ryan Linn on 6/18/21.
//

import AEXML
import Foundation

/// A wrapper around possible KML style types used to determine
/// drawing behavior for an object, referenced either inside a
/// KMLFeature, or from a KMLStyleMap by its id.
///
/// A KMLStyle can contain up to one of each type of KMLColorStyle,
/// plus ListStyle.
///
/// For definition, see [KML Spec](https://developers.google.com/kml/documentation/kmlreference#style)
public struct KMLStyle {
    public var id: String?
    public var lineStyle: KMLLineStyle?
    public var polyStyle: KMLPolyStyle?

    public var isEmpty: Bool {
        if lineStyle == nil, polyStyle == nil {
            return true
        } else if lineStyle?.color == nil, polyStyle?.color == nil {
            return true
        }
        return false
    }
}

// MARK: - Internal StyleSelector Protocol Conformance

extension KMLStyle: KmlElement, KMLStyleSelector {
    public static var kmlTag: String {
        "Style"
    }

    public init(xml: AEXMLElement) throws {
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

    public var xmlElement: AEXMLElement {
        let element = AEXMLElement(name: Self.kmlTag, attributes: Self.xmlAttributesWithId(id))
        _ = lineStyle.map { element.addChild($0.xmlElement) }
        _ = polyStyle.map { element.addChild($0.xmlElement) }
        return element
    }
}
