//
//  KMLGeometry.swift
//  RCKML
//
//  Created by Ryan Linn on 6/16/21.
//

import AEXML
import Foundation

// MARK: - Geometry Protocol

/// Any KmlElement type to be used in *Geometry* objects of a KML document.
///
/// For definition, see [KML spec](https://developers.google.com/kml/documentation/kmlreference#geometry)
public protocol KMLGeometry: KmlElement {
    /// Type-level definition to map conforming type to a known KML Geometry class.
    static var geometryType: KMLGeometryType { get }
}

public extension KMLGeometry {
    static var kmlTag: String {
        geometryType.rawValue
    }
}
