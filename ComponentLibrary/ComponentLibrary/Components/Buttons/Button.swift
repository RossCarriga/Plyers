//
//  Button.swift
//  ComponentLibrary
//
//  Created by Ross Carrigan on 1/7/19.
//  Copyright © 2019 Ross Carrigan. All rights reserved.
//

import UIKit

open class Button: UIButton {
    
    var style: ButtonStyle = .pill
    var size: ButtonSize = .action
    var content: ButtonContent = .text
    
    var text: String?
    var image: UIImage?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

public extension Button {
    /*
     Configure setup functions
     
     The Button API includes a series of configure functions. This will give the option to
     either create a button with an image or text and assign the desired properties to a
     button.
     */
    
    func configure(with text: String, style: ButtonStyle, size: ButtonSize) {
        self.style = style
        self.size = size
        self.text = text
        self.content = .text
        setup()
    }
    
    func configure(with image: UIImage, style: ButtonStyle, size: ButtonSize) {
        self.style = style
        self.size = size
        self.image = image
        self.content = .image
        setup()
    }
}

fileprivate extension Button {
    func setup() {
        let factory = ButtonFactory()
        let sizeModel = factory.getSizes(for: size)
        let styleModel = factory.getStyles(for: style)
        
        setupContent()
        setupSizing(with: sizeModel)
        setupStyles(with: styleModel)
        layoutSubviews()
    }
    
    func setupContent() {
        switch content {
        case .image:
            setImage(self.image, for: .normal)
            
        case .text:
            setTitle(self.text, for: .normal)
            
        default:
            fatalError("Button: Content type not implimented for \(self.content)")
        }
    }
    
    func setupStyles(with styles: ButtonStyleModel) {
        setTitleColor(styles.textColor, for: .normal)
        self.backgroundColor = styles.backgroundColor
    }
    
    func setupSizing(with sizing: ButtonSizeModel) {
        self.widthAnchor.constraint(greaterThanOrEqualToConstant: sizing.minWidth)
        self.heightAnchor.constraint(greaterThanOrEqualToConstant: sizing.minHeight)
        self.contentEdgeInsets = sizing.padding
        self.layer.cornerRadius = self.frame.width / sizing.cornerRadiusDivisor
    }
}


