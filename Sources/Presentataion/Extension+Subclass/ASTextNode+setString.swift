//
//  ASTextNode+setString.swift
//  iDelivery
//
//  Created by 김수완 on 2021/09/17.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import AsyncDisplayKit

extension ASTextNode {
    public func setString(_ string: String) {
        self.attributedText = NSAttributedString(
            string: string,
            attributes: self.attributedText?.attributes(at: 0, effectiveRange: nil)
        )
    }
}
