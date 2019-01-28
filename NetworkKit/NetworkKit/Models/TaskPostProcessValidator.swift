//
//  TaskPostProcessValidator.swift
//  NetworkKit
//
//  Created by Ross Carrigan on 1/27/19.
//  Copyright © 2019 Ross Carrigan. All rights reserved.
//

import Foundation

struct TaskPostProcessValidator: TaskValidator {
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
    
    func validate(data: Data?) -> Result<Data> {
        guard let data = data else {
            return .error(NetworkError.invalidDataFailure)
        }
        
        return .success(data)
    }
    
    func validate(response: URLResponse?) -> Result<URLResponse> {
        guard let response = response as? HTTPURLResponse else { return .error(NetworkError.invalidResponseData) }
        let responseStatusResult = ResponseStatusDecoder.decode(status: response.statusCode)
        switch responseStatusResult {
        case .success:
            return .success(response)
        case .error(let error):
            return .error(error)
        }
    }
}
