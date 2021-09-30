//
//  FetchParcelListUseCase.swift
//  iDelivery
//
//  Created by 김수완 on 2021/09/30.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import Foundation
import RxSwift

class FetchParcelListUseCase {

    private let userParcelsRepository : UserParcelsRepository

    init(userParcelsRepository: UserParcelsRepository) {
        self.userParcelsRepository = userParcelsRepository
    }

    func execute() -> Single<[UserParcel]> {
        return userParcelsRepository.fetchUserParcels()
    }
}
