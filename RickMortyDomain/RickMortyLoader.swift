//
//  RickMortyLoader.swift
//  RickMortyDomain
//
//  Created by Joao Matheus on 07/10/23.
//

import Foundation

public enum RickMortyResultError: Swift.Error {
    case withoutConnectivity
    case invalidData
}

public protocol RickMortyLoader {
    associatedtype T
    func load(completion: @escaping (T) -> Void)
}
