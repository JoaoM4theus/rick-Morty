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

    func makeSUT(file: StaticString = #filePath,
                 line: UInt = #line) -> (sut: NetworkClient, session: URLSessionSpy) {
        let session = URLSessionSpy()
        let sut = NetworkService(session: session)
        trackForMemoryLeaks(session)
        trackForMemoryLeaks(sut)
        return (sut, session)
    }
}
