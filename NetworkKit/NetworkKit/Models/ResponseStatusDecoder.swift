//
//  ResponseStatusDecoder.swift
//  NetworkKit
//
//  Created by Ross Carrigan on 1/26/19.
//  Copyright © 2019 Ross Carrigan. All rights reserved.
//

import Foundation

public struct ResponseStatusDecoder: ResponseStatusDecodable {
    /// function to allow to
    public static func decode(status: Int) -> Result<Int> {
        switch status {
            
        case 200..<300:
            return .success(status)
        
        case 400..<500:
            return .error(NetworkError.authenticationFailure)

        case 500..<600:
            return .error(NetworkError.invalidRequest)

        default:
            return .error(NetworkError.undefinedFailure)

        }
    }
}
