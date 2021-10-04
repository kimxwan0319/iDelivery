//
//  ParcelInformation.swift
//  iDelivery
//
//  Created by 김수완 on 2021/10/03.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import Foundation

struct ParcelInformation {
    let sender: String
    let receiver: String
    let state: ParcelState
    let progesses: [Progress]
}

extension ParcelInformation {
    struct Progress {
        let time: String
        let status: ParcelState
        let location: String
        let description: String
    }
}
