//
//  FetchParcelInformationUseCase.swift
//  iDelivery
//
//  Created by 김수완 on 2021/10/04.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import Foundation
import RxSwift

class FetchParcelInformationUseCase {

    @Inject private var parcelInformationRepository: ParcelInformationRepository

    func excute(deliveryCompanyId: String, trackingNumber: String) -> Single<ParcelInformation> {
        return parcelInformationRepository.fetchParcelInfo(
            deliveryCompanyId: deliveryCompanyId,
            trackingNumber: trackingNumber
        )
    }
}
