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
    
    var viewInterface: ViewInterface?
    
    var viewModel: ViewModel? {
        
        if let __viewModel = self.viewModel {
            return __viewModel
        }
        
        viewInterface = buildViewInterface()
        let __viewModel = buildViewModel()
        
        guard let viewInterface = viewInterface else { return nil }
        viewInterface._viewModel = __viewModel
        return __viewModel
    }
    
    public func buildViewInterface() -> ViewInterface {
        fatalError("Must be implemented in sub class")
    }
    
    public func buildViewModel() -> ViewModel {
        fatalError("Must be implemented in sub class")
    }
    
}
