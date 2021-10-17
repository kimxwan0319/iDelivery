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

    private var userParcelList = [Parcel]()
    public var deliveryCompanies = [DeliveryCompany]()

    // MARK: Action
    enum Action {
        case viewDidLoad
        case tapPlusButton
        case registerParcel(deliveryCompanyIndex: Int, trackingNumber: String, name: String)
        case parcelIsPicked(parcelIndex: Int)
        case deleteParcel(parcelIndex: Int)
    }

    // MARK: Mutation
    enum Mutation {
        case setParcelList([Parcel])
        case setDeliveryCompanyList([DeliveryCompany])
        case synchronizeParcel(Parcel)
        case appendParcelList(Parcel)
        case deleteParcelItem(Int)
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
            return .concat([
                fetchLocalUserParcels().asObservable().map { .setParcelList($0) },
                fetchDeliveryCompanies().asObservable().map { .setDeliveryCompanyList($0) },
                synchronizeParcelsState().map { .synchronizeParcel($0) }
            ])

        case .tapPlusButton:
            return .just(.showRegisterParcelAlert)

        case .registerParcel(let deliveryCompanyIndex, let trackingNumber, let name):
            return checkParcelStateUseCase.excute(
                deliveryCompanyId: deliveryCompanies[deliveryCompanyIndex].companyId,
                trackingNumber: trackingNumber
            ).asObservable()
                .map {
                    Parcel(
                        deliveryCompany: self.deliveryCompanies[deliveryCompanyIndex],
                        trackingNumber: trackingNumber,
                        name: name,
                        state: $0
                    )
                }
                .do(onNext: {
                    self.saveParcelUseCase.execute(userParcel: $0)
                })
                .map { .appendParcelList($0) }
                .catch { _ in .just(.setAlertMessage("없는 운송장 정보입니다.")) }

        case .deleteParcel(let parcelIndex):
            deleteParcelUseCase.execute(userParcel: self.userParcelList[parcelIndex])
            userParcelList.remove(at: parcelIndex)
            return Observable.just(.deleteParcelItem(parcelIndex))

        case .parcelIsPicked(let parcelIndex):
            steps.accept(AppStep.parcelIsPicked(parcel: self.userParcelList[parcelIndex]))
            return .empty()
        }

    }

    private func fetchLocalUserParcels() -> Single<[Parcel]> {
        return fetchParcelListUseCase.execute()
            .do(onSuccess: {
                self.userParcelList = $0
            })
    }
    private func fetchDeliveryCompanies() -> Single<[DeliveryCompany]> {
        return fetchDeliveryCompaniesUseCase.execute()
            .do(onSuccess: {
                self.deliveryCompanies = $0
            })
    }
    private func synchronizeParcelsState() -> Observable<Parcel> {
        return fetchLocalUserParcels()
            .asObservable()
            .flatMap { parcels -> Observable<Parcel> in
                let singles = parcels.map { self.synchronizeParcelUseCase.excute(parcel: $0) }
                return Observable.from(singles).merge()
            }
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
            newState.parcelList.insert(parcel, at: 0)

        case .deleteParcelItem(let index):
            newState.parcelList.remove(at: index)

        case .showRegisterParcelAlert:
            newState.showAlert = .registerParcel

        case .synchronizeParcel(let parcel):
            let parcelIndex = newState.parcelList.firstIndex {
                $0.deliveryCompany == parcel.deliveryCompany &&
                $0.trackingNumber == parcel.trackingNumber
            }!
            newState.parcelList[parcelIndex] = parcel

        case .setAlertMessage(let message):
            newState.showAlert = .notification(message: message)
        }
        return newState
    }
}
