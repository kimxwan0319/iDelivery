//
//  SectionOfParcel.swift
//  iDelivery
//
//  Created by 김수완 on 2021/10/10.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import RxDataSources_Texture

struct SectionOfParcel {
    var items: [Item]
}

extension SectionOfParcel: SectionModelType {
    typealias Item = Parcel

    init(original: SectionOfParcel, items: [Item]) {
        self = original
        self.items = items
    }
}
