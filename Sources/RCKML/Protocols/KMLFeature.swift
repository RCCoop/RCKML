//
//  KMLFeature.swift
//  RCKML
//
//  Created by Ryan Linn on 6/18/21.
//

import Foundation
import AEXML

//TODO: Documentation

/// <#Description#>
protocol KMLFeature : KmlElement {
    /// <#Description#>
    var name: String { get }
    
    /// <#Description#>
    var description: String? { get }
}

extension KMLFeature {
    /// <#Description#>
    /// - Parameter xml: <#xml description#>
    /// - Throws: <#description#>
    /// - Returns: <#description#>
    static func nameFromXml(_ xml:AEXMLElement) throws -> String {
        try xml.requiredXmlChild(name: "name").string
    }
    
    /// <#Description#>
    /// - Parameter xml: <#xml description#>
    /// - Returns: <#description#>
    static func descriptionFromXml(_ xml:AEXMLElement) -> String? {
        xml.optionalXmlChild(name: "description")?.string
    }
}
