//
//  AppDI.swift
//  iDelivery
//
//  Created by 김수완 on 2021/10/01.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import Swinject

extension Container {
    func registerDependencies() {
        registerRepositories()
        registerUseCases()
        registerReactors()
        registerNodeControllers()
    }

    fileprivate func registerRepositories() {
        self.register(UserParcelsRepository.self) { _ in DefaultUserParcelsRepository() }
        self.register(DeliveryCompaniesRepository.self) { _ in DefaultDeliveryCompaniesRepository() }
    }

    fileprivate func registerUseCases() {
        self.register(FetchParcelListUseCase.self) { _ in FetchParcelListUseCase() }
        self.register(SaveParcelUseCase.self) { _ in SaveParcelUseCase() }
        self.register(DeleteParcelUseCase.self) { _ in DeleteParcelUseCase() }
        self.register(FetchParcelListUseCase.self) { _ in FetchParcelListUseCase() }
    }

    fileprivate func registerReactors() {
    }

    fileprivate func registerNodeControllers() {
        self.register(ParcelListNodeController.self) { _ in ParcelListNodeController() }
        self.register(ParcelDetailNodeController.self) { _ in ParcelDetailNodeController() }
    }
}
