//
//  RemoteCharacterDownloadImage.swift
//  RickMortyDomain
//
//  Created by Joao Matheus on 31/10/23.
//

import NetworkClient

final class RemoteCharacterDownloadImage: CharacterDownloadImage {
    
    let network: NetworkClient
    
    init(network: NetworkClient) {
        self.network = network
    }
    
    func downloadImage(fromUrl: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        network.downloadImage(from: fromUrl, completion: completion)
    }

}
