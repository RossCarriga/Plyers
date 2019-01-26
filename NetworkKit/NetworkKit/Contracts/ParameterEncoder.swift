//
//  ParameterEncodable.swift
//  NetworkKit
//
//  Created by Ross Carrigan on 1/25/19.
//  Copyright © 2019 Ross Carrigan. All rights reserved.
//

import Foundation

protocol ParameterEncodable {
    static func encode(urlRequest: inout URLRequest, with parameters: HTTPParameters) throws
}
