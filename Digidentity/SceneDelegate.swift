//
//  SceneDelegate.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 22/11/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        initializeGlobalToken()

        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)

        let navigationController = UINavigationController()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        self.window = window

        appCoordinator = AppCoordinator(navigationController: navigationController)
        appCoordinator?.start()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}

private extension SceneDelegate {
    enum AppSecrets {
        static let apiToken: String = {
            guard let token = Bundle.main.object(forInfoDictionaryKey: "API_TOKEN") as? String,
                  !token.isEmpty else {
                fatalError("API Token must be set via xcconfig in Build Settings.")
            }
            return token
        }()
    }

    func initializeGlobalToken() {
        let keyToken = "Token"

        if let globalToken = SecureStorage.shared.get(keyToken) {
            APIRequestBuilder.shared.setGlobalToken(globalToken)
            return
        }

        let token = AppSecrets.apiToken

        SecureStorage.shared.save(token, for: keyToken)
        APIRequestBuilder.shared.setGlobalToken(token)
    }
}
