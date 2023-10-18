//
//  RemoteCharacterLoader.swift
//  RickMortyDomain
//
//  Created by Joao Matheus on 07/10/23.
//

import Foundation
import NetworkClient

public struct Character: Decodable, Equatable {
    public let id: UUID
    public let name: String
    public let status: String
    public let species: String
    public let gender: String
    public let origin: Origin
    public let location: Location
    public let image: String
    public let episodes: [String]
    public let url: String
    public let created: String
}

public struct Origin: Decodable, Equatable {
    let name: String
    let url: String
}

public struct Location: Decodable, Equatable {
    public let name: String
    public let url: String
}


public struct CharacterRoot: Decodable {
    let results: [Character]
}

public final class RemoteCharacterLoader: RickMortyLoader {
    public typealias T = Result<[Character], RickMortyResultError>

    let networkClient: NetworkClient
    let fromUrl: URL
    let okResponse: Int = 200

    init(networkClient: NetworkClient, fromUrl: URL) {
        self.networkClient = networkClient
        self.fromUrl = fromUrl
    }

    private func successfullyValidation(_ data: Data, response: HTTPURLResponse) -> T {
        guard let json = try? JSONDecoder().decode(CharacterRoot.self, from: data),
              response.statusCode == okResponse else {
            return .failure(.invalidData)
        }
        return .success(json.results)
    }
    
    public func load(completion: @escaping (Result<[Character], RickMortyResultError>) -> Void) {
        networkClient.request(from: fromUrl) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success((data, response)):
                completion(successfullyValidation(data, response: response))
            case .failure: completion(.failure(.withoutConnectivity))
            }
        }
    }

}
