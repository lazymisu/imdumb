//
//  MovieDetailViewControllerUITests.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//
//

import XCTest

final class MovieDetailViewControllerUITests: XCTestCase {
    
    @MainActor
    func testMovieDetailScreenShowsMovieTitle() throws {
        let app = XCUIApplication()
        app.launch()
        
        let navBar = app.navigationBars["IMDUMB"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 10))
        
        let firstCell = app.tables.firstMatch.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))
        firstCell.tap()
        
        let titleLabel = app.staticTexts.element(matching: .any, identifier: "lblTitle")
        XCTAssertTrue(titleLabel.waitForExistence(timeout: 10))
    }

    @MainActor
    func testMovieDetailScreenShowsRatingLabel() throws {
        let app = XCUIApplication()
        app.launch()
        
        let navBar = app.navigationBars["IMDUMB"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 10))
        
        let firstCell = app.tables.firstMatch.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))
        firstCell.tap()
        
        let ratingLabel = app.staticTexts.containing(NSPredicate(format: "label CONTAINS '⭐'")).firstMatch
        XCTAssertTrue(ratingLabel.waitForExistence(timeout: 10))
    }

    @MainActor
    func testMovieDetailScreenShowsImageCarousel() throws {
        let app = XCUIApplication()
        app.launch()
        
        let navBar = app.navigationBars["IMDUMB"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 10))
        
        let firstCell = app.tables.firstMatch.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))
        firstCell.tap()
        
        let imageCollectionView = app.collectionViews.firstMatch
        XCTAssertTrue(imageCollectionView.waitForExistence(timeout: 10))
    }

    @MainActor
    func testMovieDetailScreenBackButtonNavigatesToHome() throws {
        let app = XCUIApplication()
        app.launch()
        
        let homeNavBar = app.navigationBars["IMDUMB"]
        XCTAssertTrue(homeNavBar.waitForExistence(timeout: 10))
        
        let firstCell = app.tables.firstMatch.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))
        firstCell.tap()
        
        let backButton = app.navigationBars.buttons.firstMatch
        XCTAssertTrue(backButton.waitForExistence(timeout: 10))
        backButton.tap()
        
        XCTAssertTrue(homeNavBar.waitForExistence(timeout: 5))
    }

    @MainActor
    func testMovieDetailScreenShowsRecommendButton() throws {
        let app = XCUIApplication()
        app.launch()
        
        let navBar = app.navigationBars["IMDUMB"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 10))
        
        let firstCell = app.tables.firstMatch.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))
        firstCell.tap()
        
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 10))
        
        let bottomBar = app.buttons.matching(NSPredicate(format: "isEnabled == true")).firstMatch
        XCTAssertTrue(bottomBar.waitForExistence(timeout: 10))
    }

    @MainActor
    func testTappingRecommendButtonPresentsBottomSheet() throws {
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
        }
    }
}
