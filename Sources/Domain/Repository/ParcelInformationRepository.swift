//
//  ParcelInformationRepository.swift
//  iDelivery
//
//  Created by 김수완 on 2021/10/03.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import Foundation
import RxSwift

protocol ParcelInformationRepository {
    func fetchParcelInfo(deliveryCompanyId: String, trackingNumber: String) -> Single<ParcelInformation>
}
