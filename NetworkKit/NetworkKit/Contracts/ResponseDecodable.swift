//
//  ResponseDecodable.swift
//  NetworkKit
//
//  Created by Ross Carrigan on 1/27/19.
//  Copyright © 2019 Ross Carrigan. All rights reserved.
//

import Foundation

/// Defining functionality for decoding response codes in
/// HTTP requests. values containing information or tasks
/// can be passed, or errors if needed.
public protocol ResponseDecodable {
    func decode(response: URLResponse) -> Result<URLResponse>
}
