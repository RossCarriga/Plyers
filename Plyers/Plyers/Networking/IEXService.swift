//
//  DataTestBoi.swift
//  Plyers
//
//  Created by Ross Carrigan on 1/26/19.
//  Copyright © 2019 Ross Carrigan. All rights reserved.
//

import Foundation
import NetworkKit

struct IEXStatModel: Codable {
    var companyName: String?
    var week52high: Double?
    var week52low: Double?
    var symbol: String?
}

class IEXService {
    
    var statModel: IEXStatModel? {
        didSet {
            print(statModel?.companyName)
        }
    }
    
    func fetchStatModel(method: IEXRequest) {
        let executor = RequestExecutor<IEXRequest>()
       
        executor.request(method) { (result) in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(IEXStatModel.self, from: data)
                    self.statModel = decodedData
                } catch {
                    fatalError("Failed to load data")
                }
            case .error:
                fatalError("Failed to load data")
            }
        }
    }
}
