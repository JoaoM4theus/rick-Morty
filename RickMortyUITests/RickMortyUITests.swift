//
//  RickMortyUITests.swift
//  RickMortyUITests
//
//  Created by Joao Matheus on 13/10/23.
//

import XCTest
import RickMortyDomain
@testable import RickMortyUI

final class RickMortyUITests: XCTestCase {

    func test_init_does_not_load() {
        let sut = CharacterListViewController()
        let service = CharacterLoaderSpy()

        XCTAssertEqual(service.loadCount, 0)
    }

}

final class CharacterLoaderSpy: RickMortyLoader {

    typealias T = Result<[Character], RickMortyResultError>
    private(set) var loadCount: Int = .zero
    
    func load(completion: @escaping (Result<[Character], RickMortyResultError>) -> Void) {
        loadCount += 1
    }

}
