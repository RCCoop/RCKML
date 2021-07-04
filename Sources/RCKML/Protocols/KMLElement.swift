//
//  KMLElement.swift
//  RCKML
//
//  Created by Ryan Linn on 6/17/21.
//

import Foundation
import AEXML

//TODO: Documentation

enum KMLError: Error {
    case xmlTagMismatch
    case coordinateParseFailed
    case missingRequiredElement(elementName: String)
}

//MARK:- KML Element


/// <#Description#>
protocol KmlElement {
    /// <#Description#>
    static var kmlTag: String { get }
    
    /// <#Description#>
    /// - Parameter xml: <#xml description#>
    init(xml: AEXMLElement) throws
    
    /// <#Description#>
    var xmlElement: AEXMLElement { get }
}

extension KmlElement {
    /// <#Description#>
    /// - Parameter xml: <#xml description#>
    /// - Throws: <#description#>
    static func verifyXmlTag(_ xml:AEXMLElement) throws {
        guard xml.name == kmlTag else {
            throw KMLError.xmlTagMismatch
        }
    }
    
    /// <#Description#>
    /// - Parameter id: <#id description#>
    /// - Returns: <#description#>
    static func xmlAttributesWithId(_ id:String?) -> [String : String] {
        id != nil ? ["id":id!] : [:]
    }
}

//MARK:- KML Extension for AEXMLElement

extension AEXMLElement {
    
    /// <#Description#>
    /// - Parameter type: <#type description#>
    /// - Throws: <#description#>
    /// - Returns: <#description#>
    func requiredKmlChild<T: KmlElement>(ofType type:T.Type) throws -> T {
        let subItem = self[T.kmlTag]
        if let error = subItem.error {
            throw error
        }
        
        let item = try T(xml: subItem)
        return item
    }
    
    /// <#Description#>
    /// - Parameter name: <#name description#>
    /// - Throws: <#description#>
    /// - Returns: <#description#>
    func requiredXmlChild(name: String) throws -> AEXMLElement {
        let subItem = self[name]
        if let error = subItem.error {
            throw error
        }
        return subItem
    }
    
    /// <#Description#>
    /// - Parameter name: <#name description#>
    /// - Returns: <#description#>
    func optionalXmlChild(name: String) -> AEXMLElement? {
        let subItem = self[name]
        if subItem.error != nil {
            return nil
        }
        return subItem
    }
    
    /// <#Description#>
    /// - Parameter type: <#type description#>
    /// - Returns: <#description#>
    func optionalKmlChild<T: KmlElement>(ofType type:T.Type) -> T? {
        let subItem = self[T.kmlTag]
        if subItem.error != nil {
            return nil
        }
        return try? T(xml: subItem)
    }
    
    /// <#Description#>
    /// - Parameter type: <#type description#>
    /// - Throws: <#description#>
    /// - Returns: <#description#>
    func allKmlChildren<T: KmlElement>(ofType type:T.Type) throws -> [T] {
        let childs = try children.filter({ $0.name == T.kmlTag }).compactMap({ try T(xml: $0) })
        return childs
    }

}
