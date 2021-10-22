//
//  ASLineNode.swift
//  iDelivery
//
//  Created by 김수완 on 2021/10/22.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import AsyncDisplayKit

class ASLineNode: ASDisplayNode {
    enum Direction {
        case vertical
        case horizontal
    }

    init(direction: Direction, color: UIColor, width: CGFloat) {
        super.init()
        self.backgroundColor = color
        switch direction {
        case .vertical: self.style.preferredSize.width = 1
        case .horizontal: self.style.preferredSize.height = 1
        }
    }
}
