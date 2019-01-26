//
//  HTTPMethod.swift
//  NetworkKit
//
//  Created by Ross Carrigan on 1/25/19.
//  Copyright © 2019 Ross Carrigan. All rights reserved.
//

import Foundation

/// Enumeration defining valid HTTP verbs used within our data manager classes.
/// This will prevent us from having to use stringly-typed variables when defining
/// various request objects.
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
    case head = "HEAD"
}
