//
//  SceneDelegate.swift
//  Authlabs_App
//
//  Created by Matthew on 4/17/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UINavigationControllerDelegate {
    var window: UIWindow?
    private let viewModel = ChatBotViewModel(chatRepository: ChatRepository(provider: NetworkProvider()))
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard
            let windowScene = (scene as? UIWindowScene)
        else {
            return
        }
        
        let rootViewController = AuthlabsMainViewController()
        rootViewController.delegate = self
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

extension SceneDelegate: ChangeViewDelegate {
    func moveMainView() {
        let rootViewController =  AuthlabsMainViewController()
        rootViewController.delegate = self
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
    
    func moveAddAssetsView() {
        let rootViewController = AuthlabsAddAssetViewController()
        rootViewController.delegate = self
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
    
    func moveARView() {
        let rootViewController = AuthlabsARViewController(viewModel: viewModel)
        rootViewController.delegate = self
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
}

protocol ChangeViewDelegate: AnyObject {
    func moveARView()
    func moveAddAssetsView()
    func moveMainView()
}
