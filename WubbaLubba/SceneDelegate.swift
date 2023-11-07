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
        
        let service = makeRemoteLoader()
        let controller = CharacterListCompose.compose(service: service, downloadImage: remoteDownloadImageService())
        let navigation = UINavigationController(rootViewController: controller)
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }

    func makeRemoteLoader() -> CharacterLoader {
        remoteService()
    }
}

