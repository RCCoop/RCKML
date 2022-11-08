//
//  KMLDocument.swift
//  RCKML
//
//  Created by Ryan Linn on 6/18/21.
//

import AEXML
import Foundation
import ZIPFoundation

/// A root object for reading KML from file, or writing to file.
///
/// At its base, the KMLDocument is an array of KMLFeatures, and a dictionary
/// of `[StyleUrl : StyleSelector]` which are used as global styles for the
/// features in the file.
///
/// KMLDocuments can be initialized from either raw data, a fileUrl, or a KML string.
///
/// To export a KMLDocument, use the functions `kmlString()` or `kmlData()`
public struct KMLDocument {
    public var name: String?
    public var featureDescription: String?
    public var features: [KMLFeature]
    public var styles: [KMLStyleUrl: KMLStyleSelector]
    
    public init(name: String? = nil,
                featureDescription: String? = nil,
                features: [KMLFeature] = [],
                styles: [KMLStyleUrl: KMLStyleSelector] = [:])
    {
        self.name = name
        self.featureDescription = featureDescription
        self.features = features
        self.styles = styles
    }
}

// MARK: - KmlElement

extension KMLDocument: KmlElement {
    public static var kmlTag: String {
        "Document"
    }
    
    public init(xml: AEXMLElement) throws {
        try Self.verifyXmlTag(xml)
        self.features = try Self.features(from: xml)
        self.name = xml.optionalXmlChild(name: "name")?.string
        self.styles = try Self.kmlStylesInElement(xml)
        self.featureDescription = xml.optionalXmlChild(name: "description")?.string
    }
        
    public var xmlElement: AEXMLElement {
        let element = AEXMLElement(name: Self.kmlTag)
        _ = name.map { element.addChild(name: "name", value: $0) }
        _ = featureDescription.map { element.addChild(name: "description", value: $0) }
        
        for (_, style) in styles {
            element.addChild(style.xmlElement)
        }
        
        for item in features {
            element.addChild(item.xmlElement)
        }
        
        return element
    }
}

// MARK: - KMLContainer

extension KMLDocument: KMLContainer {}

// MARK: - Accessors

public extension KMLDocument {
    /// Returns the full string representation of the KML file.
    func kmlString() throws -> String {
        let xmlDoc = AEXMLDocument()
        let kmlRoot = xmlDoc.addChild(name: "kml", attributes: ["xmlns": "http://www.opengis.net/kml/2.2"])
        kmlRoot.addChild(xmlElement)
        _ = try xmlDoc.error.map { throw $0 }
        _ = try kmlRoot.error.map { throw $0 }
        return xmlDoc.xml
    }
    
    /// Returns the file data representation of the KML file.
    func kmlData() throws -> Data {
        guard let result = try kmlString().data(using: .utf8) else {
            throw KMLError.couldntConvertStringData
        }
        return result
    }
    
    /// Returns the file data representation as a KMZ file.
    func kmzData() throws -> Data {
        guard let archive = Archive(data: Data(), accessMode: .create, preferredEncoding: .utf8) else {
            throw KMLError.kmzWriteError
        }

        let normalData = try kmlData()
        try archive.addEntry(with: "doc.kml", type: .file, uncompressedSize: UInt32(normalData.count)) { position, size -> Data in
            normalData.subdata(in: position ..< position + size)
        }
        
        guard let result = archive.data else {
            throw KMLError.kmzWriteError
        }
        return result
    }
    
    /// Given a KMLStyleUrl reference from a feature contained in this document,
    /// returns the global style that is referenced by the url.
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
}

// MARK: - Initializers

public extension KMLDocument {
    init(_ data: Data) throws {
        let xmlDoc = try AEXMLDocument(xml: data)
        guard let documentElement = xmlDoc.firstDescendant(where: { $0.name == Self.kmlTag }) else {
            throw KMLError.missingRequiredElement(elementName: "Document")
        }
        if let kmlError = documentElement.error {
            throw kmlError
        }
        try self.init(xml: documentElement)
    }
    
    init(kmzData: Data) throws {
        var extractedData = Data()
        
        guard let archive = Archive(data: kmzData, accessMode: .read, preferredEncoding: .utf8),
              let kmlEntry = archive.first(where: { $0.path.hasSuffix("kml") }),
              let _ = try? archive.extract(kmlEntry, consumer: { extractedData += $0 }),
              !extractedData.isEmpty
        else {
            throw KMLError.kmzReadError
        }

        try self.init(extractedData)
    }
    
    init(_ kmlString: String) throws {
        guard let data = kmlString.data(using: .utf8) else {
            throw KMLError.missingRequiredElement(elementName: "xml")
        }
        try self.init(data)
    }
    
    /// Initializes a KMLDocument from a fileUrl, which must have a
    /// path extension of either "KML" or "KMZ" (neither are case-sensitive).
    /// - Throws: KML reading errors.
    init(_ url: URL) throws {
        let data = try Data(contentsOf: url)
        switch url.pathExtension.lowercased() {
        case "kml":
            try self.init(data)
        case "kmz":
            try self.init(kmzData: data)
        default:
            throw KMLError.unknownFileExtension(extension: url.pathExtension)
        }
    }
    
    /// Given the root XML element of a KML file, this returns the `styles`
    /// property for the KMLDocument.
    private static func kmlStylesInElement(_ xmlElement: AEXMLElement) throws -> [KMLStyleUrl: KMLStyleSelector] {
        // return array of StyleMap and Style
        let styleMaps = try xmlElement[KMLStyleMap.kmlTag].all?.map { try KMLStyleMap(xml: $0) } ?? []
        let styleElements = xmlElement[KMLStyle.kmlTag].all ?? []
        let styles = styleElements.compactMap { try? KMLStyle(xml: $0) }
        let all: [KMLStyleSelector] = styles + styleMaps
        return all.reduce(into: [:]) { dict, style in
            if let styleId = style.id {
                let styleUrl = KMLStyleUrl(styleId: styleId)
                if let baseStyle = style as? KMLStyle,
                   baseStyle.isEmpty == true
                {
                    dict[styleUrl] = nil
                } else {
                    dict[styleUrl] = style
                }
            }
        }
    }
}
