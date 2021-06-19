//
//  KMLContainer.swift
//  KMLTester
//
//  Created by Ryan Linn on 6/18/21.
//

import Foundation
import AEXML

protocol KMLContainer : KmlElement {
    var features: [KMLFeature] { get }
}

extension KMLContainer {
    
    static func features(from xml:AEXMLElement) throws -> [KMLFeature] {
        return try xml.children.compactMap({ xmlChild -> KMLFeature? in
            guard let featureType = KMLFeatureType(rawValue: xmlChild.name),
                  KMLFeatureType.elementIsRecognizedType(xmlChild)
            else {
                return nil
            }
            let res = try featureType.concreteType.init(xml: xmlChild)
            return res
        })
    }
    
}

extension KMLContainer {
    var folders: [KMLFolder] {
        return self.features.compactMap({ $0 as? KMLFolder })
    }
    
    var placemarks: [KMLPlacemark] {
        return self.features.compactMap({ $0 as? KMLPlacemark })
    }
    
    func listContents(indentation:Int = 0) {
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
