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

    // MARK: Action
    enum Action {
        case viewDidLoad
        case tapPlusButton
        case registerParcel(deliveryCompanyId: String, trackingNumber: String, name: String)
        case parcelIsPicked(parcel: Parcel)
        case deleteParcel(parcel: Parcel)
    }

    // MARK: Mutation
    enum Mutation {
        case setParcelList([Parcel])
        case setDeliveryCompanyList([DeliveryCompany])
        case synchronizeParcel(Parcel)
        case appendParcelList(Parcel)
        case showRegisterParcelAlert
        case setAlertMessage(String)
    }

    // MARK: State
    struct State {
        var parcelList: [Parcel]
        var deliveryCompanyList: [DeliveryCompany]
        var showAlert: AlertType?
    }

    enum AlertType {
        case notification(message: String)
        case registerParcel
    }

    init() {
        self.initialState = State(
            parcelList: [],
            deliveryCompanyList: []
        )
     }

}

// MARK: - Action -> Mutation
extension ParcelListReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let deliveryCompanies = fetchDeliveryCompaniesUseCase.execute()
            let localUserParcels = fetchParcelListUseCase.execute()
            let stateCheckedUserParcels: Observable<Parcel> = localUserParcels
                .asObservable()
                .flatMap { parcels -> Observable<Parcel> in
                    return self.synchronizeParcelsState(parcels: parcels)
                }
            return .concat([
                deliveryCompanies.asObservable().map { .setDeliveryCompanyList($0) },
                localUserParcels.asObservable().map { .setParcelList($0) },
                stateCheckedUserParcels.map { .synchronizeParcel($0) }
                    .catch { _ in .just(.setAlertMessage("인터넷을 확인해주세요.")) }
            ])

        case .tapPlusButton:
            return .just(.showRegisterParcelAlert)

        case .registerParcel(let deliveryCompanyId, let trackingNumber, let name):
            return checkParcelStateUseCase.excute(
                deliveryCompanyId: deliveryCompanyId,
                trackingNumber: trackingNumber
            ).asObservable().map {
                .appendParcelList(Parcel(
                    deliveryCompanyId: deliveryCompanyId,
                    trackingNumber: trackingNumber,
                    name: name,
                    state: $0
                ))
            }.catch { _ in .just(.setAlertMessage("없는 운송장 정보입니다.")) }

        case .parcelIsPicked(let parcel):
            steps.accept(AppStep.parcelIsPicked(parcel: parcel))
            return .empty()

        case .deleteParcel(let parcel):
            deleteParcelUseCase.execute(userParcel: parcel)
            return .empty()
        }

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
        case .setParcelList(let parcels):
            newState.parcelList = parcels

        case .setDeliveryCompanyList(let deliveryCompanies):
            newState.deliveryCompanyList = deliveryCompanies

        case .appendParcelList(let parcel):
            newState.parcelList.append(parcel)

        case .showRegisterParcelAlert:
            newState.showAlert = .registerParcel

        case .synchronizeParcel(let parcel):
            let parcelIndex = newState.parcelList.firstIndex {
                $0.deliveryCompanyId == parcel.deliveryCompanyId &&
                $0.trackingNumber == parcel.trackingNumber
            }!
            newState.parcelList[parcelIndex] = parcel

        case .setAlertMessage(let message):
            newState.showAlert = .notification(message: message)
        }
        return newState
    }
}
