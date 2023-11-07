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
    
    func test_launch_dont_should_be_show_remote_data_with_client_without_connectivity() {
        let app = XCUIApplication()
        app.launchArguments = ["-connectivity", "offline"]
        app.launch()
        
        XCTAssertEqual(app.cells.count, 0)
    }

}
