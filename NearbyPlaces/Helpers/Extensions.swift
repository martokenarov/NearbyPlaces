//
//  Extensions.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 22.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
