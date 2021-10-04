//
//  SaveParcelUseCase.swift
//  iDelivery
//
//  Created by 김수완 on 2021/09/30.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import Foundation
import RxSwift

class SaveParcelUseCase {

    @Inject private var userParcelsRepository: UserParcelsRepository

    func execute(userParcel: Parcel) {
        return userParcelsRepository.saveUserParcel(parcel: userParcel)
    }
}
