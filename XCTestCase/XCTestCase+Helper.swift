//
//  XCTestCase+Helper.swift
//  NetworkClient
//
//  Created by Joao Matheus on 05/10/23.
//

import XCTest
@testable import RickMortyDomain

extension XCTestCase {

    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "The instance it should be deallocated, possible memory leak", file: file, line: line)
        }
    }

    func makeCharacter() -> Character {
        Character(
            id: .zero,
            name: "name",
            status: "status",
            species: "species",
            gender: "gender",
            origin: Origin(name: "name",
                           url: "url"),
            location: Location(name: "name",
                               url: "url"),
            image: "image",
            episode: [],
            url: "url",
            created: "url"
        )
    }

}
