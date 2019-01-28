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
            let request = try self.buildRequest(from: route)
            try execute(request: request) { (result) in
                switch result {
                case .success(let data):
                    completion(.success(data))
                case .error(let error):
                    completion(.error(error))
                }
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
    
    func execute(request: URLRequest, _ completion: @escaping (Result<Data>) -> Void) throws {
        let session = URLSession.shared
        
        task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            guard error == nil else {
                completion(.error(error))
                return
            }
            
            let validator = TaskPostProcessValidator()
            let validationResult = validator.validate(data: data, response: response)
            
            completion(validationResult)
        })
    }
    
    
    
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
    
    func addAdditionalHeaders(_ headers: HTTPHeaders?, for request: inout URLRequest) {
        guard let headers = headers else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
