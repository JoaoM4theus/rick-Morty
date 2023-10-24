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

    func test_initializer_remoteCharacterLoader_and_validate_urlRequest() {
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

    func test_load_and_returneed_success_with_empty_list() {
        let (sut, spy, _) = makeSUT()

        assert(sut, completion: .success([])) {
            spy.completionWithSuccess(data: emptyData())
        }

    }
    
    func test_load_and_returned_success_with_character_list() throws {
        let (sut, spy, _) = makeSUT()
        let (model, json) = makeCharacter()
        let (model2, json2) = makeCharacter()

        assert(sut, completion: .success([model, model2])) {
            let jsonItems = ["results": [json, json2]]
            let data = try! JSONSerialization.data(withJSONObject: jsonItems)
            spy.completionWithSuccess(data: data)
        }
    }
    
    func test_load_and_returned_error_for_invalid_status_code() throws {
        let (sut, spy, _) = makeSUT()

        assert(sut, completion: .failure(.invalidData)) {
            let (_, json) = makeCharacter()
            let (_, json2) = makeCharacter()
            let jsonItems = ["results": [json, json2]]
            let data = try! JSONSerialization.data(withJSONObject: jsonItems)
            spy.completionWithSuccess(data: data, statusCode: 201)
        }
    }
    
    func test_load_not_returned_after_sut_deallocated() {
        let anyUrl = URL(string: "https://rickandmortyapi.com/")!
        let spy = NetworkClientSpy()
        var sut: RemoteCharacterLoader? = RemoteCharacterLoader(networkClient: spy, fromUrl: anyUrl)
        
        var returnedResult: ResultType?
        sut?.load(completion: { result in
            returnedResult = result
        })
        
        sut = nil
        spy.completionWithSuccess()
        XCTAssertNil(returnedResult)
    }
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (RemoteCharacterLoader, NetworkClientSpy, URL) {
        let spy = NetworkClientSpy()
        let anyUrl = URL(string: "https://rickandmortyapi.com/")!
        let sut = RemoteCharacterLoader(networkClient: spy, fromUrl: anyUrl)
        trackForMemoryLeaks(spy, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, spy, anyUrl)
    }
    
    private func assert(
        _ sut: RemoteCharacterLoader,
        completion result: ResultType,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
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

    private func emptyData() -> Data {
        return Data("{ \"results\": [] }".utf8)
    }

    private func makeCharacter(
        id: UUID = UUID(),
        name: String = "Rick Sanchez",
        status: String = "Alive",
        species: String = "Human",
        gender: String = "Male",
        origin: Origin = Origin(name: "Earth (C-137)",
                                url: "https://rickandmortyapi.com/api/location/1"),
        location: Location = Location(name: "Citadel of Ricks",
                                      url: "https://rickandmortyapi.com/api/location/3"),
        image: String = "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
        episodes: [String] = [
            "https://rickandmortyapi.com/api/episode/1",
            "https://rickandmortyapi.com/api/episode/2",
            "https://rickandmortyapi.com/api/episode/3"
        ],
        url: String = "https://rickandmortyapi.com/api/character/1",
        created: String = "2017-11-04T18:48:46.250Z"
    ) -> (model: Character, json: [String: Any]) {
        let model = Character(
            id: id,
            name: name,
            status: status,
            species: species,
            gender: gender,
            origin: origin,
            location: location,
            image: image,
            episodes: episodes,
            url: url,
            created: created
        )
        let origin: [String: Any] = [
            "name": model.origin.name,
            "url": model.origin.url
        ]
        let location: [String: Any] = [
            "name": model.location.name,
            "url": model.location.url
        ]
        let itemJson: [String: Any] = [
            "id": model.id.uuidString,
            "name": model.name,
            "status": model.status,
            "species": model.species,
            "gender": model.gender,
            "origin": origin,
            "location": location,
            "image": model.image,
            "episodes": model.episodes,
            "url": model.url,
            "created": model.created
            
        ]
        return (model, itemJson)
    }
}

final class NetworkClientSpy: NetworkClient {

    var urlRequest = [URL]()
    private var completionHandler: ((NetworkResult) -> Void)?
    
    func request(from url: URL,
                 completion: @escaping (NetworkResult) -> Void) {
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
