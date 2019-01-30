//
//  Result.swift
//  NetworkKit
//
//  Created by Ross Carrigan on 1/25/19.
//  Copyright © 2019 Ross Carrigan. All rights reserved.
//

import Foundation

/// Enumeration of potiential outcomes for network calls
///
/// - Note:
///     -- To designate a success without a return type, use Result<Void>
///     -- To designate success with a return type, use Result<T>
///     -- Where there can be a successful response, but the return type is
///        nullable, use Result<T?>
///     -- If there is a server error then call the `.error` case passing in the `Error`

public enum Result<T>{
    case success(T)
    case error(Error?)
}

extension Result {
    public var value: T? {
        switch self {
        case .success(let successValue):
            return successValue
        case .error:
            return nil
        }
    }
    
    public var error: Error? {
        switch self {
        case .success:
            return nil
        case .error(let error):
            return error
        }
    }
}
