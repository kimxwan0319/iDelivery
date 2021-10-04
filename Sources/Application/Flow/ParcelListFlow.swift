//
//  ParcelListFlow.swift
//  iDelivery
//
//  Created by 김수완 on 2021/10/03.
//  Copyright © 2021 com.kimxwan0319. All rights reserved.
//

import RxFlow
import Then

class ParcelListFlow: Flow {

    var root: Presentable {
        return rootViewController
    }

    private let rootViewController = UINavigationController().then {
        $0.navigationBar.prefersLargeTitles = true
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        switch step {
        case .parcelListIsRequired:
            return navigateToParcelListScreen()
        case .parcelIsPicked(let parcel):
            return navigateToParcelInfoScreen(parcel: parcel)
        }
    }

    private func navigateToParcelListScreen() -> FlowContributors {
        @Inject var nodeController: ParcelListNodeController
        self.rootViewController.setViewControllers([nodeController], animated: true)
        return .one(flowContributor: .contribute(withNext: nodeController))
    }
    private func navigateToParcelInfoScreen(parcel: Parcel) -> FlowContributors {
        return .none
    }
}