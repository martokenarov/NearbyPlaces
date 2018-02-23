//
//  GoogleResultTest.swift
//  NearbyPlacesTests
//
//  Created by Marto Kenarov on 23.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import XCTest

class GoogleResultTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSuccessfulInit() {
        
        guard let data = FileManager.readJson(forResource: "sample") else {
            XCTAssert(false, "Can't get data from sample.json")
            return
        }
        
        let json = try? JSONSerialization.jsonObject(with: data, options: []) as? JSON
        
        if let json = json {
            XCTAssertNotNil(NearbyPlacesResponse(dic:json))
        }
    }

    
}

extension FileManager {
    
    static func readJson(forResource fileName: String ) -> Data? {
        
        let bundle = Bundle(for: NearbyPlacesTests.self)
        if let path = bundle.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch {
                // handle error
            }
        }
        
        return nil
    }
}

