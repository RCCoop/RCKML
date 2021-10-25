//
//  KMLStyleUrl.swift
//  RCKML
//
//  Created by Ryan Linn on 6/18/21.
//

import AEXML
import Foundation

/// A wrapper around a KMLStyleSelector's id, used for referencing that
/// style from another style.
///
/// For more info, see [KML Spec](https://developers.google.com/kml/documentation/kmlreference#styleurl)
public struct KMLStyleUrl: Hashable {
    public var styleId: String

    public init(styleId: String) {
        self.styleId = styleId
    }
}

// MARK: - Internal StyleSelector conformance

extension KMLStyleUrl: KMLStyleSelector {
    public var id: String? { nil }

    public static var kmlTag: String {
        "styleUrl"
    }

    public init(xml: AEXMLElement) throws {
        try Self.verifyXmlTag(xml)
        var urlString = xml.string
        if urlString.first == "#" {
            urlString.removeFirst()
        }
        self.styleId = urlString
    }

    public var xmlElement: AEXMLElement {
        AEXMLElement(name: Self.kmlTag, value: "#" + styleId)
    }
}
