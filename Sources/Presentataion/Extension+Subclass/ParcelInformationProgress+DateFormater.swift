//
//  ParcelInformationProgress+DateFormater.swift
//  iDelivery
//
//  Created by 김수완 on 2021/10/23.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import Foundation

extension ParcelInformation.Progress {
    private func formatResult() -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssz"
        return formatter.date(from: self.time)!
    }

    func dateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: formatResult())
    }
    func timeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: formatResult())
    }
}
