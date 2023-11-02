//
//  CharacterItemUITests.swift
//  RickMortyUITests
//
//  Created by Joao Matheus on 02/11/23.
//

import XCTest
import RickMortyDomain
@testable import RickMortyUI

final class CharacterItemUITests: XCTestCase {
    
    func test_init_loadImage() {
        let (_, service, _) = makeSUT()
        
        XCTAssertEqual(service.methodsCalled, [.load])
    }

    func test_twice_loadImage() {
        let (sut, service, cell) = makeSUT()
        
        sut.renderCell(cell)
        
        XCTAssertEqual(service.methodsCalled, [.load, .load])
    }

    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: CharacterItemCellController, service: CharacterDownloadImageSpy, cell: CharacterItemCell) {
        let item = makeCharacter()
        let service = CharacterLoaderSpy()
        let serviceImage = CharacterDownloadImageSpy()
        let viewController = CharacterListCompose.compose(service: service, downloadImage: serviceImage) as! CharacterListViewController
        viewController.loadViewIfNeeded()
        service.completionSuccess(.success([item]))
        
        let cell = viewController.tableView(viewController.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! CharacterItemCell
        let sut = CharacterItemCellController(model: item, service: serviceImage)

        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(service, file: file, line: line)
        trackForMemoryLeaks(serviceImage, file: file, line: line)
        trackForMemoryLeaks(viewController, file: file, line: line)
        trackForMemoryLeaks(cell, file: file, line: line)

        return (sut, serviceImage, cell)
    }

}

final class CharacterDownloadImageSpy: CharacterDownloadImage {

    enum Methods {
        case load
    }

    private(set) var methodsCalled: [Methods] = []
    
    func downloadImage(fromUrl: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        methodsCalled.append(.load)
    }

//    private var completionHandler: ((Result<[Character], RickMortyResultError>) -> Void)?
//    func load(completion: @escaping (Result<[Character], RickMortyResultError>) -> Void) {
//        methodsCalled.append(.load)
//        completionHandler = completion
//    }
//
//    func completionSuccess(_ result: Result<[Character], RickMortyResultError>) {
//        completionHandler?(result)
//    }
}
