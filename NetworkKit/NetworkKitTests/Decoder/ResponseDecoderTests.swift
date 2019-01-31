//
//  ResponseDecoderTests.swift
//  NetworkKitTests
//
//  Created by Ross Carrigan on 1/30/19.
//  Copyright © 2019 Ross Carrigan. All rights reserved.
//

import XCTest
@testable import NetworkKit

class ResponseDecoderTests: XCTestCase {

    let decoder = ResponseDecoder()
    
    /// Tests decoding functionality for a successful
    /// response.
    func testDecodeValidResponse() {
        // Define expectations
        let expected = buildMockResponse(with: 200)
        
        // Perform operations
        let actual = decoder.decode(response: expected)
        
        // Compare
        XCTAssertNotNil(actual.value)
        XCTAssertEqual(actual.value, expected)
    }
    
    /// Tests decoding for Authentication
    /// Error response (400 - 499 error codes)
    func testDecodeAuthenticationErrorResponse() {
        // Define expectations
        let expected = NetworkError.authenticationFailure
        
        // Perform operations
        let mockResponse = buildMockResponse(with: 404)
        let actual = decoder.decode(response: mockResponse)
        
        // Compare
        guard let actualError = actual.error as? NetworkError else {
            XCTFail("Incorrect Error type returned")
            return
        }
        
        XCTAssertEqual(actualError, expected)
    }
    
    /// Tests decoding for Internal Server Error
    /// responses (500 - 599).
    func testDecodeInternalServerErrorResponse() {
        // Define expectations
        let expected = NetworkError.serverFailure
        
        // Perform operations
        let mockResponse = buildMockResponse(with: 500)
        let actual = decoder.decode(response: mockResponse)
        
        // Compare
        guard let actualError = actual.error as? NetworkError else {
            XCTFail("Incorrect Error type returned")
            return
        }
        XCTAssertEqual(actualError, expected)
    }
    
    /// Test decoding any response that doesn't have a
    /// specified error value.
    func testDecodeUndefinedErrorResponse() {
        // Define expectations
        let expected = NetworkError.undefinedFailure
        
        // Perform operations
        let mockResponse = buildMockResponse(with: 12345678990)
        let actual = decoder.decode(response: mockResponse)
        
        // Compare
        guard let actualError = actual.error as? NetworkError else {
            XCTFail("Incorrect Error type returned")
            return
        }
        
        XCTAssertEqual(actualError, expected)
    }
    
}

fileprivate extension ResponseDecoderTests {
    /// Builds a mock response for a given status code
    func buildMockResponse(with status: Int) -> URLResponse {
        let url = URL(fileURLWithPath: "url")
        let httpVersion = "HTTP/1.1"
        return HTTPURLResponse(url: url, statusCode: status, httpVersion: httpVersion, headerFields: nil)!
    }
}


