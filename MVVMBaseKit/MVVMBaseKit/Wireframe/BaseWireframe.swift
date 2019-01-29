//
//  BaseWireframe.swift
//  MVVMBaseKit
//
//  Created by Ross Carrigan on 1/27/19.
//  Copyright © 2019 Ross Carrigan. All rights reserved.
//

import Foundation

public protocol Wireframe: class {
    
    func buildViewInterface() -> ViewInterface
    func buildViewModel() -> ViewModel
    
}

public class BaseWireframe: Wireframe {
    
    var _viewInterface: ViewInterface?
    var viewInterface: ViewInterface {
        if let __viewInterface = self._viewInterface {
            return __viewInterface
        }
        
        let __viewInterface = buildViewInterface()
        _viewInterface = __viewInterface
        return __viewInterface
    }
    
    var _viewModel: ViewModel?
    var viewModel: ViewModel {
        
        if let __viewModel = self._viewModel {
            return __viewModel
        }
        
        let __viewModel = buildViewModel()
        
        viewInterface._viewModel = __viewModel
        __viewModel._viewInterface = viewInterface
        _viewModel = __viewModel
        
        return __viewModel
    }
    
    public func buildViewInterface() -> ViewInterface {
        fatalError("Must be implemented in sub class")
    }
    
    public func buildViewModel() -> ViewModel {
        fatalError("Must be implemented in sub class")
    }
    
}
