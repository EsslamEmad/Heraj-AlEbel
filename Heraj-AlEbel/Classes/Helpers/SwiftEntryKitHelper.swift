//
//  SwiftEntryKitHelper.swift
//  3alsari3
//
//  Created by Mohamad Tarek on 24/6/19.
//  Copyright © 2019 Al-Youm-Host. All rights reserved.
//

import SwiftEntryKit

class SwiftEntryKitHelper {
    
    static var defaultAttributes: EKAttributes {
        var attributes = EKAttributes()
        attributes.position = .center
        attributes.displayDuration = .infinity
        let widthConstraint = EKAttributes.PositionConstraints.Edge.ratio(value: 0.9)
        let heightConstraint = EKAttributes.PositionConstraints.Edge.intrinsic
        attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint)
        attributes.positionConstraints.rotation.isEnabled = false
        let offset = EKAttributes.PositionConstraints.KeyboardRelation.Offset(bottom: 10, screenEdgeResistance: 20)
        let keyboardRelation = EKAttributes.PositionConstraints.KeyboardRelation.bind(offset: offset)
        attributes.positionConstraints.keyboardRelation = keyboardRelation
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .disabled
        attributes.roundCorners = .all(radius: 20)
        attributes.border = .value(color: .darkGray, width: 0.5)
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.2, radius: 10, offset: .zero))
        attributes.entryBackground = .color(color: .white)
        attributes.screenBackground = .visualEffect(style: .regular)
        return attributes
    }
    
}
