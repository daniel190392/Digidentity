//
//  SceneDelegate.swift
//  Digidentity
//
//  Created by Daniel Salhuana on 22/11/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        initializeGlobalToken()

        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)

        let rootViewController = CatalogBuilder().build()
        let navigationController = UINavigationController(rootViewController: rootViewController)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}

private extension SceneDelegate {
    func initializeGlobalToken() {
        let keyToken = "Token"
        if let globalToken = SecureStorage.shared.get(keyToken) {
            APIRequestBuilder.shared.setGlobalToken(globalToken)
            return
        }

        guard let token = Bundle.main.object(forInfoDictionaryKey: "TOKEN") as? String else {
            print("⚠️ Can't loaded token from Info.plist")
            return
        }

        SecureStorage.shared.save(token, for: keyToken)
        APIRequestBuilder.shared.setGlobalToken(token)
    }
}
