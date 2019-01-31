//
//  NetworkExecutable.swift
//  NetworkKit
//
//  Created by Ross Carrigan on 1/25/19.
//  Copyright © 2019 Ross Carrigan. All rights reserved.
//

import Foundation

typealias NetworkResponseCompletion = (Data?, URLResponse?, Error?) -> Void

public protocol NetworkExecutable: class {
    associatedtype Endpoint: RequestEndpoint
    
    func request(_ route: Endpoint, _ completion: @escaping (Result<Data>) -> Void)
    func cancel()
}
