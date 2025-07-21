//
//  KMLFeature.swift
//  RCKML
//
//  Created by Ryan Linn on 6/18/21.
//

import AEXML
import Foundation

/// Any KmlElement type to be used in *Feature* objects of a KML document.
///
/// For definition, see [KML spec](https://developers.google.com/kml/documentation/kmlreference#feature)
public protocol KMLFeature: KmlElement {
    /// An optional user-visible name for the feature.
    var name: String? { get }

    /// An optional text description of the feature.
    var featureDescription: String? { get }
}

// MARK: Initializer Helpers

internal extension KMLFeature {
    /// Helper function for use when creating KMLFeature instances in `KmlFeature.init(xml:)`,
    /// this function returns the optional *name* attribute of the KML feature.
    ///
    /// - Parameter xml: The XML element being used to create this KMLFeature
    /// - Throws: XML Error
    /// - Returns: Name value of the KML element.
    static func nameFromXml(_ xml: AEXMLElement) -> String? {
        xml.optionalXmlChild(name: "name")?.string
    }

    /// Helper function for use when creating KMLFeature instances in `KmlFeature.init(xml:)`,
    /// this function returns the optional *description* attribute of the KML feature
    ///
    /// - Parameter xml: The XML element being used to create this KMLFeature
    /// - Returns: Description value of the KML element.
    static func descriptionFromXml(_ xml: AEXMLElement) -> String? {
        xml.optionalXmlChild(name: "description")?.string
    }
}
