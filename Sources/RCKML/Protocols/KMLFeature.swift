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
