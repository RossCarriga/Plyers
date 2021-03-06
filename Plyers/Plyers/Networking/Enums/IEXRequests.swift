//
//  IEXRequests.swift
//  Plyers
//
//  Created by Ross Carrigan on 1/26/19.
//  Copyright © 2019 Ross Carrigan. All rights reserved.
//

import Foundation
import NetworkKit

public enum IEXTimeframe: String {    
    case fiveYears = "5y"
    case twoYears = "2y"
    case oneYear = "1y"
    case yearToDate = "ytd"
    case sixMonths = "6m"
    case threeMonths = "3m"
    case oneMonth = "1m"
    case oneDay = "1d"
}

public enum IEXRequest {
    case list                                               //https://api.iextrading.com/1.0/stock/market/list
    case chart(stock: String, timeframe: IEXTimeframe)      //https://api.iextrading.com/1.0/stock/aapl/chart/ytd
    case stats(stock: String)                               //https://api.iextrading.com/1.0/stock/aapl/stats
    case mock(filename: String)
}

extension IEXRequest: RequestEndpoint {
    public var host: URL {
        switch self {
        case .stats:
            return URL(string: "https://api.iextrading.com/1.0/stock/")!
            
        case .mock(let filename):
            return Bundle.main.url(forResource: filename, withExtension: "json")!
            
        default:
            fatalError("Not done yet!")
        }
    }
    
    public var path: String {
        switch self {
        case .chart(let stock, let timeframe):
            return "\(stock)/chart/\(timeframe.rawValue)"
            
        case .stats(let stock):
            return "\(stock)/stats"
            
        case .list:
            return "stock/market/list"
        
        case .mock:
            return ""
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .mock:
            return .mock
        default:
            return .get
        }
    }
    
    public var query: [URLQueryItem]? {
        return nil
    }
    
    public var task: HTTPTask {
        return .request
    }
    
    public var headers: HTTPHeaders? {
        return nil
    }
}
