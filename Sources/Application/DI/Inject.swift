//
//  Inject.swift
//  iDelivery
//
//  Created by 김수완 on 2021/10/01.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import Swinject

@propertyWrapper
public struct Inject<Value> {
    public private(set) var wrappedValue: Value
    
    public init() {
        wrappedValue = AppDelegate.container.resolve(Value.self)!
    }
}
