//
//  AppFlow.swift
//  iDelivery
//
//  Created by 김수완 on 2021/10/02.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import RxFlow

class AppFlow: Flow {

    var window: UIWindow

    var root: Presentable {
        return self.window
    }

    init(window: UIWindow) {
        self.window = window
    }

    private let rootViewController = UINavigationController()

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        switch step {
        case .parcelListIsRequired:
            return navigateToParcelListScreen()
        default:
            return .none
        }
    }

    private func navigateToParcelListScreen() -> FlowContributors {
        let parcelListFlow = ParcelListFlow()
        Flows.use(parcelListFlow, when: .created) { [weak self] root in
            self?.window.rootViewController = root
        }
        return .one(
            flowContributor: .contribute(
                withNextPresentable: parcelListFlow,
                withNextStepper: OneStepper(withSingleStep: AppStep.parcelListIsRequired))
        )
    }
}
