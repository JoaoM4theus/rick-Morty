//
//  RickMortyDomainTests.swift
//  RickMortyDomainTests
//
//  Created by Joao Matheus on 07/10/23.
//

import XCTest
import NetworkClient
@testable import RickMortyDomain

final class RickMortyDomainTests: XCTestCase {

    func test_initializer_remoteRestaurantLoader_and_validate_urlRequest() {
        let spy = NetworkClientSpy()
        let anyUrl = URL(string: "https://rickandmortyapi.com/")!
        let sut = RemoteRickMortyLoader(networkClient: spy, fromUrl: anyUrl)
        
        sut.load { _ in }
        
        XCTAssertEqual(spy.urlRequest, [anyUrl])
    }

}

final class NetworkClientSpy: NetworkClient {

    var urlRequest = [URL]()
    
    func request(from url: URL, completion: @escaping (NetworkResult) -> Void) {
        urlRequest.append(url)
    }

}
