//
//  KMLPlacemark.swift
//  RCKML
//
//  Created by Ryan Linn on 6/17/21.
//

import AEXML
import Foundation

/// A Feature that is associated with a Geometry, and the main tool
/// in a KML file. A placemark includes a Geometry object, and any
/// descriptive information about it.
///
/// For reference, see [KML Spec](https://developers.google.com/kml/documentation/kmlreference#placemark)
public struct KMLPlacemark {
    public var name: String
    public var description: String?
    public var geometry: KMLGeometry

    public var styleUrl: KMLStyleUrl?
    public var style: KMLStyle?

    public init(name: String,
                description: String? = nil,
                geometry: KMLGeometry,
                styleUrl: KMLStyleUrl? = nil,
                style: KMLStyle? = nil)
    {
        self.name = name
        self.description = description
        self.geometry = geometry
        self.styleUrl = styleUrl
        self.style = style
    }
}

// MARK: - KmlElement

extension KMLPlacemark: KmlElement {
    public static var kmlTag: String {
        "Placemark"
    }

    public init(xml: AEXMLElement) throws {
        try Self.verifyXmlTag(xml)
        self.name = try Self.nameFromXml(xml)
        self.description = Self.descriptionFromXml(xml)
        guard let childGeometryType = KMLGeometryType.allCases.first(where: { xml[$0.rawValue].error == nil })
        else {
            throw KMLError.missingRequiredElement(elementName: "Geometry")
        }
        let childGeometry = try childGeometryType.concreteType.init(xml: xml[childGeometryType.rawValue])
        if let multiGeom = childGeometry as? KMLMultiGeometry,
           multiGeom.geometries.count == 1
        {
            self.geometry = multiGeom.geometries[0]
        } else {
            self.geometry = childGeometry
        }

        if let style = xml.optionalKmlChild(ofType: KMLStyle.self) {
            self.style = style
        } else if let styleUrl = xml.optionalKmlChild(ofType: KMLStyleUrl.self) {
            self.styleUrl = styleUrl
        }
    }

    public var xmlElement: AEXMLElement {
        let element = AEXMLElement(name: Self.kmlTag)
        element.addChild(name: "name", value: name)
        _ = description.map { element.addChild(name: "description", value: $0) }
        element.addChild(geometry.xmlElement)
        _ = styleUrl.map { element.addChild($0.xmlElement) }
        _ = style.map { element.addChild($0.xmlElement) }
        return element
    }
}

// MARK: - KMLFeature

extension KMLPlacemark: KMLFeature {}
