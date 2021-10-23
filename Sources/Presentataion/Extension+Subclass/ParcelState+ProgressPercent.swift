//
//  ParcelState+ProgressPercent.swift
//  iDelivery
//
//  Created by 김수완 on 2021/10/23.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import Foundation

extension ParcelState {
    func progressPercent() -> Int {
        switch self {
        case .informationReceived:
            return 20
        case .atPickup:
            return 40
        case .inTransit:
            return 60
        case .outForDelivery:
            return 80
        case .delivered:
            return 100
        }
    }
}
