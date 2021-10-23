//
//  AppDI.swift
//  iDelivery
//
//  Created by 김수완 on 2021/10/01.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import Swinject

extension Container {
    public func registerDependencies() {
        registerRepositories()
        registerUseCases()
        registerReactors()
        registerNodeControllers()
    }

    private func registerRepositories() {
        self.register(UserParcelsRepository.self) { _ in DefaultUserParcelsRepository() }
        self.register(DeliveryCompaniesRepository.self) { _ in DefaultDeliveryCompaniesRepository() }
        self.register(ParcelInformationRepository.self) { _ in DefaultParcelInformationRepository() }
    }

    private func registerUseCases() {
        self.register(FetchDeliveryCompaniesUseCase.self) { _ in FetchDeliveryCompaniesUseCase() }
        self.register(RegisterParcelUseCase.self) { _ in RegisterParcelUseCase() }
        self.register(DeleteParcelUseCase.self) { _ in DeleteParcelUseCase() }
        self.register(FetchParcelListUseCase.self) { _ in FetchParcelListUseCase() }
        self.register(FetchParcelInformationUseCase.self) { _ in FetchParcelInformationUseCase() }
        self.register(SynchronizeParcelUseCase.self) { _ in SynchronizeParcelUseCase() }
    }

    private func registerReactors() {
        self.register(ParcelListReactor.self) { _ in ParcelListReactor() }
    }

    private func registerNodeControllers() {
        self.register(ParcelListNodeController.self) { resolver in
            let controller = ParcelListNodeController()
            controller.reactor = resolver.resolve(ParcelListReactor.self)
            return controller
        }
        self.register(ParcelDetailNodeController.self) { _ in
            let controller = ParcelDetailNodeController()
            return controller
        }
    }
}
