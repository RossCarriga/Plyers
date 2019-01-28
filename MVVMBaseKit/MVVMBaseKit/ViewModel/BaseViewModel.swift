//
//  BaseViewModel.swift
//  MVVMBaseKit
//
//  Created by Ross Carrigan on 1/27/19.
//  Copyright © 2019 Ross Carrigan. All rights reserved.
//

import Foundation

public protocol ViewModel: class {
    var _viewInterface: ViewInterface? { get set }
    var viewInterface: ViewInterface { get }
}

public class BaseViewModel: ViewModel {
    
    /// Optional reference to the viewInterface. This allow for instanciation
    /// without the need to create a custom initializer
    public weak var _viewInterface: ViewInterface?
    
    /// Strong reference to a ViewInterface. A fatalError is thrown when
    /// the viewModel loses or has no reference to the viewInterface this
    /// is to ensure adherance to the MVVM Pattern and also removes the
    /// need to constantly unwrap optional values.
    public var viewInterface: ViewInterface {
        guard let __viewInterface = _viewInterface else {
            fatalError("ViewModel must have a reference to the viewController")
        }
        
        return __viewInterface
    }
    
    deinit {
        _viewInterface = nil
    }
}
