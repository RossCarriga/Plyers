//
//  ButtonModels.swift
//  ComponentLibrary
//
//  Created by Ross Carrigan on 1/9/19.
//  Copyright © 2019 Ross Carrigan. All rights reserved.
//

import UIKit

public enum ButtonContent {
    case text
    case image
    case both // TODO
}

public enum ButtonSize {
    case core
    case action
}

public enum ButtonStyle {
    case text
    case pill
}

// TODO: Add shadow component
struct ButtonStyleModel {
    var backgroundColor: UIColor
    var textColor: UIColor
}

struct ButtonSizeModel {
    var minHeight: CGFloat
    var minWidth: CGFloat
    var padding: UIEdgeInsets
    var cornerRadiusDivisor: CGFloat
}

