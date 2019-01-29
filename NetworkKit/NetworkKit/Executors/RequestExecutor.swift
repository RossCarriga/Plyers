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
    
    public init() {}
    
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
        let request = try buildRequest(from: route)
        
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
    
    func executeDataTask(for request: URLRequest, _ completion: @escaping NetworkResponseCompletion) {
        let session = URLSession.shared
        
        self.task = session.dataTask(with: request, completionHandler: { data, response, error in
            completion(data, response, error)
        })
    }
    
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
        
        let validator = TaskPostProcessValidator()
        let validationResult = validator.validate(data: data, response: response)
        return validationResult
    }
    
    /// Builds a URLRequest that is ready for execution
    ///
    /// Note:
    func buildRequest(from route: Endpoint) throws -> URLRequest {
        
        var request = URLRequest(url: route.host.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = route.method.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
            case .requestParameters(let bodyParameters, let urlParameters):
                try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, for: &request)
                
            case .requestParametersAndHeaders(let bodyParameters, let urlParameters, let additionalHeaders):
                self.addAdditionalHeaders(additionalHeaders, for: &request)
                try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, for: &request)
            }
        }
        return request
    }
    
    /// encodes and appends parameters onto passed in URLRequest
    func configureParameters(bodyParameters: HTTPParameters?, urlParameters: HTTPParameters?, for request: inout URLRequest) throws {
        do {
            
            if let bodyParameters = bodyParameters {
                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
            }
            
            if let urlParameters = urlParameters {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
        } catch {
            throw error
        }
    }
    
    /// Appends additional headers onto passed in URLRequest
    func addAdditionalHeaders(_ headers: HTTPHeaders?, for request: inout URLRequest) {
        guard let headers = headers else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
