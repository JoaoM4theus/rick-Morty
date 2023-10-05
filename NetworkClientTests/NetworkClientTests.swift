//
//  NetworkClientTests.swift
//  NetworkClientTests
//
//  Created by Joao Matheus on 05/10/23.
//

import XCTest
@testable import NetworkClient

final class NetworkClientTests: XCTestCase {

    func test_loadRequest_resume_dataTask_with_url() {
        let (sut, spy) = makeSUT()
        let url = URL(string: "https://rickandmortyapi.com/")!
        let task = URLSessionDataTaskSpy()

        spy.stub(url: url, task: task)
        sut.request(from: url) { _ in }
        
        XCTAssertEqual(task.resumeCount, 1)
    }
    
    private func makeSUT(file: StaticString = #filePath,
                         line: UInt = #line) -> (sut: NetworkClient, session: URLSessionSpy) {
        let session = URLSessionSpy()
        let sut = NetworkService(session: session)
        trackForMemoryLeaks(session)
        trackForMemoryLeaks(sut)
        return (sut, session)
    }
}

final class URLSessionSpy: URLSession {

    private(set) var stubs: [URL: Stub] = [:]
    
    struct Stub {
        let tasks: URLSessionDataTask
        let error: Error?
        let data: Data?
        let response: URLResponse?
    }

    func stub(url: URL, task: URLSessionDataTask, error: Error? = nil, data: Data? = nil, response: URLResponse? = nil) {
        stubs[url] = Stub(tasks: task, error: error, data: data, response: response)
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        guard let stub = stubs[url] else {
            return FakeURLSessionDataTask()
        }
        completionHandler(stub.data, stub.response, stub.error)
        return stub.tasks
    }

}

final class URLSessionDataTaskSpy: URLSessionDataTask {
    private(set) var resumeCount: Int = .zero

    override func resume() {
        resumeCount += 1
    }

}

final class FakeURLSessionDataTask: URLSessionDataTask {

    override func resume() { }

}
