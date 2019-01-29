//
//  NetworkError.swift
//  NetworkKit
//
//  Created by Ross Carrigan on 1/25/19.
//  Copyright © 2019 Ross Carrigan. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    case invalidRequest
    case invalidResponseData
    case encoderFailure
    case decoderFailure
    case authenticationFailure
    case fileLoadingFailure
    case undefinedFailure
    case invalidDataFailure
    case mockLoadingFailure
}
