//
//  KMLPolyStyle.swift
//  RCKML
//
//  Created by Ryan Linn on 6/18/21.
//

import AEXML
import Foundation

/// A style used to determine fill color and whether to draw the outline of a polygon.
///
/// For definition, see [KML Spec](https://developers.google.com/kml/documentation/kmlreference#polystyle)
public struct KMLPolyStyle {
    public var id: String?
    public var isFilled: Bool
    public var isOutlined: Bool
    public var color: KMLColor?

    public init(
        id: String?,
        isFilled: Bool = false,
        isOutlined: Bool = true,
        color: KMLColor? = nil
    ) {
        self.id = id
        self.isFilled = isFilled
        self.isOutlined = isOutlined
        self.color = color
    }
}

// MARK: - KmlElement

extension KMLPolyStyle: KmlElement {
    public static var kmlTag: String {
        "PolyStyle"
    }

    public init(xml: AEXMLElement) throws {
        try Self.verifyXmlTag(xml)
        id = xml.attributes["id"]
        color = xml.optionalKmlChild(ofType: KMLColor.self)
        isFilled = xml["fill"].bool ?? true
        isOutlined = xml["outline"].bool ?? true
    }

    public var xmlElement: AEXMLElement {
        let element = AEXMLElement(name: Self.kmlTag, attributes: Self.xmlAttributesWithId(id))
        element.addChild(name: "fill", value: isFilled ? "1" : "0")
        element.addChild(name: "outline", value: isOutlined ? "1" : "0")
        _ = color.map { element.addChild($0.xmlElement) }
        return element
    }
}

// MARK: - KMLColorStyle

extension KMLPolyStyle: KMLColorStyle {}
