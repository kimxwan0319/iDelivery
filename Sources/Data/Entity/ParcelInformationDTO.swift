//
//  ParcelInformationDTO.swift
//  iDelivery
//
//  Created by 김수완 on 2021/10/03.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import Foundation

// MARK: - Data Transfer Object

struct ParcelInformationDTO: Decodable {
    let from: FromAndTo
    let to: FromAndTo
    let state: State
    let progresses: [Progress]
    let carrier: DeliveryCompanyDTO
}

extension ParcelInformationDTO {
    struct FromAndTo: Decodable {
        let name: String?
        let time: String?
    }
    struct State: Decodable {
        let id: String
        let text: String
    }
    struct Progress: Decodable {
        let time: String
        let status: State
        let location: Location
        let description: String

        struct Location: Decodable {
            let name: String
        }
    }
}

// MARK: - Mappings to Domain

extension ParcelInformationDTO {
    func toDomain() -> ParcelInformation {
        return .init(
            sender: from.name ?? "",
            receiver: to.name ?? "",
            state: ParcelState(rawValue: state.id)!,
            progesses: progresses.map { $0.toDomain() }
        )
    }
}

extension ParcelInformationDTO.Progress {
    func toDomain() -> ParcelInformation.Progress {
        return .init(
            time: time,
            status: ParcelState(rawValue: status.id)!,
            location: location.name,
            description: description
        )
    }
}
