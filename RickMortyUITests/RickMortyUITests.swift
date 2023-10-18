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
        let (sut, service) = makeSUT()

        XCTAssertEqual(service.loadCount, 0)
        XCTAssertTrue(sut.characterCollection.isEmpty)
    }

    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: CharacterListViewController, service: CharacterLoaderSpy) {
        let service = CharacterLoaderSpy()
        let sut = CharacterListCompose.compose(service: service) as! CharacterListViewController

        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(service, file: file, line: line)

        return (sut, service)
    }
}

final class CharacterLoaderSpy: RickMortyLoader {

    typealias T = Result<[Character], RickMortyResultError>
    private(set) var loadCount: Int = .zero
    
    func load(completion: @escaping (Result<[Character], RickMortyResultError>) -> Void) {
        loadCount += 1
    }

}
