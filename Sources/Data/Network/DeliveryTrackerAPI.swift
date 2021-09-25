//
//  DeliveryTrackerAPI.swift
//  iDelivery
//
//  Created by 김수완 on 2021/09/25.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import Moya

enum DeliveryTrackerAPI {
    case getDeliveryCompanyList
    case trackingPost(deliveryCompanyId: String, trackingNumber: Int)
}

extension DeliveryTrackerAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://apis.tracker.delivery")!
    }
    
    var path: String {
        switch self {
        case .getDeliveryCompanyList:
            return "/carriers"
        case .trackingPost(let deliveryCompanyId, let trackingNumber):
            return "/carriers/\(deliveryCompanyId)/tracks/\(trackingNumber)"
        }
    }
    
    var method: Method {
        return .get
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
}
