//
//  KMLColor.swift
//  RCKML
//
//  Created by Ryan Linn on 6/19/21.
//

import Foundation
import AEXML
import CoreGraphics

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

#if canImport(SwiftUI)
import SwiftUI
#endif

/// A struct representing the RGBa color value of a KML object's *color* tag.
///
/// For a brief discussion of KML's hex color coding, see [ColorStyle](https://developers.google.com/kml/documentation/kmlreference#colorstyle) reference.
public struct KMLColor {
    /// A value between 0.0 and 1.0 representing the Red element of the color
    var red: Double
    
    /// A value between 0.0 and 1.0 representing the Green element of the color
    var green: Double
    
    /// A value between 0.0 and 1.0 representing the Blue element of the color
    var blue: Double
    
    /// A value between 0.0 and 1.0 representing the alpha element of the color
    var alpha: Double
}

//MARK:- KmlElement
extension KMLColor : KmlElement {
    public static var kmlTag: String {
        "color"
    }
    
    public init(xml: AEXMLElement) throws {
        try Self.verifyXmlTag(xml)
        guard let kmlString = xml.value else {
            throw KMLError.missingRequiredElement(elementName: "colorString")
        }
        try self.init(kmlString)
    }
    
    public var xmlElement: AEXMLElement {
        AEXMLElement(name: Self.kmlTag, value: colorString)
    }
}

//MARK:- Public Getters
public extension KMLColor {
        
    /// String representation of the KML Color, as found in the KML tag "\<color\>xxxxxxxx\</color\>"
    var colorString :String {
        return String(format: "%02lX%02lX%02lX%02lX", lroundf(Float(alpha) * 255), lroundf(Float(blue) * 255), lroundf(Float(green) * 255), lroundf(Float(red) * 255))
    }
    
    var cgColor: CGColor {
        CGColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
    
    #if canImport(UIKit)
    var uiColor: UIColor {
        UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
    #endif
    
    #if canImport(AppKit)
    var nsColor: NSColor {
        NSColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
    #endif
    
    #if canImport(SwiftUI)
    var color: Color {
        Color(red: red, green: green, blue: blue)
            .opacity(alpha)
    }
    #endif
        
}

//MARK:- Internal Initializers
internal extension KMLColor {
    enum ColorError: Error {
        case stringLength(String)
        case scannerFailure(String)
    }

    /// Initializer of KMLColor from a tag found in the KML file.
    /// - Throws: KMLColor.ColorError if the string is of the incorrect format.
    init(_ kmlString: String) throws {
        let formattedString = kmlString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        let scanner = Scanner(string: formattedString)
        var hexNumber :UInt64 = 0
        let stringLength = formattedString.count

        guard stringLength == 8 else {
            throw ColorError.stringLength(formattedString)
        }
        guard scanner.scanHexInt64(&hexNumber) else {
            throw ColorError.scannerFailure(formattedString)
        }

        alpha = Double((hexNumber & 0xFF000000) >> 24) / 255.0
        blue = Double((hexNumber & 0x00FF0000) >> 16) / 255.0
        green = Double((hexNumber & 0x0000FF00) >> 8) / 255.0
        red = Double(hexNumber & 0x000000FF) / 255.0

    }

}
