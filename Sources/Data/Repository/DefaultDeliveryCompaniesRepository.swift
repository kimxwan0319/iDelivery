//
//  DefaultDeliveryCompaniesRepository.swift
//  iDelivery
//
//  Created by 김수완 on 2021/09/26.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import Foundation
import RxSwift

class DefaultDeliveryCompaniesRepository: DeliveryCompaniesRepository {
    func getDeliveryCompanyList() -> Single<[DeliveryCompany]> {
        return Single<[DeliveryCompany]>.create { single in
            return HTTPClient.shared.networking(
                api: .getDeliveryCompanyList,
                model: [DeliveryCompanyDTO].self)
                .subscribe(onSuccess: { deliveryCompanyDTO in
                    return single(.success(deliveryCompanyDTO.map{ $0.toDomain() }))
                }, onFailure: { error in
                    return single(.failure(error))
                })
        }
    }
}
