    import XCTest
    @testable import RCKML

    final class RCKMLTests: XCTestCase {
        func getTestDocument() throws -> KMLDocument? {
            let bundle = Bundle.module
            let bundlePath = bundle.bundlePath
            print("BundlePath: \(bundlePath)")
            let fileUrl = bundle.url(forResource: "GoogleTest", withExtension: "kml")
            //let data = try? Data(contentsOf: fileUrl)
            XCTAssertNotNil(fileUrl)
            print("filePath: \(fileUrl)")
            return nil
        }
        
        func testExample() {
            // This is an example of a functional test case.
            // Use XCTAssert and related functions to verify your tests produce the correct
            // results.
            let _ = try? getTestDocument()
            XCTAssertEqual(RCKML().text, "Hello, World!")
        }
        
        func testKmlColors() throws {
            //80F0BE78
            //== rgba: 120,190,240,50%
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
            XCTAssertEqual(Int(reconstructed.alpha * 10.0), 5)

        }

    }
