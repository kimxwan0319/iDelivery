//
//  SectionOfProgress.swift
//  iDelivery
//
//  Created by 김수완 on 2021/10/23.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import RxDataSources_Texture

struct SectionOfProgress {
    var items: [Item]
}

extension SectionOfProgress: SectionModelType {
    typealias Item = ParcelInformation.Progress

    init(original: SectionOfProgress, items: [Item]) {
        self = original
        self.items = items
    }
}
