//
//  ParcelListReactor.swift
//  iDelivery
//
//  Created by 김수완 on 2021/09/25.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import ReactorKit

class PostListReactor: Reactor {
    let initialState: State
    private let disposeBag = DisposeBag()
    
    // MARK: Actions
    enum Action {
    }
    
    // MARK: Mutations
    enum Mutation {
    }
    
    // MARK: State
    struct State {
    }
    
    init() {
        self.initialState = State()
     }
    
    // MARK: Action -> Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        }
        return newState
    }
}
