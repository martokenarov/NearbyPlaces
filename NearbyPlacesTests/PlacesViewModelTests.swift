//
//  PlacesViewModelTests.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 23.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import XCTest
import CoreLocation
import CoreData

class PlacesViewModelTests: XCTestCase {
    
    var placesTableViewViewModel: PlacesTableViewViewModel!
    fileprivate var mockApiClient: MockApiClient!
    fileprivate var mockLocationClient: MockLocationClient!
    fileprivate var mockPersistentClient: MockPersistentClient!
    
    override func setUp() {
        super.setUp()
        self.mockApiClient = MockApiClient()
        self.mockLocationClient = MockLocationClient()
        self.mockPersistentClient = MockPersistentClient()
        
        self.placesTableViewViewModel = PlacesTableViewViewModel(with: self.mockPersistentClient, locationManager: self.mockLocationClient, apiClient: self.mockApiClient)
    }
    
    func testSuccesGetPlaces() {
        self.placesTableViewViewModel.getPlaces()
        
        self.placesTableViewViewModel.placeCells.bindAndFire { cells in
            XCTAssertEqual(cells.count, 1)
        }
    }
    
    override func tearDown() {
        self.mockLocationClient = nil
        self.mockApiClient = nil
        self.mockPersistentClient = nil
        super.tearDown()
    }
}

class MockApiClient: ApiClient {
    func getNearByUserPlaces(by url: String, competion: @escaping GetNearByPlacesCompletion) {
        
        guard let data = FileManager.readJson(forResource: "sample") else {
            competion(.failure(nil))
            return
        }
        
        guard let json = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? JSON) else {
            competion(.failure(nil))
            debugPrint("Invalid json")
            return
        }
        
        guard let response = NearbyPlacesResponse(dic: json) else {
            competion(.failure(nil))
            debugPrint("Cannot parse response json")
            return
        }
        
        competion(.success(payload: response))
    }
}

class MockLocationClient: Location {
    public var result: ((LocationResult) -> ())?
    
    private var currentLocation : CLLocationCoordinate2D? {
        didSet {
            result?(.success(payload: currentLocation!))
        }
    }
    
    func determineMyCurrentLocation() {
        currentLocation = CLLocationCoordinate2D(latitude: -33.8670522, longitude: 151.1957362)
    }
}

class MockPersistentClient: Persistent {
    func save(with places: [JSON], userLocation: CLLocation, completion: @escaping SavePlaces) {
        completion(.success(payload: true))
    }
    
    func load(with completion: @escaping GetPlacesFromStorage) {
        let entity = NSEntityDescription()
        entity.name = "Place"
        let managedObjectContext = setUpInMemoryManagedObjectContext()
        
        let place = Place(entity: entity, insertInto: managedObjectContext)
        place.name = "Flying Fish Restaurant & Bar"
        place.latitude = -33.8631871
        place.longitude = 151.1952316
        
        completion(.success(payload: [place]))
    }
    
    func clear(with completion: @escaping ClearDB) {
        completion(.success(payload: true))
    }
}

func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
    let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
    
    let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
    
    do {
        try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
    } catch {
        print("Adding in-memory persistent store failed")
    }
    
    let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
    
    return managedObjectContext
}
