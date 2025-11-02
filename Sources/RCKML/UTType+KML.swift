//
//  UTType+KML.swift
//
//
//  Created by Ryan Linn on 2/8/23.
//

import UniformTypeIdentifiers

@available(macOS 11.0, iOS 14.0, watchOS 7.0, *)
public extension UTType {
    static var kml: UTType {
        let tags = UTType.types(tag: "kml", tagClass: .filenameExtension, conformingTo: .xml)
        return tags.first(where: { $0.identifier.contains("google") }) ?? tags.first!
    }

    static var kmz: UTType {
        let tags = UTType.types(tag: "kmz", tagClass: .filenameExtension, conformingTo: nil)
        return tags.first(where: { $0.identifier.contains("google") }) ?? tags.first!
    }
}
