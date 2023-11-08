//
//  Character.swift
//  RickMortyDomain
//
//  Created by Joao Matheus on 07/11/23.
//

import Foundation

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
}

public struct Origin: Codable, Equatable {
    let name: String
    let url: String
}

public struct Location: Codable, Equatable {
    public let name: String
    public let url: String
}
