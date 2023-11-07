//
//  WubbaLubbaUITests.swift
//  WubbaLubbaUITests
//
//  Created by Joao Matheus on 25/10/23.
//

import XCTest

final class WubbaLubbaUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func test_launch_should_be_show_remote_data_with_client_have_connectivity() {
        let app = XCUIApplication()
        app.launch()
        
        XCTAssertEqual(app.cells.count, 20)
        XCTAssertEqual(app.cells.firstMatch.staticTexts.count, 2)
    }
    
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
