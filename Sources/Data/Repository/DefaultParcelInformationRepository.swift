//
//  DefaultParcelInformationRepository.swift
//  iDelivery
//
//  Created by 김수완 on 2021/10/03.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import Foundation
import RxSwift

class DefaultParcelInformationRepository: ParcelInformationRepository {
    func fetchParcelInfo(deliveryCompanyId: String, trackingNumber: String) -> Single<ParcelInformation> {
        HTTPClient.shared.networking(
            api: .fetchParcelInfo(deliveryCompanyId: deliveryCompanyId, trackingNumber: trackingNumber),
            dto: ParcelInformationDTO.self
        ).map {
            $0.toDomain()
        }
    }
}
