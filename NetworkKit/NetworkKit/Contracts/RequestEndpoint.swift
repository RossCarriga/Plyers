//
//  RequestEndpoint.swift
//  NetworkKit
//
//  Created by Ross Carrigan on 1/25/19.
//  Copyright © 2019 Ross Carrigan. All rights reserved.
//

import Foundation

/// Contract defining characteristics for a request.
///
/// Any request model must conform to the protocol to allow
/// for usage within any `Executor` conforming to the
/// `NetworkExecutable` protocol.

public typealias HTTPParameters = [String: Any]
public typealias HTTPHeaders = [String: String]

public protocol RequestEndpoint {
    var host: URL { get } 
    var path: String { get }
    var method: HTTPMethod { get }
    var query: [URLQueryItem]? { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
