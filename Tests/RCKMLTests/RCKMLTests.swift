import CoreLocation
@testable import RCKML
import Testing

struct RCKMLTests {
    @Test
    func writeDocument() throws {
        let doc = try getTestDocument()
        let _ = try doc.kmlString()
    }

    @Test
    func kmzCompression() throws {
        let doc = try getTestDocument()

        let kmzData = try doc.kmzData()
        let unzipped = try KMLDocument(kmzData: kmzData)
        #expect(doc.features.count == unzipped.features.count)
        #expect(doc.placemarksRecursive.count == unzipped.placemarksRecursive.count)
    }

    @Test
    func mutation() throws {
        var doc = try getTestDocument()

        let folderCount = doc.folders.count
        let featuresCount = doc.features.count
        doc.features.removeAll(where: { $0 is KMLFolder })
        #expect(doc.features.count == featuresCount - folderCount)
    }

    @Test
    func colors() throws {
        // 80F0BE78
        // == rgba: 120,190,240,50%
        let kmlStruct = KMLColor(red: 120.0 / 255.0, green: 190.0 / 255.0, blue: 240.0 / 255.0, alpha: 0.5)
        #expect(kmlStruct.red * 255.0 == 120.0)
        #expect(kmlStruct.green * 255.0 == 190)
        #expect(kmlStruct.blue * 255.0 == 240)
        #expect(kmlStruct.alpha == 0.5)

        let asString = kmlStruct.colorString
        #expect(asString == "80F0BE78")

        let reconstructed = try KMLColor(asString)
        #expect(Int(reconstructed.red * 255.0) == 120)
        #expect(Int(reconstructed.green * 255.0) == 190)
        #expect(Int(reconstructed.blue * 255.0) == 240)
        #expect(abs(reconstructed.alpha - 0.5) < 0.1)
    }

    @Test
    func styles() throws {
        let document = try getTestDocument()

        let styles = document.styles

        let transPurpleLineGreenPolyStyle = try #require(styles.values.first(where: { $0.id == "transPurpleLineGreenPoly" }) as? KMLStyle)
        let lineStyle = try #require(transPurpleLineGreenPolyStyle.lineStyle)
        let polyStyle = try #require(transPurpleLineGreenPolyStyle.polyStyle)

        #expect(lineStyle.width == 4)

        let lineColor = try #require(lineStyle.color)
        #expect(lineColor.red == 1)
        #expect(lineColor.green == 0)
        #expect(lineColor.blue == 1)
        #expect(abs(lineColor.alpha - 0.5) < 0.01)

        let polyColor = try #require(polyStyle.color)
        #expect(polyColor.red == 0)
        #expect(polyColor.green == 1)
        #expect(polyColor.blue == 0)
        #expect(abs(polyColor.alpha - 0.5) < 0.01)
    }

    @Test
    func foldersAreEqual() throws {
        let document = try getTestDocument()

        let knownFolderNames: Set<String?> = [
            "Placemarks",
            "Styles and Markup",
            "Ground Overlays",
            "Screen Overlays",
            "Paths",
            "Polygons"
        ]
        let existingFolderNames = document.folders.map(\.name)
        #expect(knownFolderNames.count == existingFolderNames.count)
        #expect(knownFolderNames.subtracting(existingFolderNames).isEmpty)
    }

    @Test
    func placemarksFolder() throws {
        let document = try getTestDocument()

        let placemarksFolder = try #require(document.getItemNamed("Placemarks") as? KMLFolder)

        let placemarks = placemarksFolder.placemarks
        #expect(placemarks.count == 3)

        let knownPointNames: Set<String> = ["Simple placemark", "Floating placemark", "Extruded placemark"]
        let existingPointNames = Set(placemarks.map(\.name))
        #expect(knownPointNames == existingPointNames)

        let simplePlacemark = try #require(placemarks.first(where: { $0.name == "Simple placemark" }))

        let simplePoint = try #require(simplePlacemark.geometry as? KMLPoint)

        #expect(simplePoint.coordinate.latitude == 37.42228990140251)
        #expect(simplePoint.coordinate.longitude == -122.0822035425683)
        #expect(simplePoint.coordinate.altitude == 0)
    }

    @Test
    func polygons() throws {
        let document = try getTestDocument()

        let polygonsFolder = try #require(document.getItemNamed("Polygons") as? KMLFolder)

        let allPolygonFeatures = polygonsFolder.placemarksRecursive
        #expect(allPolygonFeatures.count == 9)

        let thePentagon = try #require(allPolygonFeatures.first(where: { $0.name == "The Pentagon" }))

        let thePolygon = try #require(thePentagon.geometry as? KMLPolygon)

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
        #expect(polygonCoords.count == knownCoordLines.count)
    }

    @Test
    func pathsFolder() throws {
        let document = try getTestDocument()

        let placemarksFolder = try #require(document.getItemNamed("Paths") as? KMLFolder)

        let placemarks = placemarksFolder.placemarks
        #expect(placemarks.count == 6)

        let knownPathNames: Set<String> = [
            "Tessellated",
            "Untessellated",
            "Absolute",
            "Absolute Extruded",
            "Relative",
            "Relative Extruded"
        ]
        let existingPathNames = Set(placemarks.map(\.name))
        #expect(knownPathNames == existingPathNames)

        let absolutePath = try #require(placemarks.first(where: { $0.name == "Absolute" }))

        let styleUrl = try #require(absolutePath.styleUrl)
        #expect(document.getStyleFromUrl(styleUrl) != nil)

        let lineString = try #require(absolutePath.geometry as? KMLLineString)

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
        let coords: [CLLocationCoordinate2D] = absolutePathCoordString
            .components(separatedBy: .newlines)
            .compactMap { line -> CLLocationCoordinate2D? in
                let comps = line.components(separatedBy: ",").compactMap { Double($0) }
                if comps.count == 3 {
                    return CLLocationCoordinate2D(latitude: comps[1], longitude: comps[0])
                } else {
                    return nil
                }
            }

        #expect(coords.count == lineString.coordinates.count)
        for idx in 0 ..< lineString.coordinates.count {
            let knownCoordinate = coords[idx]
            let existingCoordinate = lineString.coordinates[idx]
            #expect(knownCoordinate.latitude == existingCoordinate.latitude)
            #expect(knownCoordinate.longitude == existingCoordinate.longitude)
            #expect(existingCoordinate.altitude == 2357)
        }
    }
}

// MARK: Helper Functions

struct NoResourceError: Error { }

extension RCKMLTests {
    func getTestDocument() throws -> KMLDocument {
        let bundle = Bundle.module
        guard let fileUrl = bundle.url(forResource: "GoogleTest", withExtension: "kml") else {
            throw NoResourceError()
        }
        let data = try Data(contentsOf: fileUrl)
        let document = try KMLDocument(data)
        return document
    }
}
