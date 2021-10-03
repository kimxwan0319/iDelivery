//
//  AppStep.swift
//  iDelivery
//
//  Created by 김수완 on 2021/10/02.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import RxFlow

enum AppStep: Step {
    case parcelListIsRequired
    case parcelIsPicked(parcel: Parcel)
}
