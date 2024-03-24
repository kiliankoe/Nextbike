# 🚲 Nextbike

Minimal wrapper around the [Nextbike](https://www.nextbike.net) API to enable listing of all places (e.g. bike racks) and their available bike counts.

Looking for more info on bike sharing APIs in general? Check here → [ubahnverleih/WoBike](https://github.com/ubahnverleih/WoBike).

## Installation

Nextbike is available through Carthage/Punic and Swift Package Manager, whatever floats your boat.

```swift
// Carthage
github "kiliankoe/Nextbike"

// Swift Package Manager
.package(url: "https://github.com/kiliankoe/Nextbike", from: "current version")
```

## Overview

Load all bikes current available in Dresden (id: 685) and print the count at the place "Bf. Dresden-Neustadt".

```swift
Nextbike.load(cityWithID: 2) { result in
    guard let countries = try? result.get() else { return }
    let dresden = countries[0].cities[0]
    let bhfNeustadt = dresden.places.first { $0.name == "MOBIpunkt Bahnhof Neustadt" }!
    print(bhfNeustadt.bikeCount)
}

Nextbike.findNearby(location: CLLocationCoordinate2D(latitude: 51.06298, longitude: 13.74609)) { result in
    guard let places = try? result.get() else { return }
    print(places.first?.name) // "Albertplatz"
    print(places.first?.bikeCount) // 1
```

## ToDo

There's a lot more info in the Nextbike API response. Would be great to pull that into the model types here as well. The info currently available is all I needed for integration into another app, so that's why it's so limited, sorry 🙈

- Extend current "nextbike-live" model types
- Flexzone info
- Proximity search ✅
- App functionality
  - Login
  - User Details
  - Notifications
  - Active Bookings
  - Open Rentals
  - Rental History
  - Bike rentals
  - Bike returns
  - Find Station
  - Bike List at Station
  - Bikes available to book
  - Single bike state
  - other meta info
