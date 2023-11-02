//
//  RemoteCharacterLoader.swift
//  RickMortyDomain
//
//  Created by Joao Matheus on 07/10/23.
//

import NetworkClient

public struct Character: Codable, Equatable {
    public let id: Int
    public let name: String
    public let status: String
    public let species: String
    public let gender: String
    public let origin: Origin
    public let location: Location
    public let image: String
    public let episode: [String]
    public let url: String
    public let created: String
    public var imageData: Data?
    
    mutating func setImageData(data: Data) {
        imageData = data
    }
}

public struct Origin: Codable, Equatable {
    let name: String
    let url: String
}

public struct Location: Codable, Equatable {
    public let name: String
    public let url: String
}

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
                completion(successfullyValidation(data, response: response))
            case .failure: completion(.failure(.withoutConnectivity))
            }
        }
    }

}
