//
//  KMLStyleMap.swift
//  RCKML
//
//  Created by Ryan Linn on 6/18/21.
//

import AEXML
import Foundation

/// A wrapper around one or two KMLStyles to provide a standard and
/// a highlighted version for a given Feature.
///
/// This implementation only contains the standard (non-highlighted) style
/// option. The map can either contain a KMLStyleUrl or a KMLStyle, but
/// not both.
///
/// For definition, see [KML Spec](https://developers.google.com/kml/documentation/kmlreference#stylemap)
struct KMLStyleMap {
    var id: String?
    var styleUrl: KMLStyleUrl?
    var style: KMLStyle?
//    var highlighted: KMLStyleUrl //ignore highlighted

    public init(
        id: String? = nil,
        styleUrl: KMLStyleUrl? = nil,
        style: KMLStyle? = nil
    ) {
        self.id = id
        self.styleUrl = styleUrl
        self.style = style
    }
}

// MARK: - Internal StyleSelector Protocol Conformance

extension KMLStyleMap: KmlElement, KMLStyleSelector {
    static var kmlTag: String {
        "StyleMap"
    }

    init(xml: AEXMLElement) throws {
        try? Self.verifyXmlTag(xml)
        id = xml.attributes["id"]
        if let normalPair = xml.children.first(where: { $0["key"].string == "normal" }) {
            if let styleUrl = normalPair.optionalKmlChild(ofType: KMLStyleUrl.self) {
                self.styleUrl = styleUrl
            } else if let style = normalPair.optionalKmlChild(ofType: KMLStyle.self) {
                self.style = style
            }
        }
    }

    var xmlElement: AEXMLElement {
        let element = AEXMLElement(name: Self.kmlTag, attributes: Self.xmlAttributesWithId(id))
        if let style {
            element.addChild(style.xmlElement)
        }
        if let styleUrl {
            element.addChild(styleUrl.xmlElement)
        }
        return element
    }
}
