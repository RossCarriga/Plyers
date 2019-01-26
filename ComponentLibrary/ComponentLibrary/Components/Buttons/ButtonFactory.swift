//
//  ButtonFactory.swift
//  ComponentLibrary
//
//  Created by Ross Carrigan on 1/9/19.
//  Copyright © 2019 Ross Carrigan. All rights reserved.
//

import Foundation

// TODO: Fit and Finish

class ButtonFactory {
    
    public func getSizes(for size: ButtonSize) -> ButtonSizeModel {
        switch size {
        case .action:
            let minHeight: CGFloat = 45.0
            let minWidth: CGFloat = 75.0
            let padding = UIEdgeInsets.init(top: 8, left: 16, bottom: 8, right: 16)
            let cornerRadiusDivisor: CGFloat = 2.5
            
            return ButtonSizeModel(minHeight: minHeight,
                                   minWidth: minWidth,
                                   padding: padding,
                                   cornerRadiusDivisor: cornerRadiusDivisor)
            
        case .core:
            let minHeight: CGFloat = 36.0
            let minWidth: CGFloat = 60.0
            let padding = UIEdgeInsets.init(top: 4, left: 8, bottom: 4, right: 8)
            let cornerRadiusDivisor: CGFloat = 3.5
            
            return ButtonSizeModel(minHeight: minHeight,
                                   minWidth: minWidth,
                                   padding: padding,
                                   cornerRadiusDivisor: cornerRadiusDivisor)
        }
    }
    
    public func getStyles(for style: ButtonStyle) -> ButtonStyleModel {
        switch style {
        case .pill:
            let backgroundColor = Color.darkPurple
            let textColor = Color.white
            return ButtonStyleModel(backgroundColor: backgroundColor,
                                    textColor: textColor)
            
        case .text:
            let backgroundColor = UIColor.clear
            let textColor = Color.primaryPurple
            return ButtonStyleModel(backgroundColor: backgroundColor,
                                    textColor: textColor)
        }
    }
    
}
