//
//  UserParcelDTO.swift
//  iDelivery
//
//  Created by 김수완 on 2021/09/28.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import Foundation
import CoreData

// MARK: - Data Transfer Object

extension Parcel {
    func toEntity(_ context: NSManagedObjectContext) -> UserParcelEntity {
        let entity: UserParcelEntity = .init(context: context)
        entity.trackingNumber = trackingNumber
        entity.deliveryCompanyId = deliveryCompanyId
        entity.name = name
        entity.state = state.rawValue
        return entity
    }
}

// MARK: - Mappings to Domain

extension UserParcelEntity {
    func toDomain() -> Parcel {
        return .init(
            trackingNumber: trackingNumber!,
            deliveryCompanyId: deliveryCompanyId!,
            name: name!,
            state: ParcelState(rawValue: state!)!
        )
    }
}
