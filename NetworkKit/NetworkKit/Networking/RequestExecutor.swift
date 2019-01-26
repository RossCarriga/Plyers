//
//  RequestExecutor.swift
//  NetworkKit
//
//  Created by Ross Carrigan on 1/26/19.
//  Copyright © 2019 Ross Carrigan. All rights reserved.
//

import Foundation

class RequestExecutor<Endpoint: DataEndpoint>: NetworkExecutable {
    
    private var task: URLSessionTask?
    
    func request(_ route: Endpoint, _ completion: @escaping NetworkRequestCompletion) {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        } catch {
            completion(nil, nil, error)
        }
        
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
}

fileprivate extension RequestExecutor {
    func buildRequest(from route: Endpoint) throws -> URLRequest {
        var request = URLRequest(url: route.host.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 30.0)
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
