//
//  RequestExecutor.swift
//  NetworkKit
//
//  Created by Ross Carrigan on 1/26/19.
//  Copyright © 2019 Ross Carrigan. All rights reserved.
//

import Foundation

public class RequestExecutor<Endpoint: RequestEndpoint>: NetworkExecutable {
    
    private var task: URLSessionTask?
    private var builder: RequestBuilder<Endpoint>
    private var validator: TaskValidator
    
    public init() {
        self.builder = RequestBuilder<Endpoint>()
        self.validator = RequestValidator()
    }
    
    /// Public function exposing functionality for use.
    ///
    /// Mainly respsonsable for taking in information about the
    /// desired request, kick off the operations, and return
    /// a simple respresentation of the data recieved or error
    /// encountered.
    ///
    /// - Parameter route: Passed in concrete model of type
    ///     RequestEndpoint
    public func request(_ route: Endpoint, _ completion: @escaping (Result<Data>) -> Void) {
        do {
            try execute(route: route) { data, response, error  in
                let validatedResult = self.validate(data: data, response: response, error: error)
                completion(validatedResult)
            }
        } catch {
            completion(.error(error))
        }
        
        self.task?.resume()
    }
    
    /// Cancel the URLSessionTask.
    public func cancel() {
        self.task?.cancel()
    }
}

fileprivate extension RequestExecutor {
    
    /// Executes the needed steps to fulfill a request.
    ///
    /// This method is where a mock json file will be loaded if
    /// the HTTPMethod in the `request` is specified as mock request.
    /// otherwise it will execute a dataTask.
    ///
    /// - Note: If a mock task is being executed a JSON file must be
    ///     saved to the project with the URL to the mock entered as
    ///     the host value.
    func execute(route: Endpoint, _ completion: @escaping NetworkResponseCompletion) throws {
        // Build request
        let request = try builder.build(with: route)
        
        // Execute Request
        if route.method == .mock {
            executeMockRequest(with: route.host) { (data, response, error) in
                completion(data, response, error)
                return
            }
        } else {
            executeDataTask(for: request) { (data, response, error) in
                completion(data, response, error)
            }
        }
    }
    
    /// Execution of live data task
    func executeDataTask(for request: URLRequest, _ completion: @escaping NetworkResponseCompletion) {
        let session = URLSession.shared
        
        self.task = session.dataTask(with: request, completionHandler: { data, response, error in
            completion(data, response, error)
        })
    }
    
    /// Execution used when testing or utilizing mock data.
    ///
    /// This will attempt to load data from a json at the given
    /// `URL` value.
    func executeMockRequest(with url: URL, _ completion: @escaping NetworkResponseCompletion){
        do {
            let mockData = try Data(contentsOf: url)
            let response = HTTPURLResponse.init(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)
            completion(mockData, response, nil)
        } catch {
            completion(nil, nil, NetworkError.mockLoadingFailure)
        }
    }
    
    /// Validates the the response and data of a network request
    func validate(data: Data?, response: URLResponse?, error: Error?) -> Result<Data> {
        if let error = error {
            return .error(error)
        }
        
        let validationResult = validator.validate(data: data, response: response)
        return validationResult
    }

}
