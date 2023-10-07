//
//  RemoteRickMortyLoader.swift
//  RickMortyDomain
//
//  Created by Joao Matheus on 07/10/23.
//

import Foundation

public struct Character {
    
}

public final class RemoteRickMortyLoader: RickMortyLoader {

    public typealias T = Result<[Character], RickMortyResultError>
    
    public func load(completion: @escaping (Result<[Character], RickMortyResultError>) -> Void) {
        <#code#>
    }

}
