//
//  CharacterDownloadImageDomainTests.swift
//  RickMortyDomainTests
//
//  Created by Joao Matheus on 31/10/23.
//

import XCTest
import NetworkClient
@testable import RickMortyDomain

final class CharacterDownloadImageDomainTests: XCTestCase {

    func test_initializer_remoteCharacterDownloadImage_and_validate_urlImage() {
        let (sut, spy, anyUrl) = makeSUT()
        
        sut.downloadImage(fromUrl: anyUrl) { _ in }
        
        XCTAssertEqual(spy.urlRequest, [anyUrl])
    }
    
    func test_downloadImage_returned_failure_for_has_error() {
        let (sut, spy, anyUrl) = makeSUT()
        let anyError = NSError(domain: "anyError", code: -1)
        
        var returnedResult: (Result<Data, Error>)?
        let exp = expectation(description: "waiting")
        sut.downloadImage(fromUrl: anyUrl) { result in
            returnedResult = result
            exp.fulfill()
        }
        
        spy.completionDownloadImageWithError(error: anyError)
        
        wait(for: [exp], timeout: 1.0)

        switch returnedResult {
        case let .failure(error):
            XCTAssertEqual(error as NSError, anyError)
        default:
            XCTFail("expected failure but returned \(String(describing: returnedResult))")
        }
    }
    
    func test_downloadImage_returned_success_for_has_data() {
        let (sut, spy, anyUrl) = makeSUT()
        
        var returnedResult: (Result<Data, Error>)?
        let exp = expectation(description: "waiting")
        sut.downloadImage(fromUrl: anyUrl) { result in
            returnedResult = result
            exp.fulfill()
        }
        
        spy.completionDownloadImageWithSuccess(data: Data())
        
        wait(for: [exp], timeout: 1.0)

        switch returnedResult {
        case let .success(data):
            XCTAssertEqual(data, Data())
        default:
            XCTFail("expected success but returned \(String(describing: returnedResult))")
        }
    }
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (RemoteCharacterDownloadImage, NetworkClientSpy, URL) {
        let spy = NetworkClientSpy()
        let anyUrl = URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")!
        let sut = RemoteCharacterDownloadImage(network: spy)
        trackForMemoryLeaks(spy, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, spy, anyUrl)
    }

}
