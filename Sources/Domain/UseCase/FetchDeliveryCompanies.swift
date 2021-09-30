//
//  FetchDeliveryCompanies.swift
//  iDelivery
//
//  Created by 김수완 on 2021/09/30.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import Foundation
import RxSwift

class FetchDeliveryCompanies {

    private let deliveryCompaniesRepository : DeliveryCompaniesRepository

    init(deliveryCompaniesRepository: DeliveryCompaniesRepository) {
        self.deliveryCompaniesRepository = deliveryCompaniesRepository
    }

    func execute() -> Single<[DeliveryCompany]> {
        return deliveryCompaniesRepository.getDeliveryCompanyList()
    }
}