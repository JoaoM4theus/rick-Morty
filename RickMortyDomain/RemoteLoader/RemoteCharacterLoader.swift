//
//  RemoteCharacterLoader.swift
//  RickMortyDomain
//
//  Created by Joao Matheus on 07/10/23.
//

import Foundation
import NetworkClient

public struct Character: Decodable, Equatable {
    
}

public final class RemoteCharacterLoader: RickMortyLoader {
    public typealias T = Result<[Character], RickMortyResultError>

    let networkClient: NetworkClient
    let fromUrl: URL

    init(networkClient: NetworkClient, fromUrl: URL) {
        self.networkClient = networkClient
        self.fromUrl = fromUrl
    }

    public func load(completion: @escaping (Result<[Character], RickMortyResultError>) -> Void) {
        networkClient.request(from: fromUrl) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure: completion(.failure(.withoutConnectivity))
            default: break
            }
        }
    }

}
