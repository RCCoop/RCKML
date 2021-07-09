//
//  KMLPolyStyle.swift
//  RCKML
//
//  Created by Ryan Linn on 6/18/21.
//

import Foundation
import AEXML

/// A style used to determine fill color and whether to draw the outline of a polygon.
///
/// For definition, see [KML Spec](https://developers.google.com/kml/documentation/kmlreference#polystyle)
public struct KMLPolyStyle {
    public var id: String?
    public var isFilled: Bool
    public var isOutlined: Bool
    public var color: KMLColor?
}

//MARK:- KmlElement
extension KMLPolyStyle: KmlElement {
    public static var kmlTag: String {
        "PolyStyle"
    }
    
    public init(xml: AEXMLElement) throws {
        try Self.verifyXmlTag(xml)
        self.id = xml.attributes["id"]
        self.color = xml.optionalKmlChild(ofType: KMLColor.self)
        self.isFilled = xml["fill"].bool ?? true
        self.isOutlined = xml["outline"].bool ?? true
    }
    
    public var xmlElement: AEXMLElement {
        let element = AEXMLElement(name: Self.kmlTag, attributes: Self.xmlAttributesWithId(id))
        element.addChild(name: "fill", value: (isFilled ? "1" : "0"))
        element.addChild(name: "outline", value: (isOutlined ? "1" : "0"))
        let _ = color.map({ element.addChild($0.xmlElement) })
        return element
    }
}

//MARK:- KMLColorStyle
extension KMLPolyStyle: KMLColorStyle {}

