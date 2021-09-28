//
//  UserParcelDTO.swift
//  iDelivery
//
//  Created by 김수완 on 2021/09/28.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import Foundation
import CoreData

extension UserParcelEntity {
    func toDomain() -> UserParcel {
        return .init(
            trackingNumber: trackingNumber ?? "",
            deliveryCompanyId: deliveryCompanyId ?? "",
            name: name ?? "",
            state: state ?? ""
        )
    }
}
