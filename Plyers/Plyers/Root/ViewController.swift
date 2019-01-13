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

    @IBOutlet weak var boiButton: Button!
    @IBOutlet weak var coreButton: Button!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        boiButton.configure(with: "Button Component", style: .pill, size: .action)
        
        coreButton.configure(with: "Core Button", style: .pill, size: .core)
    }
}


