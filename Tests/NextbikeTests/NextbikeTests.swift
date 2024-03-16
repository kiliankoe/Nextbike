import XCTest
@testable import Nextbike
import CoreLocation

class NextbikeTests: XCTestCase {
    func testLoadDresden() {
        let e = expectation(description: "get data")

        let dresden = 685
        Nextbike.load(cityWithID: dresden) { result in
            let countries = try! result.get()

            let de = countries[0]
            XCTAssertEqual(de.name, "Germany")
            XCTAssertEqual(de.cities.count, 1)

            let dresden = de.cities[0]
            XCTAssertEqual(dresden.name, "Dresden")
            XCTAssertGreaterThan(dresden.places.count, 200)

            let bhfNeustadt = dresden.places.first { $0.name == "MOBIpunkt Bahnhof Neustadt" }!
            XCTAssertEqual(bhfNeustadt.coordinate.latitude, 51.0, accuracy: 1)
            XCTAssertEqual(bhfNeustadt.coordinate.longitude, 13.7, accuracy: 1)

            e.fulfill()
        }

        waitForExpectations(timeout: 5)
    }
    
    func testFindNearby() {
        let e = expectation(description: "find nearby bikes")
        
        Nextbike.findNearby(location: CLLocationCoordinate2D(latitude: 51.06298, longitude: 13.74609)) { result in
            let places = try! result.get()
            
            XCTAssertGreaterThan(places.count, 0)
            
            e.fulfill()
        }
        
        waitForExpectations(timeout: 5)
    }

    static var allTests = [
        ("testLoadDresden", testLoadDresden),
        ("testFindNearby", testFindNearby)
    ]
}
