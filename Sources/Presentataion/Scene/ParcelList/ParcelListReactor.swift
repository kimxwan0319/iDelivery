//
//  ParcelListReactor.swift
//  iDelivery
//
//  Created by 김수완 on 2021/09/25.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import ReactorKit
import RxSwift
import RxCocoa
import RxFlow

class ParcelListReactor: Reactor, Stepper {

    @Inject private var fetchParcelListUseCase: FetchParcelListUseCase
    @Inject private var synchronizeParcelUseCase: SynchronizeParcelUseCase
    @Inject private var saveParcelUseCase: SaveParcelUseCase
    @Inject private var deleteParcelUseCase: DeleteParcelUseCase
    @Inject private var checkParcelStateUseCase: CheckParcelStateUseCase
    @Inject private var fetchDeliveryCompaniesUseCase: FetchDeliveryCompaniesUseCase

    private let disposeBag = DisposeBag()
    var steps = PublishRelay<Step>()
    let initialState: State

    private var deliveryCompanies = [DeliveryCompany]()

    // MARK: Action
    enum Action {
        case viewDidLoad
        case tapPlusButton
        case registerParcel(deliveryCompany: String, trackingNumber: String, name: String)
        case parcelIsPicked(parcel: Parcel)
        case deleteParcel(parcel: Parcel)
    }

    // MARK: Mutation
    enum Mutation {
        case setList([Parcel])
        case synchronizeParcel(Parcel)
        case appendList(Parcel)
        case showRegisterParcelAlert([DeliveryCompany])
    }

    // MARK: State
    struct State {
        var parcelList: [Parcel]
        var showRegisterParcelAlert: [DeliveryCompany]
    }

    init() {
        self.initialState = State(parcelList: [], showRegisterParcelAlert: [])
     }

}

// MARK: - Action -> Mutation
extension ParcelListReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let localUserParcels = fetchParcelListUseCase.execute()
            let stateCheckedUserParcels: Observable<Parcel> = localUserParcels
                .asObservable()
                .flatMap { parcels -> Observable<Parcel> in
                    return self.synchronizeParcelsState(parcels: parcels)
                }
            fetchDeliveryCompanies()
            return .concat([
                localUserParcels.asObservable().map { .setList($0) },
                stateCheckedUserParcels.map { .synchronizeParcel($0) }
            ])

        case .tapPlusButton:
            return .just(.showRegisterParcelAlert(self.deliveryCompanies))

        case .registerParcel(let deliveryCompanyId, let trackingNumber, let name):
            return checkParcelStateUseCase.excute(
                deliveryCompanyId: deliveryCompanyId,
                trackingNumber: trackingNumber
            ).asObservable().map {
                .appendList(Parcel(
                    deliveryCompanyId: deliveryCompanyId,
                    trackingNumber: trackingNumber,
                    name: name,
                    state: $0
                ))
            }

        case .parcelIsPicked(let parcel):
            steps.accept(AppStep.parcelIsPicked(parcel: parcel))
            return .empty()

        case .deleteParcel(let parcel):
            deleteParcelUseCase.execute(userParcel: parcel)
            return .empty()
        }

    }

    private func fetchDeliveryCompanies() {
        fetchDeliveryCompaniesUseCase.execute().subscribe(onSuccess: { [weak self] deliveryCompanies in
            self?.deliveryCompanies = deliveryCompanies
        })
        .disposed(by: disposeBag)
    }

    private func synchronizeParcelsState(parcels: [Parcel]) -> Observable<Parcel> {
        let singles = parcels.map { synchronizeParcelUseCase.excute(parcel: $0) }
        return Observable.from(singles).merge()
    }
}

// MARK: - Mutation -> State
extension ParcelListReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setList(let parcels):
            newState.parcelList = parcels

        case .appendList(let parcel):
            newState.parcelList.append(parcel)

        case .showRegisterParcelAlert(let deliveryCompaies):
            newState.showRegisterParcelAlert = deliveryCompaies

        case .synchronizeParcel(let parcel):
            let parcelIndex = newState.parcelList.firstIndex {
                $0.deliveryCompanyId == parcel.deliveryCompanyId &&
                $0.trackingNumber == parcel.trackingNumber
            }!
            newState.parcelList[parcelIndex] = parcel

        }
        return newState
    }
}
