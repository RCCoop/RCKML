//
//  KMLStyle.swift
//  RCKML
//
//  Created by Ryan Linn on 6/18/21.
//

import Foundation
import AEXML

//TODO: Documentation

protocol KMLStyleSelector: KmlElement {
    var id: String? { get }
}

protocol KMLColorStyle: KmlElement {
    var id: String? { get }
    var color: KMLColor? { get }
}


/*
 
 https://developers.google.com/kml/documentation/kmlreference?csw=1#styleselector
 https://developers.google.com/kml/documentation/kmlreference?csw=1#style
 https://developers.google.com/kml/documentation/kmlreference?csw=1#stylemap
 
 https://developers.google.com/kml/documentation/kmlreference?csw=1#substyle
 https://developers.google.com/kml/documentation/kmlreference?csw=1#colorstyle
 https://developers.google.com/kml/documentation/kmlreference?csw=1#linestyle
 https://developers.google.com/kml/documentation/kmlreference?csw=1#polystyle
 
 StyleSelector {
    id: String
 }
 
 Style: StyleSelector {
    id: String
    lineStyle: LineStyle?
    polyStyle: PolyStyle?
 }
 
 StyleMap: StyleSelector {
    pair: StylePair
 
    struct StylePair {
        normal: StyleUrl
        highlighted: StyleUrl
    }
 }
  
 ColorStyle {
    id: String
    color: KMLColor
 }
 
 LineStyle: ColorStyle {
    width: Double
 }
 
 PolyStyle: ColorStyle {
    fill: Bool
    outline: Bool
 }
 
 */
