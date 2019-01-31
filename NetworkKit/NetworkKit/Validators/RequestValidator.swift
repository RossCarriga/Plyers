//
//  RequestValidator.swift
//  NetworkKit
//
//  Created by Ross Carrigan on 1/27/19.
//  Copyright © 2019 Ross Carrigan. All rights reserved.
//

import Foundation

struct RequestValidator: TaskValidator {
    
    var responseDecoder: ResponseDecodable
    
    init() {
        responseDecoder = ResponseDecoder()
    }
    /// Validates that a network task has yielded a valid
    /// response, and data. This is to prevent basic data
    /// processing from being required else where.
    func validate(data: Data?, response: URLResponse?) -> Result<Data> {
        
        let dataValidationResult = validate(data: data)
        let responseValidationResult = validate(response: response)

        if let dataError = dataValidationResult.error {
            return .error(dataError)
        }
        
        if let responseError = responseValidationResult.error {
            return .error(responseError)
        }
        
        guard let validatedData = dataValidationResult.value else { return .error(NetworkError.undefinedFailure) }
        return .success(validatedData)
    }
    
    /// Validation of the Data
    func validate(data: Data?) -> Result<Data> {
        guard let data = data else {
            return .error(NetworkError.invalidDataFailure)
        }
        
        return .success(data)
    }
    
    /// Validation of the response
    func validate(response: URLResponse?) -> Result<URLResponse> {
        guard let response = response as? HTTPURLResponse else { return .error(NetworkError.invalidResponseData) }
        let responseStatusResult = responseDecoder.decode(response: response)
        switch responseStatusResult {
        case .success(let validResponse):
            return .success(validResponse)
        case .error(let error):
            return .error(error)
        }
    }
}
