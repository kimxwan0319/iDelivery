//
//  SaveParcelListUseCase.swift
//  iDelivery
//
//  Created by 김수완 on 2021/09/30.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import Foundation
import RxSwift

class SaveParcelListUseCase {

    private let userParcelsRepository : UserParcelsRepository

    init(userParcelsRepository: UserParcelsRepository) {
        self.userParcelsRepository = userParcelsRepository
    }

    func execute(userParcel: UserParcel) {
        return userParcelsRepository.saveUserParcel(parcel: userParcel)
    }
}
