import XCTest
@testable import Nextbike
import CoreLocation

class NextbikeTests: XCTestCase {
    let apiKey = ProcessInfo.processInfo.environment["API_KEY"] ?? ""
    
    func testFetchBikesForCity() {
        let e = expectation(description: "get all bikes in dresden")
        
        let dresden = 685
        Nextbike.Maps.fetchBikesFor(cityWithID: dresden) { result in
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
    
    func testFetchBikesForLocation() {
        let e = expectation(description: "get bikes near the given location")
        
        Nextbike.Maps.fetchBikesFor(location: CLLocationCoordinate2D(latitude: 51.06298, longitude: 13.74609)) { result in
            guard let places = try? result.get() else { return }
            
            XCTAssertGreaterThan(places.count, 0)
            print(places.first?.name ?? "n/a")
            print(places.first?.bikeCount ?? 0)
            
            e.fulfill()
        }
        
        waitForExpectations(timeout: 5)
    }
    
    func testFlexzoneQuery() {
        let e = expectation(description: "obtain all flexzones as GeoJSON")
        
        var hash = ""
        Nextbike.Maps.flexzones(apiKey: apiKey, hash: "", domain: "dx") { result in
            hash = (try? result.get().hash) ?? ""
            
            Nextbike.Maps.flexzones(apiKey: self.apiKey, hash: hash, domain: "dx") { result in
                do {
                    switch result {
                    case .success(_):
                        return
                    case .failure(let failure):
                        throw failure
                    }
                } catch let err as NetworkError {
                    // this has to fail because when supplied with the correct hash,
                    // the api should respond with 304 - Not Modified
                    e.fulfill()
                } catch {
                    return
                }
            }
            
        }
        
        
        
        waitForExpectations(timeout: 5)
    }
}
