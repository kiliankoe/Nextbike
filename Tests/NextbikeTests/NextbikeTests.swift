import XCTest
@testable import Nextbike

class NextbikeTests: XCTestCase {
    func testLoadDresden() {
        let e = expectation(description: "get data")

        let session = MockURLSession(withResponseFileName: "Response")

        let dresden = 2
        Nextbike.load(cityWithID: dresden, session: session) { result in
            let countries = try! result.get()

            let de = countries[0]
            XCTAssertEqual(de.name, "Germany")
            XCTAssertEqual(de.cities.count, 1)

            let dresden = de.cities[0]
            XCTAssertEqual(dresden.name, "Dresden")
            XCTAssertGreaterThan(dresden.places.count, 200)

            let bhfNeustadt = dresden.places.first { $0.name == "Bf. Dresden-Neustadt" }!
            XCTAssertEqual(bhfNeustadt.coordinate.latitude, 51.0, accuracy: 1)
            XCTAssertEqual(bhfNeustadt.coordinate.longitude, 13.7, accuracy: 1)

            e.fulfill()
        }

        waitForExpectations(timeout: 5)
    }

    static var allTests = [
        ("testLoadDresden", testLoadDresden),
    ]
}
