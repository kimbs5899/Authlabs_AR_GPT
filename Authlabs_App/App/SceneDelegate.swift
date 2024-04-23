//
//  SceneDelegate.swift
//  Authlabs_App
//
//  Created by Matthew on 4/17/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private let viewModel = ChatBotViewModel(chatRepository: ChatRepository(provider: NetworkProvider()))
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard
            let windowScene = (scene as? UIWindowScene)
        else {
            return
        }
        
        let mainViewController = AuthlabsMainViewController()
        mainViewController.delegate = self
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

extension SceneDelegate: ChangeViewDelegate {
    func moveView() {
        window?.rootViewController = AuthlabsARViewController(viewModel: viewModel)
        window?.makeKeyAndVisible()
    }
}

protocol ChangeViewDelegate: AnyObject {
    func moveView()
}
