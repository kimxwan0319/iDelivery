//
//  ParcelDetailReactor.swift
//  iDelivery
//
//  Created by 김수완 on 2021/09/25.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import ReactorKit
import RxSwift
import RxCocoa

class ParcelDetailReactor: Reactor {

    private let disposeBag = DisposeBag()
    let initialState: State
    
    // MARK: Action
    enum Action {
    }

    // MARK: Mutation
    enum Mutation {
    }
    
    // MARK: State
    enum State {
    }
}

// MARK: - Action -> Mutation
extension ParcelDetailReactor {
    func mutate(action: Action) -> Observable<Mutation> {
    }
}

// MARK: - Mutation -> State
extension ParcelDetailReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        return newState
    }
}
