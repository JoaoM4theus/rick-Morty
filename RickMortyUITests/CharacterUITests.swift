//
//  CharacterUITests.swift
//  CharacterUITests
//
//  Created by Joao Matheus on 13/10/23.
//

import XCTest
import RickMortyDomain
@testable import RickMortyUI

final class CharacterUITests: XCTestCase {

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

    func test_load_returned_characterItems_data_and_characterCollection_is_empty() {
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

    func test_viewDidLoad_show_loading_indicator() {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.isShowLoadingIndicator, true)
    }
    
    func test_load_when_completion_failure_should_be_hide_loading_indicator() {
        let (sut, service) = makeSUT()
        
        sut.loadViewIfNeeded()
        service.completionSuccess(.failure(.withoutConnectivity))
        
        XCTAssertEqual(sut.isShowLoadingIndicator, false)
    }
    
    func test_load_when_completion_success_should_be_hide_loading_indicator() {
        let (sut, service) = makeSUT()
        
        sut.loadViewIfNeeded()
        service.completionSuccess(.success([makeCharacter()]))
        
        XCTAssertEqual(sut.isShowLoadingIndicator, false)
    }
    
    func test_pullToRefresh_should_be_show_loading_indicator() {
        let (sut, _) = makeSUT()
        
        sut.simulatePullToRefresh()
        
        XCTAssertEqual(sut.isShowLoadingIndicator, true)
    }
    
    func test_pullToRefresh_should_be_hide_loading_indicator_when_completion_is_failure() {
        let (sut, service) = makeSUT()
        
        sut.simulatePullToRefresh()
        service.completionSuccess(.failure(.withoutConnectivity))
        
        XCTAssertEqual(sut.isShowLoadingIndicator, false)
    }
    
    func test_pullToRefresh_should_be_hide_loading_indicator_when_completion_is_success() {
        let (sut, service) = makeSUT()
        
        sut.simulatePullToRefresh()
        service.completionSuccess(.success([makeCharacter()]))
        
        XCTAssertEqual(sut.isShowLoadingIndicator, false)
    }
    
    func test_show_loading_indicator_for_all_life_cycle_view() {
        let (sut, service) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.isShowLoadingIndicator, true)
        service.completionSuccess(.failure(.withoutConnectivity))
        XCTAssertEqual(sut.isShowLoadingIndicator, false)
        
        sut.simulatePullToRefresh()
        XCTAssertEqual(sut.isShowLoadingIndicator, true)
        service.completionSuccess(.success([makeCharacter()]))
        XCTAssertEqual(sut.isShowLoadingIndicator, false)
    }
    
    func test_render_all_character_information_in_view() {
        let (sut, service) = makeSUT()
        let item = makeCharacter()
        
        sut.loadViewIfNeeded()
        service.completionSuccess(.success([item]))
        
        XCTAssertEqual(sut.numberOfRows(), 1)
        
        let cell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? CharacterItemCell
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.name.text, item.name)
        XCTAssertEqual(cell?.status.text, "Status: \(item.status)")
        XCTAssertEqual(cell?.species.text, "Specie: \(item.species)")
        XCTAssertEqual(cell?.gender.text, "Gender: \(item.gender)")
        XCTAssertEqual(cell?.location.text, item.location.name)
    }
    
    func test_load_completion_dispatches_in_background_threads() {
        let (sut, service) = makeSUT()
        let items = [makeCharacter()]
        
        sut.loadViewIfNeeded()
        
        let exp = expectation(description: "waiting return code")
        DispatchQueue.global().async {
            service.completionSuccess(.success(items))
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
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

final class CharacterLoaderSpy: CharacterLoader {
    
    enum Methods {
        case load
    }

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
