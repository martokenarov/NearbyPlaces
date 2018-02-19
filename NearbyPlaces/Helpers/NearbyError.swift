//
//  NearbyError.swift
//  NearbyPlaces
//
//  Created by Marto Kenarov on 15.02.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation

enum ErrorCode: Int {
    case unknownError
    case connectionError
    case invalidRequest
    case notFound
    case invalidResponse
    case serverError
    case serverUnavailable
    case timeOut
    case unsuppotedURL
    case locAccessDenied
    case notDetermined
}

protocol NearbyErrorProtocol: LocalizedError {
    var title: String? { get }
    var code: ErrorCode { get }
}

struct NearbyError: NearbyErrorProtocol {
    
    var title: String?
    var code: ErrorCode
    var errorDescription: String? { return _description }
    var failureReason: String? { return _description }
    
    private var _description: String
    
    init(title: String?, description: String, code: ErrorCode) {
        self.title = title ?? "Error"
        self._description = description
        self.code = code
    }
}
