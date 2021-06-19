//
//  KMLElement.swift
//  KMLTester
//
//  Created by Ryan Linn on 6/17/21.
//

import Foundation
import AEXML

enum KMLError: Error {
    case xmlTagMismatch
    case coordinateParseFailed
    case missingRequiredElement(elementName: String)
}

//MARK:- KML Element

protocol KmlElement {
    static var kmlTag: String { get }
    init(xml: AEXMLElement) throws
}

extension KmlElement {
    static func verifyXmlTag(_ xml:AEXMLElement) throws {
        guard xml.name == kmlTag else {
            throw KMLError.xmlTagMismatch
        }
    }
    
}

//MARK:- KML Extension for AEXMLElement

extension AEXMLElement {
        
    func requiredKmlChild<T: KmlElement>(ofType type:T.Type) throws -> T {
        let subItem = self[T.kmlTag]
        if let error = subItem.error {
            throw error
        }
        
        let item = try T(xml: subItem)
        return item
    }
    
    func requiredXmlChild(name: String) throws -> AEXMLElement {
        let subItem = self[name]
        if let error = subItem.error {
            throw error
        }
        return subItem
    }
    
    func optionalXmlChild(name: String) -> AEXMLElement? {
        let subItem = self[name]
        if subItem.error != nil {
            return nil
        }
        return subItem
    }
    
    func optionalKmlChild<T: KmlElement>(ofType type:T.Type) -> T? {
        let subItem = self[T.kmlTag]
        if subItem.error != nil {
            return nil
        }
        return try? T(xml: subItem)
    }
    
    func allKmlChildren<T: KmlElement>(ofType type:T.Type) throws -> [T] {
        let childs = try children.filter({ $0.name == T.kmlTag }).compactMap({ try T(xml: $0) })
        return childs
    }

}
