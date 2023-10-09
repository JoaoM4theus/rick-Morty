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
    typealias ResultType = Result<[Character], RickMortyResultError>

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
        let result: ResultType = .failure(.withoutConnectivity)
        
        assert(sut, completion: .failure(.withoutConnectivity)) {
            spy.completionWithError()
        }

    }

    func test_load_and_returned_error_for_invalidData() {
        let (sut, spy, _) = makeSUT()

        assert(sut, completion: .failure(.invalidData)) {
            spy.completionWithSuccess()
        }

    }
    
    private func makeSUT() -> (RemoteCharacterLoader, NetworkClientSpy, URL) {
        let spy = NetworkClientSpy()
        let anyUrl = URL(string: "https://rickandmortyapi.com/")!
        let sut = RemoteCharacterLoader(networkClient: spy, fromUrl: anyUrl)
        
        return (sut, spy, anyUrl)
    }
    
    private func assert(
        _ sut: RemoteCharacterLoader,
        completion result: ResultType,
        when action: () -> Void
    ) {
        let exp = expectation(description: "waiting")
        var returnedResult: ResultType?
        sut.load { result in
            returnedResult = result
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(returnedResult, result)
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
    
    func completionWithSuccess(data: Data = Data(), statusCode: Int = 200) {
        let response = HTTPURLResponse(
            url: urlRequest[0],
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        completionHandler?(.success((data, response)))
    }
    
    private func anyError() -> Error {
        return NSError(domain: "anyError", code: -1)
    }
}
