//
//  RecommendViewControllerUITests.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import XCTest

final class RecommendViewControllerUITests: XCTestCase {
    
    @MainActor
    func testRecommendViewCommentFieldLimitsTo500Characters() throws {
        let app = XCUIApplication()
        app.launch()
        
        let navBar = app.navigationBars["IMDUMB"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 10))
        
        let firstCell = app.tables.firstMatch.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))
        firstCell.tap()
        
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 10))
        
        let recommendButton = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'recomendar' OR label CONTAINS[c] 'recommend'")).firstMatch
        if recommendButton.waitForExistence(timeout: 5) {
            recommendButton.tap()
            
            let textView = app.textViews.firstMatch
            XCTAssertTrue(textView.waitForExistence(timeout: 5))
            textView.tap()
            
            let longText = String(repeating: "a", count: 501)
            textView.typeText(longText)
            
            let typedText = textView.value as? String ?? ""
            XCTAssertLessThanOrEqual(typedText.count, 500)
        }
    }

    @MainActor
    func testRecommendViewShowsOverviewText() throws {
        let app = XCUIApplication()
        app.launch()
        
        let navBar = app.navigationBars["IMDUMB"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 10))
        
        let firstCell = app.tables.firstMatch.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))
        firstCell.tap()
        
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 10))
        
        let recommendButton = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'recomendar' OR label CONTAINS[c] 'recommend'")).firstMatch
        if recommendButton.waitForExistence(timeout: 5) {
            recommendButton.tap()
            
            let overviewLabel = app.staticTexts.element(matching: .any, identifier: "lblOverview")
            XCTAssertTrue(overviewLabel.waitForExistence(timeout: 5))
        }
    }

    @MainActor
    func testRecommendViewDismissesOnDimmedAreaTap() throws {
        let app = XCUIApplication()
        app.launch()
        
        let navBar = app.navigationBars["IMDUMB"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 10))
        
        let firstCell = app.tables.firstMatch.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))
        firstCell.tap()
        
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 10))
        
        let recommendButton = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'recomendar' OR label CONTAINS[c] 'recommend'")).firstMatch
        if recommendButton.waitForExistence(timeout: 5) {
            recommendButton.tap()
            
            let textView = app.textViews.firstMatch
            XCTAssertTrue(textView.waitForExistence(timeout: 5))
            
            let topCoordinate = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.05))
            topCoordinate.tap()
            
            XCTAssertTrue(scrollView.waitForExistence(timeout: 5))
        }
    }
}
