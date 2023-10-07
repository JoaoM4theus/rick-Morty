//
//  RickMortyDomainTests.swift
//  RickMortyDomainTests
//
//  Created by Joao Matheus on 07/10/23.
//

import XCTest
import NetworkClient
@testable import RickMortyDomain

final class CharacterDomainTests: XCTestCase {
    typealias resultType = Result<[Character], RickMortyResultError>

    func test_initializer_remoteRestaurantLoader_and_validate_urlRequest() {
        let (sut, spy, anyUrl) = makeSUT()
        
        sut.load { _ in }
        
        XCTAssertEqual(spy.urlRequest, [anyUrl])
    }

    func test_load_twice() {
        let (sut, spy, anyUrl) = makeSUT()
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(spy.urlRequest, [anyUrl, anyUrl])
    }

    func test_load_returned_error_for_connectivity() {
        let (sut, spy, _) = makeSUT()
        let result: resultType = .failure(.withoutConnectivity)
        
        let exp = expectation(description: "waiting")
        var returnedResult: resultType?
        sut.load { result in
            returnedResult = result
            exp.fulfill()
        }
        
        spy.completionWithError()
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(returnedResult, result)
    }

    private func makeSUT() -> (RemoteCharacterLoader, NetworkClientSpy, URL) {
        let spy = NetworkClientSpy()
        let anyUrl = URL(string: "https://rickandmortyapi.com/")!
        let sut = RemoteCharacterLoader(networkClient: spy, fromUrl: anyUrl)
        
        return (sut, spy, anyUrl)
    }
}

final class NetworkClientSpy: NetworkClient {

    var urlRequest = [URL]()
    private var completionHandler: ((NetworkResult) -> Void)?
    
    func request(from url: URL, completion: @escaping (NetworkResult) -> Void) {
        urlRequest.append(url)
        completionHandler = completion
    }

    func completionWithError() {
        completionHandler?(.failure(anyError()))
    }
    
    private func anyError() -> Error {
        return NSError(domain: "anyError", code: -1)
    }
}
