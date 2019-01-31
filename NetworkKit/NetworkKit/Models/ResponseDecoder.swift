//
//  ResponseDecoder.swift
//  NetworkKit
//
//  Created by Ross Carrigan on 1/26/19.
//  Copyright © 2019 Ross Carrigan. All rights reserved.
//

import Foundation

public struct ResponseDecoder: ResponseDecodable {
    public func decode(response: URLResponse) -> Result<URLResponse> {
        guard let response = response as? HTTPURLResponse else { return .error(NetworkError.invalidRequest) }
        
        switch response.statusCode {
            
        case 200..<300:
            return .success(response)
            
        case 400..<500:
            return .error(NetworkError.authenticationFailure)
            
        case 500..<600:
            return .error(NetworkError.serverFailure)
            
        default:
            return .error(NetworkError.undefinedFailure)
        }
    }
}
