//
//  KMLGeometry.swift
//  RCKML
//
//  Created by Ryan Linn on 6/16/21.
//

import Foundation
import AEXML

//TODO: Documentation

//MARK:- Geometry Protocol

protocol KMLGeometry: KmlElement {
    static var geometryType: KMLGeometryType { get }
}

extension KMLGeometry {
    static var kmlTag: String {
        geometryType.rawValue
    }
}
