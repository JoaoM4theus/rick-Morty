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

        XCTAssertEqual(service.methodsCalled, [])
        XCTAssertTrue(sut.characterCollection.isEmpty)
    }
    
    func test_viewDidLoad_should_be_called_service() {
        let (sut, service) = makeSUT()

        sut.loadViewIfNeeded()
        
        XCTAssertEqual(service.methodsCalled, [.load])
    }

    func test_load_returned_characterItems_data_and_characterCollection_does_not_empty() {
        let (sut, service) = makeSUT()
        
        sut.loadViewIfNeeded()
        service.completionSuccess(.success([makeCharacter()]))

        XCTAssertEqual(service.methodsCalled, [.load])
        XCTAssertEqual(sut.characterCollection.count, 1)
    }

    func test_load_returned_restaurantItems_data_and_restaurantCollection_is_empty() {
        let (sut, service) = makeSUT()
        
        sut.loadViewIfNeeded()
        service.completionSuccess(.failure(.withoutConnectivity))

        XCTAssertEqual(service.methodsCalled, [.load])
        XCTAssertEqual(sut.characterCollection.count, 0)
    }

    func test_pullToRefresh_should_be_called_load_service() {
        let (sut, service) = makeSUT()
        
        sut.simulatePullToRefresh()
        XCTAssertEqual(service.methodsCalled, [.load, .load])
        
        sut.simulatePullToRefresh()
        XCTAssertEqual(service.methodsCalled, [.load, .load, .load])
        
        sut.simulatePullToRefresh()
        XCTAssertEqual(service.methodsCalled, [.load, .load, .load, .load])
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
    
    enum Methods {
        case load
    }

    typealias T = Result<[Character], RickMortyResultError>
    private(set) var methodsCalled: [Methods] = []

    private var completionHandler: ((Result<[Character], RickMortyResultError>) -> Void)?
    func load(completion: @escaping (Result<[Character], RickMortyResultError>) -> Void) {
        methodsCalled.append(.load)
        completionHandler = completion
    }

    func completionSuccess(_ result: Result<[Character], RickMortyResultError>) {
        completionHandler?(result)
    }
}

private extension CharacterListViewController {
    
    func simulatePullToRefresh() {
        refreshControl?.simulatePullToRefresh()
    }
    
    var isShowLoadingIndicator: Bool {
        refreshControl?.isRefreshing ?? false
    }
    
    func numberOfRows() -> Int {
        tableView.numberOfRows(inSection: 0)
    }

}

extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
