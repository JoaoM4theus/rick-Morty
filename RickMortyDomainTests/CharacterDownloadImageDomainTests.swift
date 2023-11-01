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
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (RemoteCharacterDownloadImage, NetworkClientSpy, URL) {
        let spy = NetworkClientSpy()
        let anyUrl = URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")!
        let sut = RemoteCharacterDownloadImage(network: spy)
        trackForMemoryLeaks(spy, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, spy, anyUrl)
    }

}
