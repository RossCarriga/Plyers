//
//  BaseViewController.swift
//  MVVMBaseKit
//
//  Created by Ross Carrigan on 1/27/19.
//  Copyright © 2019 Ross Carrigan. All rights reserved.
//

import Foundation

public protocol ViewInterface: class {
    var viewModel: ViewModel { get }
    var _viewModel: ViewModel? { get set }
}

public class BaseViewController: UIViewController, ViewInterface {
    
    /// Optional reference to the viewModel. This allow for instanciation
    /// without the need to create a custom initializer
    public weak var _viewModel: ViewModel?
    
    // Strong reference to a ViewInterface. A fatalError is thrown when
    /// the viewController loses or has no reference to the viewModel this
    /// is to ensure adherance to the MVVM Pattern and also removes the
    /// need to constantly unwrap optional values.
    public var viewModel: ViewModel {
        guard let __viewModel = _viewModel else {
            fatalError("BaseViewController must have a reference to a ViewModel")
        }
        
        return __viewModel
    }
    
    deinit {
        _viewModel = nil
    }
}
