//
//  NetworkClient.swift
//  NetworkClient
//
//  Created by Joao Matheus on 05/10/23.
//

import Foundation

public protocol NetworkClient {
    typealias NetworkResult = Result<(Data, HTTPURLResponse), Error>
    func request(from url: URL, completion: @escaping (NetworkResult) -> Void)
}

final class NetworkService: NetworkClient {

    func request(from url: URL, completion: @escaping (NetworkResult) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
        }.resume()
    }

}
