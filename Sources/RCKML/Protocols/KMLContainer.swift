//
//  KMLContainer.swift
//  RCKML
//
//  Created by Ryan Linn on 6/18/21.
//

import AEXML
import Foundation

/// Any KmlElement that can contain one or more sub-element KMLFeatures.
///
/// For definition, see [KML Spec](https://developers.google.com/kml/documentation/kmlreference#container)
public protocol KMLContainer: KmlElement {
    /// An array of all contained KMLFeatures in this container.
    var features: [KMLFeature] { get }
}

// MARK: - Default Functions

public extension KMLContainer {
    /// An unordered array of all KMLFolders in this container,
    /// not counting those inside nested containers.
    var folders: [KMLFolder] {
        return features.compactMap { $0 as? KMLFolder }
    }

    /// An unordered array of all KMLPlacemarks in this container,
    /// not counting those inside nested containers.
    var placemarks: [KMLPlacemark] {
        return features.compactMap { $0 as? KMLPlacemark }
    }

    /// An array of all KMLPlacemarks in this container, as well as
    /// inside nested containers to any depth.
    var placemarksRecursive: [KMLPlacemark] {
        features.reduce(into: [KMLPlacemark]()) { result, feature in
            if let placemark = feature as? KMLPlacemark {
                result.append(placemark)
            } else if let subContainer = feature as? KMLContainer {
                result.append(contentsOf: subContainer.placemarksRecursive)
            }
        }
    }

    /// Finds the first item in this container with a given name.
    /// Nested containers are not searched.
    ///
    /// - Parameter itemName: The name of the item to be found
    /// - Returns: A KMLFeature with the given name, or nil if none exists.
    func getItemNamed(_ itemName: String) -> KMLFeature? {
        features.first(where: { $0.name == itemName })
    }
}

// MARK: - Initializer Helpers

internal extension KMLContainer {
    /// For use in `KmlElement.init(xml:)`, this helper function retrieves
    /// all KMLFeature children contained in the XML element representing this container.
    ///
    /// - Parameter xml: The XML element being searched for children.
    /// - Throws: KMLErrors generated by KmlElement initalization.
    /// - Returns: an array of KMLFeatures contained in the XML Element.
    static func features(from xml: AEXMLElement) throws -> [KMLFeature] {
        return try xml.children.compactMap { xmlChild -> KMLFeature? in
            guard let featureType = KMLFeatureType(rawValue: xmlChild.name),
                  KMLFeatureType.elementIsRecognizedType(xmlChild)
            else {
                return nil
            }
            let res = try featureType.concreteType.init(xml: xmlChild)
            return res
        }
    }
}

// MARK: - Internal Functions

internal extension KMLContainer {
    /// For debug use, prints a string representation of all items inside this container
    /// - Parameter indentation: The indentation level of elements described.
    /// Only to be used inside this function call for recursive indentation.
    func listContents(indentation: Int = 0) {
        for feature in features {
            var basic = "\(String(repeating: ".", count: indentation))\(feature.name): \(String(describing: type(of: feature)))"

            if let placemark = feature as? KMLPlacemark {
                basic += "-" + String(describing: type(of: placemark.geometry))
            } else if let folder = feature as? KMLFolder {
                basic += " (\(folder.features.count) items)"
            }

            print(basic)
            if let folder = feature as? KMLContainer {
                folder.listContents(indentation: indentation + 1)
            }
        }
    }
}
