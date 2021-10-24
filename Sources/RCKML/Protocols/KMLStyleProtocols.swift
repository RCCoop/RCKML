//
//  KMLStyle.swift
//  RCKML
//
//  Created by Ryan Linn on 6/18/21.
//

import AEXML
import Foundation

/// Protocol for conforming to the abstract KML element type *StyleSelector*,
/// which is the base type for *Style* and *StyleMap*.
///
/// For definition, see [KML spec](https://developers.google.com/kml/documentation/kmlreference#styleselector)
public protocol KMLStyleSelector: KmlElement {
    /// Identifier of the KML element, which can be set in order to read
    /// styles from the main body of the KML document via a *KMLStyleMap*
    var id: String? { get }
}

/// Protocol for conforming to the abstract KML element *ColorStyle*,
/// which is the base type for *LineStyle*, *PolyStyle*, *IconStyle*, and *LabelStyle*
///
/// For definition, see [KML spec](https://developers.google.com/kml/documentation/kmlreference#colorstyle)
public protocol KMLColorStyle: KmlElement {
    /// Identifier of the KML element, which can be set in order to read
    /// styles from the main body of the KML document via a *KMLStyleMap*
    var id: String? { get }
    /// The object representing the displayed color
    var color: KMLColor? { get }
}
