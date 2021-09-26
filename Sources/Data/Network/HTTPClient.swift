//
//  HTTPClient.swift
//  iDelivery
//
//  Created by 김수완 on 2021/09/25.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import RxSwift
import Moya

class HTTPClient {
    public static let shared = HTTPClient()
    private let provider = MoyaProvider<DeliveryTrackerAPI>()

    private init() {}

    public func networking<T: Decodable>(api: DeliveryTrackerAPI, model networkModel: T.Type) -> Single<T> {
        return provider.rx.request(api).map(T.self)
    }
}
