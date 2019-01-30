//
//  RequestBuildable.swift
//  NetworkKit
//
//  Created by Ross Carrigan on 1/29/19.
//  Copyright © 2019 Ross Carrigan. All rights reserved.
//

import Foundation

/// Defining functionality for building needed components
/// in a networking task.
///
/// A `NetworkExecutor` will interface with a comforming
/// class in order to build a URLRequest for it to execute.
///
/// - Note: The `Endpoint` is the information given to complete
///     the task
protocol NetworkBuildable {
    associatedtype Endpoint // Type of Data used to build a thing
    
    func build(with route: Endpoint) throws -> URLRequest
}
