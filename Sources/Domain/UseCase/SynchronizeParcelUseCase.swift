//
//  SynchronizeParcelUseCase.swift
//  iDelivery
//
//  Created by 김수완 on 2021/10/06.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import Foundation
import RxSwift

class SynchronizeParcelUseCase {

    @Inject private var parcelInformationRepository: ParcelInformationRepository

    func excute(parcel: Parcel) -> Single<Parcel> {
        return parcelInformationRepository.fetchParcelInfo(
            deliveryCompanyId: parcel.deliveryCompanyId,
            trackingNumber: parcel.trackingNumber
        ).map {
            Parcel(
                trackingNumber: parcel.trackingNumber,
                deliveryCompanyId: parcel.deliveryCompanyId,
                name: parcel.name,
                state: $0.state
            )
        }
    }
}
