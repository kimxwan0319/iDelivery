//
//  ParcelState.swift
//  iDelivery
//
//  Created by 김수완 on 2021/10/12.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import Foundation

extension ParcelState {
    func displayString() -> String {
        switch self {
        case .informationReceived:
            return "상품준비중"
        case .atPickup:
            return "상품인수"
        case .inTransit:
            return "상품이동중"
        case .outForDelivery:
            return "배송출발"
        case .delivered:
            return "배송완료"
        }
    }
}
