//
//  HTTPTask.swift
//  NetworkKit
//
//  Created by Ross Carrigan on 1/26/19.
//  Copyright © 2019 Ross Carrigan. All rights reserved.
//

import Foundation

enum HTTPTask {
    case request
    
    case requestParameters(bodyParameters: HTTPParameters?,
                           urlParameters: HTTPParameters?)
    
    case requestParametersAndHeaders(bodyParameters: HTTPParameters?,
                                     urlParameters: HTTPParameters?,
                                     additionalHeaders: HTTPHeaders)
    
    // TODO: Add more tasks for image downloading / uploading & OAuth
}
