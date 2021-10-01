//
//  DeliveryCompanyListDTO.swift
//  iDelivery
//
//  Created by 김수완 on 2021/09/26.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import Foundation

// MARK: - Data Transfer Object
struct DeliveryCompanyDTO: Decodable {
    let id: String
    let name: String
    let tel: String
}

// MARK: - Mappings to Domain
extension DeliveryCompanyDTO {
    func toDomain() -> DeliveryCompany {
        return .init(
            companyId: id,
            companyName: name
        )
    }
}
