//
//  KMLElement.swift
//  RCKML
//
//  Created by Ryan Linn on 6/17/21.
//

import AEXML
import Foundation

// MARK: - KML Element

/// Any type of element found in a KML file, as described in the
/// [KML specification](https://developers.google.com/kml/documentation/kmlreference)
/// or [OGC KML Standard](https://www.ogc.org/standards/kml/)
///
/// The basic functions of this protocol are to provide encoding and decoding support
/// to a class or type of KML Element (for example, **Feature**, **Geometry**, or **Style**).
public protocol KmlElement {
    /// The XML element name for this type of KML Element, such as
    /// **Feature**, **Document**, **Geometry**, **Style**, etc.
    static var kmlTag: String { get }

    /// Initializes the KmlElement using an AEXMLElement read from a KML file.
    /// - Parameter xml: xml element read from a valid KML file.
    init(xml: AEXMLElement) throws

    /// A representation of the KML element as AEXMLElement, for writing to KML file.
    var xmlElement: AEXMLElement { get }
}

// MARK: Initializer Helpers

internal extension KmlElement {
    /// Call this function at the beginning of any `KmlElement.init(xml:)` to
    /// ensure that the xml tag being used to create the object is of the correct
    /// type
    ///
    /// - Parameter xml: the xml element being used to check against.
    /// - Throws: If the xml tag name is different from Self.kmlTag, throws a xmlTagMismatch error.
    static func verifyXmlTag(_ xml: AEXMLElement) throws {
        guard xml.name == kmlTag else {
            throw KMLError.xmlTagMismatch
        }
    }
}
