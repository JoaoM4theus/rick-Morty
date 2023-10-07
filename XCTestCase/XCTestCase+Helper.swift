//
//  XCTestCase+Helper.swift
//  NetworkClient
//
//  Created by Joao Matheus on 05/10/23.
//

import XCTest

extension XCTestCase {

    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "The instance it should be deallocated, possible memory leak", file: file, line: line)
        }
    }

}
