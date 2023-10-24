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

public protocol CharacterLoader {
    typealias CharacterResult = Result<[Character], RickMortyResultError>
    func load(completion: @escaping (CharacterLoader.CharacterResult) -> Void)
}

