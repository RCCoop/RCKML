import CoreLocation
@testable import RCKML
import XCTest

final class RCKMLTests: XCTestCase {
    func testWriting() {
        guard let doc = getTestDocument() else {
            return
        }
        
        do {
            let stringRep = try doc.kmlString()
            print(stringRep)
        } catch {
            XCTFail("Failed to write doc.kmlString: \(error.localizedDescription)")
        }
    }
        
    func testKMZ() {
        guard let doc = getTestDocument() else {
            return
        }
        
        do {
            let kmzData = try doc.kmzData()
            let unzipped = try KMLDocument(kmzData: kmzData)
            XCTAssertEqual(doc.features.count, unzipped.features.count)
            XCTAssertEqual(doc.placemarksRecursive.count, unzipped.placemarksRecursive.count)

        } catch {
            XCTFail("KMZ Error: \(error)")
        }
    }
        
    func testMutation() {
        guard var doc = getTestDocument() else {
            return
        }
            
        let folderCount = doc.folders.count
        let featuresCount = doc.features.count
        doc.features.removeAll(where: { $0 is KMLFolder })
        XCTAssertEqual(doc.features.count, featuresCount - folderCount)
    }
}
    
// MARK: Finished Tests

extension RCKMLTests {
    func testKmlColors() throws {
        // 80F0BE78
        // == rgba: 120,190,240,50%
        let kmlStruct = KMLColor(red: 120.0/255.0, green: 190.0/255.0, blue: 240.0/255.0, alpha: 0.5)
        XCTAssertEqual(kmlStruct.red * 255.0, 120.0)
        XCTAssertEqual(kmlStruct.green * 255.0, 190)
        XCTAssertEqual(kmlStruct.blue * 255.0, 240)
        XCTAssertEqual(kmlStruct.alpha, 0.5)
            
        let asString = kmlStruct.colorString
        XCTAssertEqual(asString, "80F0BE78")
            
        let reconstructed = try KMLColor(asString)
        XCTAssertEqual(Int(reconstructed.red * 255.0), 120)
        XCTAssertEqual(Int(reconstructed.green * 255.0), 190)
        XCTAssertEqual(Int(reconstructed.blue * 255.0), 240)
        XCTAssertEqual(reconstructed.alpha, 0.5, accuracy: 0.1)
    }
        
    func testStyles() {
        guard let document = getTestDocument() else {
            return
        }
            
        let styles = document.styles
        guard let transPurpleLineGreenPolyStyle = styles.values.first(where: { $0.id == "transPurpleLineGreenPoly" }) as? KMLStyle else {
            XCTFail("Couldn't find style \"transPurpleLineGreenPoly\" in top level of document")
            return
        }
            
        guard let lineStyle = transPurpleLineGreenPolyStyle.lineStyle else {
            XCTFail("No linestyle found in \"transPurpleLineGreenPoly\" style")
            return
        }
        guard let polyStyle = transPurpleLineGreenPolyStyle.polyStyle else {
            XCTFail("No polystyle found in \"transPurpleLineGreenPoly\"")
            return
        }
                        
        XCTAssertEqual(lineStyle.width, 4)
        XCTAssertEqual(lineStyle.color?.red, 1)
        XCTAssertEqual(lineStyle.color?.green, 0)
        XCTAssertEqual(lineStyle.color?.blue, 1)
        XCTAssertEqual(lineStyle.color?.alpha ?? 0.0, 0.5, accuracy: 0.01)
        XCTAssertEqual(polyStyle.color?.red, 0)
        XCTAssertEqual(polyStyle.color?.green, 1)
        XCTAssertEqual(polyStyle.color?.blue, 0)
        XCTAssertEqual(polyStyle.color?.alpha ?? 0.0, 0.5, accuracy: 0.01)
    }

    func testFoldersAreEqual() {
        guard let document = getTestDocument() else {
            return
        }
            
        let knownFolderNames = Set(arrayLiteral: "Placemarks", "Styles and Markup", "Ground Overlays", "Screen Overlays", "Paths", "Polygons")
        let existingFolderNames = document.folders.map(\.name)
        XCTAssertEqual(knownFolderNames.count, existingFolderNames.count)
        XCTAssert(knownFolderNames.subtracting(existingFolderNames).isEmpty)
    }

    func testPlacemarksFolder() {
        guard let document = getTestDocument() else {
            return
        }
            
        guard let placemarksFolder = document.getItemNamed("Placemarks") as? KMLFolder else {
            XCTFail("Couldn't find \"Placemarks\" folder in document")
            return
        }
            
        let placemarks = placemarksFolder.placemarks
        XCTAssertEqual(placemarks.count, 3)
            
        let knownPointNames = Set(["Simple placemark", "Floating placemark", "Extruded placemark"])
        let existingPointNames = Set(placemarks.map(\.name))
        XCTAssertEqual(knownPointNames, existingPointNames)
            
        guard let simplePlacemark = placemarks.first(where: { $0.name == "Simple placemark" }) else {
            XCTFail("Failed to find placemark \"Simple placemark\" in folder")
            return
        }
        guard let simplePoint = simplePlacemark.geometry as? KMLPoint else {
            XCTFail("Failed to cast \"Simple placemark\"'s geometry to KMLPoint")
            return
        }
            
        XCTAssertEqual(simplePoint.coordinate.latitude, 37.42228990140251)
        XCTAssertEqual(simplePoint.coordinate.longitude, -122.0822035425683)
        XCTAssertEqual(simplePoint.coordinate.altitude, 0)
    }
        
