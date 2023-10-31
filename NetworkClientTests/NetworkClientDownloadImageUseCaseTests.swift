//
//  NetworkClientDownloadImageUseCaseTests.swift
//  NetworkClientTests
//
//  Created by Joao Matheus on 30/10/23.
//

import XCTest
import NetworkClient

final class NetworkClientDownloadImageUseCaseTests: XCTestCase {

    func test_downloadImage_resume_dataTask_with_url() {
        let (sut, session) = makeSUT()
        let url = URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")!
        let task = URLSessionDataTaskSpy()

        session.stub(url: url, task: task)
        sut.downloadImage(from: url) { _ in }

        XCTAssertEqual(task.resumeCount, 1)
    }

    func test_downloadImage_and_completion_with_error_for_invalidCases() {
        let anyError = NSError(domain: "Any error", code: -1)
        let data = Data()

        XCTAssertNotNil(resultErrorForInvalidCases(data: nil, error: nil))
        XCTAssertNotNil(resultErrorForInvalidCases(data: nil, error: anyError))
        XCTAssertNotNil(resultErrorForInvalidCases(data: data, error: anyError))

        let result = resultErrorForInvalidCases(data: nil, error: anyError)
        XCTAssertEqual(result as? NSError, anyError)
    }

    func makeSUT(file: StaticString = #filePath,
                 line: UInt = #line) -> (sut: NetworkClient,
                                         session: URLSessionSpy) {
        let session = URLSessionSpy()
        let sut = NetworkService(session: session)
        trackForMemoryLeaks(session)
        trackForMemoryLeaks(sut)
        return (sut, session)
    }

    private func resultErrorForInvalidCases(
        data: Data?,
        error: Error?,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Error? {

        let result = assert(data: data, error: error)

        switch result {
        case let .failure(error):
            return error
        default:
            XCTFail("expected failure but returned \(String(describing: result))", file: file, line: line)
        }
        return nil
    }

    private func assert(
        data: Data?,
        error: Error?,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (Result<Data, Error>)? {
        let (sut, session) = makeSUT()
        let url = URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")!
        let task = URLSessionDataTaskSpy()

        let exp = expectation(description: "waiting")
        var returnedResult: (Result<Data, Error>)?

        session.stub(url: url, task: task, error: error, data: data)
        sut.downloadImage(from: url) { result in
            returnedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return returnedResult
    }
}
