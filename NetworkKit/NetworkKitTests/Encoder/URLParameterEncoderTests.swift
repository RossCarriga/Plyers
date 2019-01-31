//
//  URLParameterEncoderTests.swift
//  NetworkKitTests
//
//  Created by Ross Carrigan on 1/30/19.
//  Copyright © 2019 Ross Carrigan. All rights reserved.
//

import XCTest
@testable import NetworkKit

class URLParameterEncoderTests: XCTestCase {

    func testInvalidRequestError() {
        // Define expectations
        
        // Preform operations
        var request = buildMockRequest()
        request.url = nil // causes invalid request
        
        do {
            try URLParameterEncoder.encode(urlRequest: &request, with: [:])
        } catch {
            guard let error = error as? NetworkError else {
                XCTFail("Incorrect error passed")
                return
            }
            
            XCTAssertEqual(error, NetworkError.invalidRequest)
         }
    }
    
    func testURLEncodingWithNoParameters() {
        // Define expectations
        let expectedHeader = "application/x-www-form-urlencoded; charset=utf-8"
        
        // Preform operations
        var request = buildMockRequest()

        do {
            try URLParameterEncoder.encode(urlRequest: &request, with: [:])
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        // compare
        let queryItems = extractQueryItems(from: request.url)
        XCTAssertNil(queryItems)
        
        let headers = request.allHTTPHeaderFields
        XCTAssertEqual(headers?["Content-Type"], expectedHeader)
    }
    
    func testURLEncodingWithParameters() {
        // Define expectations
        let successValue = "successful"
        let parameterCount = 2

        let testingParameters = [
            "testParameter1": successValue,
            "testParameter2": successValue
        ]
        
        // Preform operations
        var request = buildMockRequest()
        
        do {
            try URLParameterEncoder.encode(urlRequest: &request, with: testingParameters)
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        // Compare
        guard let queryItems = extractQueryItems(from: request.url) else {
            XCTFail("Nil queryItems")
            return
        }
        
        XCTAssertEqual(queryItems.count, parameterCount)
    
        let keys = Array(testingParameters.keys)
        XCTAssertEqual(queryItems[0].name, keys[0])
        XCTAssertEqual(queryItems[1].name, keys[1])
        
        let values = Array(testingParameters.values)
        XCTAssertEqual(queryItems[0].value, values[0])
        XCTAssertEqual(queryItems[1].value, values[1])
    }
}

fileprivate extension URLParameterEncoderTests {
    // Helpers
    private func buildMockRequest() -> URLRequest {
        let url = URL(fileURLWithPath: "url")
        return URLRequest(url: url)
    }
    
    private func extractQueryItems(from url: URL?) -> [URLQueryItem]? {
        if let urlString = url?.absoluteString,
            let urlComponents = URLComponents(string: urlString),
            let queryItems = urlComponents.queryItems {
            
            return queryItems
        }
        
        return nil
    }
}
