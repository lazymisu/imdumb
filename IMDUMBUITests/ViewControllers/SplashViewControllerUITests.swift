//
//  SplashViewControllerUITests.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import XCTest

final class SplashViewControllerUITests: XCTestCase {
    
    @MainActor
    func testSplashScreenShowsWelcomeLabelOnLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        
        let welcomeLabel = app.staticTexts.element(matching: .any, identifier: "lblWelcome")
        XCTAssertTrue(welcomeLabel.waitForExistence(timeout: 5))
    }

    @MainActor
    func testSplashScreenNavigatesToHomeAutomatically() throws {
        let app = XCUIApplication()
        app.launch()
        
        let navBar = app.navigationBars["IMDUMB"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 10))
    }
}
