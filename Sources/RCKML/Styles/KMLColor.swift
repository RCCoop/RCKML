//
//  File.swift
//  
//
//  Created by Ryan Linn on 6/19/21.
//

import Foundation
import AEXML
import CoreGraphics

struct KMLColor {
    var red: Double
    var green: Double
    var blue: Double
    var alpha: Double
}

extension KMLColor : KmlElement {
    static var kmlTag: String {
        "color"
    }
    
    init(xml: AEXMLElement) throws {
        try Self.verifyXmlTag(xml)
        guard let kmlString = xml.value else {
            throw KMLError.missingRequiredElement(elementName: "colorString")
        }
        try self.init(kmlString)
    }
    
    var xmlElement: AEXMLElement {
        AEXMLElement(name: Self.kmlTag, value: colorString)
    }
}

extension KMLColor {
    
    public enum ColorError: Error {
        case stringLength(String)
        case scannerFailure(String)
    }
    
    public var colorString :String {
        return String(format: "%02lX%02lX%02lX%02lX", lroundf(Float(alpha) * 255), lroundf(Float(blue) * 255), lroundf(Float(green) * 255), lroundf(Float(red) * 255))
    }
    
    @available(iOS 13.0, *)
    public var cgColor: CGColor {
        CGColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }

    init(_ kmlString: String) throws {
        let formattedString = kmlString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        let scanner = Scanner(string: formattedString)
        var hexNumber :UInt32 = 0
        let stringLength = formattedString.count

        guard stringLength == 8 else {
            throw ColorError.stringLength(formattedString)
        }
        guard scanner.scanHexInt32(&hexNumber) else {
            throw ColorError.scannerFailure(formattedString)
        }

        alpha = Double((hexNumber & 0xFF000000) >> 24) / 255.0
        blue = Double((hexNumber & 0x00FF0000) >> 16) / 255.0
        green = Double((hexNumber & 0x0000FF00) >> 8) / 255.0
        red = Double(hexNumber & 0x000000FF) / 255.0

    }
    
}