    func testPolygons() {
        guard let document = getTestDocument() else {
            return
        }
            
        guard let polygonsFolder = document.getItemNamed("Polygons") as? KMLFolder else {
            XCTFail("Couldn't find \"Polygons\" folder in document")
            return
        }
            
        let allPolygonFeatures = polygonsFolder.placemarksRecursive
        XCTAssertEqual(allPolygonFeatures.count, 9)

        guard let thePentagon = allPolygonFeatures.first(where: { $0.name == "The Pentagon" }) else {
            XCTFail("Couldn't find The Pentagon")
            return
        }
            
        guard let thePolygon = thePentagon.geometry as? KMLPolygon else {
            XCTFail("Couldn't cast The Pentagon's geometry to KMLPolygon")
            return
        }
            
        let polygonCoords = thePolygon.outerBoundaryIs.coordinates
            
        let coordString = """
        -77.05788457660967,38.87253259892824,100
        -77.05465973756702,38.87291016281703,100
        -77.05315536854791,38.87053267794386,100
        -77.05552622493516,38.868757801256,100
        -77.05844056290393,38.86996206506943,100
        -77.05788457660967,38.87253259892824,100
        """
        let knownCoordLines = coordString.components(separatedBy: .newlines)
        XCTAssertEqual(polygonCoords.count, knownCoordLines.count)
    }

    func testPathsFolder() {
        guard let document = getTestDocument() else {
            return
        }
            
        guard let placemarksFolder = document.getItemNamed("Paths") as? KMLFolder else {
            XCTFail("Couldn't find \"Placemarks\" folder in document")
            return
        }
            
        let placemarks = placemarksFolder.placemarks
        XCTAssertEqual(placemarks.count, 6)
            
        let knownPathNames = Set(["Tessellated", "Untessellated", "Absolute", "Absolute Extruded", "Relative", "Relative Extruded"])
        let existingPathNames = Set(placemarks.map(\.name))
        XCTAssertEqual(knownPathNames, existingPathNames)

        guard let absolutePath = placemarks.first(where: { $0.name == "Absolute" }) else {
            XCTFail("Couldn't find path \"Absolute\" in paths folder")
            return
        }
            
        guard let styleUrl = absolutePath.styleUrl else {
            XCTFail("Couldn't find StyleURL in path")
            return
        }
        guard let _ = document.getStyleFromUrl(styleUrl) else {
            XCTFail("Couldn't find style with url \"\(styleUrl)\"")
            return
        }
            
        guard let lineString = absolutePath.geometry as? KMLLineString else {
            XCTFail("Couldn't cast path's geometry to KMLLineString")
            return
        }
            
        let absolutePathCoordString = """
        -112.265654928602,36.09447672602546,2357
        -112.2660384528238,36.09342608838671,2357
        -112.2668139013453,36.09251058776881,2357
        -112.2677826834445,36.09189827357996,2357
        -112.2688557510952,36.0913137941187,2357
        -112.2694810717219,36.0903677207521,2357
        -112.2695268555611,36.08932171487285,2357
        -112.2690144567276,36.08850916060472,2357
        -112.2681528815339,36.08753813597956,2357
        -112.2670588176031,36.08682685262568,2357
        -112.2657374587321,36.08646312301303,2357
        """
        let coords: [CLLocationCoordinate2D] = absolutePathCoordString.components(separatedBy: .newlines).compactMap { line -> CLLocationCoordinate2D? in
            let comps = line.components(separatedBy: ",").compactMap { Double($0) }
            if comps.count == 3 {
                return CLLocationCoordinate2D(latitude: comps[1], longitude: comps[0])
            } else {
                return nil
            }
        }
            
        XCTAssertEqual(coords.count, lineString.coordinates.count)
        for idx in 0 ..< lineString.coordinates.count {
            let knownCoordinate = coords[idx]
            let existingCoordinate = lineString.coordinates[idx]
            XCTAssertEqual(knownCoordinate.latitude, existingCoordinate.latitude)
            XCTAssertEqual(knownCoordinate.longitude, existingCoordinate.longitude)
            XCTAssertEqual(existingCoordinate.altitude, 2357)
        }
    }
}

// MARK: Helper Functions

extension RCKMLTests {
    func getTestDocument() -> KMLDocument? {
        let bundle = Bundle.module
        guard let fileUrl = bundle.url(forResource: "GoogleTest", withExtension: "kml") else {
            XCTFail("URL for KML file could not be found")
            return nil
        }
        do {
            let data = try Data(contentsOf: fileUrl)
            let document = try KMLDocument(data: data)
            return document
        } catch {
            XCTFail("KML Reader Error: \(error.localizedDescription)")
            return nil
        }
    }
}
