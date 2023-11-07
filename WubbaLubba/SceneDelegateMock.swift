//
//  SceneDelegateMock.swift
//  WubbaLubba
//
//  Created by Joao Matheus on 06/11/23.
//

#if DEBUG
import UIKit
import RickMortyDomain

class SceneDelegateMock: SceneDelegate {
    override func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        super.scene(scene, willConnectTo: session, options: connectionOptions)
    }
    
    override func makeRemoteLoader() -> CharacterLoader {
        if UserDefaults.standard.string(forKey: "connectivity") == "offline" {
            return CharacterLoaderMock()
        }
        return super.makeRemoteLoader()
    }
}

private final class CharacterLoaderMock: CharacterLoader {
    func load(completion: @escaping (Result<[Character], RickMortyResultError>) -> Void) {
        completion(.failure(.withoutConnectivity))
    }
}

#endif
