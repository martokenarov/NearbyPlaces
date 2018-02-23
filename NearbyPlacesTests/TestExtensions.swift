//
//  TestExtensions.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 23.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation

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
