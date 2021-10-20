//
//  ASTextNode+setAttribute.swift
//  iDelivery
//
//  Created by 김수완 on 2021/10/20.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import AsyncDisplayKit

extension ASTextNode {
    public func setAttribute(
        font: UIFont,
        color: UIColor
    ) {
        self.attributedText = NSAttributedString(
            string: " ",
            attributes: [
                .font: font,
                .foregroundColor: color
            ]
        )
    }
}
