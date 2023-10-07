//
//  URLSessionDataTaskSpy.swift
//  NetworkClientTests
//
//  Created by Joao Matheus on 07/10/23.
//

import Foundation

final class URLSessionDataTaskSpy: URLSessionDataTask {
    private(set) var resumeCount: Int = .zero

    override func resume() {
        resumeCount += 1
    }

}

final class FakeURLSessionDataTask: URLSessionDataTask {

    override func resume() { }

}
