//
//  Location.swift
//  Weather
//
//  Created by Andrei Kornilov on 02.10.2021.
//

import CoreLocation

struct Location: Hashable {
    let id: UUID
    let title: String
    let displayName: String
    let coordinate: CLLocationCoordinate2D
    
    init(id: UUID, title: String, displayName: String, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.title = title
        self.displayName = displayName
        self.coordinate = coordinate
    }
    
    init(coordinate: CLLocationCoordinate2D, place: CLPlacemark) {
        var title = ""
        var displayName = ""
        
        if let locality = place.locality {
            title += locality
        } else if let name = place.name {
            title += name
        }
        
        displayName = title
        
        if let adminRegion = place.administrativeArea {
            title += ", \(adminRegion)"
        }
        
        if let country = place.country {
            title += ", \(country)"
        }
        
        if displayName.isEmpty {
            displayName = title
        }
        
        self.id = UUID()
        self.title = title
        self.displayName = displayName
        self.coordinate = coordinate
    }
}

// MARK: Hashable
extension Location {
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }

    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
