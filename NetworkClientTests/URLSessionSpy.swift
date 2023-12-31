//
//  URLSessionSpy.swift
//  NetworkClientTests
//
//  Created by Joao Matheus on 07/10/23.
//

import Foundation

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
