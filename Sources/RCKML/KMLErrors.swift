//
//  KMLErrors.swift
//
//
//  Created by Ryan Linn on 7/10/21.
//

import Foundation

public enum KMLError: Error {
    case xmlTagMismatch
    case coordinateParseFailed
    case missingRequiredElement(elementName: String)
    case unknownFileExtension(extension: String)
    case kmzReadError
}
