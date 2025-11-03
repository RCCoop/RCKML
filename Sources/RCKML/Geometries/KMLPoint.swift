//
//  KMLPoint.swift
//  RCKML
//
//  Created by Ryan Linn on 6/17/21.
//

import AEXML
import Foundation

/// A KML geometry associated with a single point on the Earth.
///
/// For reference, see [KML Documentation](https://developers.google.com/kml/documentation/kmlreference#point)
public struct KMLPoint {
    public var coordinate: KMLCoordinate

    public init(coordinate: KMLCoordinate) {
        self.coordinate = coordinate
    }

    public init(
        latitude: Double,
        longitude: Double,
        altitude: Double? = nil
    ) {
        coordinate = KMLCoordinate(latitude: latitude, longitude: longitude, altitude: altitude)
    }
}

// MARK: KMLElement

extension KMLPoint: KmlElement {
    public init(xml: AEXMLElement) throws {
        try Self.verifyXmlTag(xml)
        let coordElement = try xml.requiredKmlChild(ofType: [KMLCoordinate].self)
        
        guard let firstCoord = coordElement.first else {
            throw KMLError.missingRequiredElement(elementName: "coordinates")
        }

        coordinate = firstCoord
    }

    public var xmlElement: AEXMLElement {
        let element = AEXMLElement(name: Self.kmlTag)
        element.addChild([coordinate].xmlElement)
        return element
    }
}

// MARK: KMLGeometry

extension KMLPoint: KMLGeometry {
    public static var geometryType: KMLGeometryType {
        .point
    }
}
