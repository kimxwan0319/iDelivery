//
//  Parcel.swift
//  iDelivery
//
//  Created by 김수완 on 2021/09/28.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import Foundation

struct Parcel {
    let trackingNumber: String
    let deliveryCompanyId: String
    let name: String
    let state: ParcelState
}
