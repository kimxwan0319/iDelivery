import UIKit
import RxFlow
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator = FlowCoordinator()
    var disposeBag: DisposeBag = DisposeBag()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScence = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScence)
        window?.windowScene = windowScence

        let appFlow = AppFlow(window: window!)
        self.coordinator.coordinate(flow: appFlow, with: AppStepper())
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        print(propertiesToParcelData(url: url))
    }

    private func propertiesToParcelData(url: URL) -> Parcel {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let items = components?.queryItems ?? []
        return Parcel(
            deliveryCompany: DeliveryCompany(
                companyId: items[0].value!,
                companyName: items[1].value!
            ),
            trackingNumber: items[2].value!,
            name: items[3].value!,
            state: ParcelState(rawValue: items[4].value!)!
        )
    }

}
