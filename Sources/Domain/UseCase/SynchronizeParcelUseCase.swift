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
    @Inject private var userParcelsRepository: UserParcelsRepository

    func excute(parcel: Parcel) -> Single<Parcel> {
        return parcelInformationRepository.fetchParcelInfo(
            deliveryCompanyId: parcel.deliveryCompany.companyId,
            trackingNumber: parcel.trackingNumber
        ).map {
            Parcel(
                deliveryCompany: parcel.deliveryCompany,
                trackingNumber: parcel.trackingNumber,
                name: parcel.name,
                state: $0.state
            )
        }.do(onSuccess: {
            self.userParcelsRepository.synchronizeUserParcel(parcel: $0)
        })
    }
}
