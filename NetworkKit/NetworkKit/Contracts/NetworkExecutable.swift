//
//  NetworkExecutable.swift
//  NetworkKit
//
//  Created by Ross Carrigan on 1/25/19.
//  Copyright © 2019 Ross Carrigan. All rights reserved.
//

import Foundation

public typealias NetworkRequestCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

protocol NetworkExecutable: class {
    associatedtype Endpoint: DataEndpoint
    func request(_ route: Endpoint, _ completion: @escaping NetworkRequestCompletion)
    func cancel()
}
