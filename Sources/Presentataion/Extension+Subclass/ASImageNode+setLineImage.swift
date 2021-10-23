//
//  ASImageNode+setLineImage.swift
//  iDelivery
//
//  Created by 김수완 on 2021/09/23.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import AsyncDisplayKit

extension ASImageNode {
    enum State: String {
        case only = "Only"
        case start = "Start"
        case middle = "Middle"
        case end = "End"
    }
    func setLineImage(state: State) {
        self.image = UIImage(named: state.rawValue)!
    }
}
