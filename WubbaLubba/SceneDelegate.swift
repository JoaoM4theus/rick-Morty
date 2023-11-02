//
//  SceneDelegate.swift
//  WubbaLubba
//
//  Created by Joao Matheus on 25/10/23.
//

import UIKit
import RickMortyUI
import RickMortyDomain
import NetworkClient

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private func remoteService() -> RemoteCharacterLoader {
        let session = URLSession(configuration: .ephemeral)
        let network = NetworkService(session: session)
        let url = URL(
            string: "https://rickandmortyapi.com/api/character"
        )!
        return RemoteCharacterLoader(
            networkClient: network,
            fromUrl: url
        )
    }

    private func remoteDownloadImageService() -> RemoteCharacterDownloadImage {
        let session = URLSession(configuration: .ephemeral)
        let network = NetworkService(session: session)
        return RemoteCharacterDownloadImage(
            network: network
        )
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = (scene as? UIWindowScene) else { return }
        
        let service = remoteService()
        let controller = CharacterListCompose.compose(service: service, downloadImage: remoteDownloadImageService())
        let navigation = UINavigationController(rootViewController: controller)
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

