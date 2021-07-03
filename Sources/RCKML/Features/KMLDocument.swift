//
//  KMLDocument.swift
//  KMLTester
//
//  Created by Ryan Linn on 6/18/21.
//

import Foundation
import AEXML

struct KMLDocument {
    var name: String?
    var description: String?
    var features: [KMLFeature]
    var styles: [KMLStyleUrl: KMLStyleSelector]
}

extension KMLDocument : KmlElement {
    static var kmlTag: String {
        "Document"
    }
    
    init(xml: AEXMLElement) throws {
        try Self.verifyXmlTag(xml)
        self.features = try Self.features(from: xml)
        self.name = xml.optionalXmlChild(name: "name")?.string
        self.styles = try Self.kmlStylesInElement(xml)
        self.description = xml.optionalXmlChild(name: "description")?.string
    }
    
    func getStyleFromUrl(_ styleUrl: KMLStyleUrl) -> KMLStyle? {
        if let aSelector = styles[styleUrl] {
            if let aStyle = aSelector as? KMLStyle {
                return aStyle
            } else if let aMap = aSelector as? KMLStyleMap {
                if let mappedStyle = aMap.style {
                    return mappedStyle
                } else if let mappedUrl = aMap.styleUrl {
                    return getStyleFromUrl(mappedUrl)
                }
            }
        }
        return nil
    }
    
    var xmlElement: AEXMLElement {
        let element = AEXMLElement(name: Self.kmlTag)
        let _ = name.map({ element.addChild(name: "name", value: $0) })
        let _ = description.map({ element.addChild(name: "description", value: $0) })
        
        for (_, style) in styles {
            element.addChild(style.xmlElement)
        }
        
        for item in features {
            element.addChild(item.xmlElement)
        }
        
        return element
    }
    
}

extension KMLDocument: KMLContainer {}

extension KMLDocument {
    func kmlString() -> String {
        let xmlDoc = AEXMLDocument()
        let kmlRoot = xmlDoc.addChild(name: "kml", attributes: ["xmlns": "http://www.opengis.net/kml/2.2"])
        kmlRoot.addChild(xmlElement)
        return xmlDoc.xml
    }
    
    func kmlData() -> Data? {
        kmlString().data(using: .utf8)
    }
}

extension KMLDocument {
    
    init(data: Data) throws {
        let xmlDoc = try AEXMLDocument(xml: data)
        guard let documentElement = xmlDoc.firstDescendant(where: { $0.name == Self.kmlTag }) else {
            throw KMLError.missingRequiredElement(elementName: "Document")
        }
        if let kmlError = documentElement.error {
            throw kmlError
        }
        try self.init(xml: documentElement)
    }
    
    init(kmlString: String) throws {
        guard let data = kmlString.data(using: .utf8) else {
            throw KMLError.missingRequiredElement(elementName: "xml")
        }
        try self.init(data: data)
    }
    
    init(url: URL) throws {
        let data = try Data(contentsOf: url)
        try self.init(data: data)
    }
    
    private static func kmlStylesInElement(_ xmlElement:AEXMLElement) throws -> [KMLStyleUrl:KMLStyleSelector] {
        //return array of StyleMap and Style
        let styleMaps = try xmlElement[KMLStyleMap.kmlTag].all?.map({ try KMLStyleMap(xml: $0) }) ?? []
        let styleElements = xmlElement[KMLStyle.kmlTag].all ?? []
        let styles = styleElements.compactMap({ try? KMLStyle(xml: $0) })
        let all: [KMLStyleSelector] = styles + styleMaps
        return all.reduce(into: [:], { dict, style in
            if let styleId = style.id {
                let styleUrl = KMLStyleUrl(styleUrl: styleId)
                if let baseStyle = style as? KMLStyle,
                   baseStyle.isEmpty == true {
                    dict[styleUrl] = nil
                } else {
                    dict[styleUrl] = style
                }
            }
        })
    }

}
