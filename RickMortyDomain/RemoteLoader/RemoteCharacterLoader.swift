//
//  RemoteCharacterLoader.swift
//  RickMortyDomain
//
//  Created by Joao Matheus on 07/10/23.
//

import NetworkClient

public struct CharacterRoot: Codable {
    let results: [Character]
}

public final class RemoteCharacterLoader: CharacterLoader {

    let networkClient: NetworkClient
    let fromUrl: URL
    let okResponse: Int = 200

    public init(networkClient: NetworkClient, fromUrl: URL) {
        self.networkClient = networkClient
        self.fromUrl = fromUrl
    }

    private func successfullyValidation(_ data: Data, response: HTTPURLResponse) -> CharacterLoader.CharacterResult {
        guard let json = try? JSONDecoder().decode(CharacterRoot.self, from: data),
              response.statusCode == okResponse else {
            return .failure(.invalidData)
        }
        return .success(json.results)
    }
    
    public func load(completion: @escaping (CharacterLoader.CharacterResult) -> Void) {
        networkClient.request(from: fromUrl) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success((data, response)):
                completion(self.successfullyValidation(data, response: response))
            case .failure:
                completion(.failure(.withoutConnectivity))
            }
        }
    }

}
