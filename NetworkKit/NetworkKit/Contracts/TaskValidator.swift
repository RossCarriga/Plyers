//
//  TaskValidator.swift
//  NetworkKit
//
//  Created by Ross Carrigan on 1/27/19.
//  Copyright © 2019 Ross Carrigan. All rights reserved.
//

import Foundation

protocol TaskValidator {
    func validate(data: Data?, response: URLResponse?) -> Result<Data>
    
    func validate(data: Data?) -> Result<Data>
    func validate(response: URLResponse?) -> Result<URLResponse>
}
