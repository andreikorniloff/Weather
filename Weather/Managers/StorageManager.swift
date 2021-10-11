//
//  StorageManager.swift
//  Weather
//
//  Created by Andrei Kornilov on 02.10.2021.
//

import CoreData

final class StorageManager {
    static let shared = StorageManager()
    
    // MARK: CoreData Stack
    private let persistentContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Weather")
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("CoreData load persistent stores unresolved error: \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: CoreData Saving Support
    func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let error = error as NSError
                fatalError("CoreData save viewContext unresolved error: \(error), \(error.userInfo)")
            }
        }
    }
    
    private init() {}
}

// MARK: Location Data Methods
extension StorageManager {
    func fetchLocations() -> [Location] {
        let storedLocations = getStoredLocations()
        
        let locations = storedLocations.compactMap { storedLocation -> Location? in
            guard let id = storedLocation.id,
                  let title = storedLocation.title,
                  let displayName = storedLocation.displayName
            else { return nil }
            
            let coordinates = CLLocationCoordinate2D(
                latitude: storedLocation.latitude,
                longitude: storedLocation.longitude
            )

            let location = Location(
                id: id,
                title: title,
                displayName: displayName,
                coordinate: coordinates
            )
            
            return location
        }
        
        return locations
    }
    
    func saveLocation(_ location: Location) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "StoredLocation", in: viewContext)
        else { return }
        
        let existedLocation = getStoredLocation(for: location)
        
        guard let storedLocation = existedLocation != nil ?
                                   existedLocation :
                                   NSManagedObject(
                                    entity: entityDescription,
                                    insertInto: viewContext
                                   ) as? StoredLocation
        else { return }
        
        storedLocation.id = location.id
        storedLocation.title = location.title
        storedLocation.displayName = location.displayName
        storedLocation.latitude = location.coordinate.latitude
        storedLocation.longitude = location.coordinate.longitude
        
        saveContext()
    }
    
    func removeLocation(_ location: Location) {
        guard let storedLocation = getStoredLocation(for: location) else {
            print("Stored location not found into CoreData")
            return
        }
        
        let context = persistentContainer.viewContext
        context.delete(storedLocation)
        
        saveContext()
    }
}

// MARK: Helpers
extension StorageManager {
    private func getStoredLocation(for location: Location) -> StoredLocation? {
        let storedLocation: StoredLocation?
        let storedLocations = getStoredLocations()
        
        storedLocation = storedLocations.filter { $0.id == location.id }.first
        
        return storedLocation
    }
    
    private func getStoredLocations() -> [StoredLocation] {
        var storedLocations: [StoredLocation] = []
        let fetchRequest: NSFetchRequest<StoredLocation> = StoredLocation.fetchRequest()
        
        do {
            storedLocations = try viewContext.fetch(fetchRequest)
        } catch let error {
            fatalError("CoreData fetch locations error: \(error)")
        }
        
        return storedLocations
    }
}
