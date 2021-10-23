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

    @Inject private var fetchParcelInformationUseCase: FetchParcelInformationUseCase

    private let disposeBag = DisposeBag()
    let initialState: State

    private let parcel: Parcel

    // MARK: Action
    enum Action {
        case viewWillAppear
    }

    // MARK: Mutation
    enum Mutation {
        case setParcelInformation(ParcelInformation)
    }

    // MARK: State
    struct State {
        var basicParcelInfo: Parcel
        var senderAndReceiver: (
            sender: String,
            receiver: String
        )
        var parcelProgress: [ParcelInformation.Progress]
    }

    init(parcel: Parcel) {
        self.parcel = parcel
        self.initialState = State(
            basicParcelInfo: parcel,
            senderAndReceiver: (" ", " "),
            parcelProgress: []
        )
    }
}

// MARK: - Action -> Mutation
extension ParcelDetailReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return fetchParcelInformation()
                .asObservable()
                .map { .setParcelInformation($0) }
        }
    }

    private func fetchParcelInformation() -> Single<ParcelInformation> {
        return fetchParcelInformationUseCase.excute(
            deliveryCompanyId: self.parcel.deliveryCompany.companyId,
            trackingNumber: self.parcel.trackingNumber
        )
    }
}

// MARK: - Mutation -> State
extension ParcelDetailReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setParcelInformation(let parcelInformation):
            newState.parcelProgress = parcelInformation.progesses.reversed()
            newState.senderAndReceiver = (
                parcelInformation.sender,
                parcelInformation.receiver
            )
        }
        return newState
    }
}
