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
    }
