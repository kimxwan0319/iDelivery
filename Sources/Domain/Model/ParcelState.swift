//
//  ParcelState.swift
//  iDelivery
//
//  Created by 김수완 on 2021/10/04.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import Foundation

enum ParcelState: String {
    case informationReceived = "information_received"
    case atPickup = "at_pickup"
    case inTransit = "in_transit"
    case outForDelivery = "out_for_delivery"
    case delivered = "delivered"
}
