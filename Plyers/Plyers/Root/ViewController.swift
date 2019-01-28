//
//  ViewController.swift
//  Plyers
//
//  Created by Ross Carrigan on 12/31/18.
//  Copyright © 2018 Ross Carrigan. All rights reserved.
//

import UIKit
import ComponentLibrary

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let service = IEXService()
        service.fetchStatModel(method: IEXRequest.stats(stock: "TM"))
        
        print(service.statModel ?? "Failed")
    }

}


