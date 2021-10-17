//
//  RegisterParcelUseCase.swift
//  iDelivery
//
//  Created by 김수완 on 2021/10/17.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import Foundation
import RxSwift

class RegisterParcelUseCase {

    @Inject private var parcelInformationRepository: ParcelInformationRepository
    @Inject private var userParcelsRepository: UserParcelsRepository

    func excute(
        deliveryCompany: DeliveryCompany,
        trackingNumber: String,
        name: String
    ) -> Observable<Parcel> {
        return parcelInformationRepository.fetchParcelInfo(
            deliveryCompanyId: deliveryCompany.companyId,
            trackingNumber: trackingNumber
        ).asObservable()
            .map { Parcel(
                deliveryCompany: deliveryCompany,
                trackingNumber: trackingNumber,
                name: name,
                state: $0.state)
            }
            .do(onNext: {
                self.userParcelsRepository.saveUserParcel(parcel: $0)
            })
    }
}
