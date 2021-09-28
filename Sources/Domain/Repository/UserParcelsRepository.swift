//
//  UserParcelsRepository.swift
//  iDelivery
//
//  Created by 김수완 on 2021/09/26.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import Foundation
import RxSwift

protocol UserParcelsRepository {
    func getUserParcels() -> Single<[UserParcel]>
}
