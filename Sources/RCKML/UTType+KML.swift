//
//  UTType+KML.swift
//
//
//  Created by Ryan Linn on 2/8/23.
//

import UniformTypeIdentifiers

public extension UTType {
    /// A type that represents a KML file.
    ///
    /// An app that reads KML files should declare `com.google.earth.kml` as an imported type
    /// identifier, conforming to `public.xml`.
    ///
    /// - Important: The returned `UTType` from this variable is not guaranteed to be the one
    ///   named here. The system may substitute another with the same extension (`kml`) that
    ///   conforms to `public.xml` if that type is the system's preferred type and was declared in
    ///   a different app.
    static var kml: UTType {
        UTType(importedAs: "com.google.earth.kml", conformingTo: .xml)
    }

    /// A type that represents a KMZ archive, containing a KML file and its assets.
    ///
    /// An app that reads KMZ files should declare `com.google.earth.kmz` as an imported type
    /// identifier conforming to `public.data`.
    ///
    /// - Important: The returned `UTType` from this variable is not guaranteed to be the one
    ///   named here. The system may substitute another with the same extension (`kmz`) that conforms
    ///   to `public.data` if that type is the system's preferred type and was declared in a different
    ///   app.
    static var kmz: UTType {
        UTType(importedAs: "com.google.earth.kmz", conformingTo: .data)
    }

    /// Every type this system declares for the `kml` filename extension.
    ///
    /// Use this to populate a file picker's allowed content types. `URLResourceValues.contentType`
    /// reports whichever declaration the system ranks highest for the extension, which may be a type
    /// declared by another app, so filtering a picker by ``kml`` alone can exclude real KML files.
    ///
    /// To decide whether to parse a file as KML, match its path extension rather than checking its
    /// `URLResourceValues.contentType` for equality with `kml`, for the reason stated above.
    ///
    /// - Note: Read this each time rather than caching it. Installing or removing an app changes
    ///   what the system declares.
    static var kmlTypes: [UTType] {
        UTType.types(tag: "kml", tagClass: .filenameExtension, conformingTo: nil)
    }

    /// Every type this system declares for the `kmz` filename extension.
    ///
    /// Carries the same caveats as ``kmlTypes``.
    static var kmzTypes: [UTType] {
        UTType.types(tag: "kmz", tagClass: .filenameExtension, conformingTo: nil)
    }
}
