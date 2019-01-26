//
//  DataEndpoint.swift
//  NetworkKit
//
//  Created by Ross Carrigan on 1/25/19.
//  Copyright © 2019 Ross Carrigan. All rights reserved.
//

import Foundation

typealias HTTPParameters = [String: Any]
typealias HTTPHeaders = [String: String]

protocol DataEndpoint {
    var host: URL { get } 
    var path: String { get }
    var method: HTTPMethod { get }
    var query: [URLQueryItem]? { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
