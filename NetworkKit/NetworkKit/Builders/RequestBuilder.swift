//
//  RequestBuilder.swift
//  NetworkKit
//
//  Created by Ross Carrigan on 1/29/19.
//  Copyright © 2019 Ross Carrigan. All rights reserved.
//

import Foundation

class RequestBuilder<Endpoint: RequestEndpoint>: NetworkBuildable {
    
    /// builds a usable piece of data for an executor
    ///
    /// - TODO: Decouple the return from URLRequest to a generic Result.
    func build(with route: Endpoint) throws -> URLRequest {
        var request = URLRequest(url: route.host.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = route.method.rawValue
        try handleRequestTasks(with: route, for: &request)
        
        return request
    }
}

fileprivate extension RequestBuilder {
    
    /// Switches through the different types of tasks defined
    /// and takes undergoes the required setup.
    ///
    /// - Parameter route: information given to define desired
    ///     functionality
    /// - Parameter request: Reference to the actionable items
    ///     being built by this builder
    func handleRequestTasks(with route: Endpoint, for request: inout URLRequest) throws {
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
