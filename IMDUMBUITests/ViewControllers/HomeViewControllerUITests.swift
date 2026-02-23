//
//  HomeViewControllerUITests.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import XCTest

final class HomeViewControllerUITests: XCTestCase {
    
    @MainActor
    func testHomeScreenShowsCategoriesCollectionView() throws {
        let app = XCUIApplication()
        app.launch()
        
        let navBar = app.navigationBars["IMDUMB"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 10))
        
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(collectionView.waitForExistence(timeout: 10))
    }

    @MainActor
    func testHomeScreenHidesBackButton() throws {
        let app = XCUIApplication()
        app.launch()
        
        let navBar = app.navigationBars["IMDUMB"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 10))
        
        let backButton = navBar.buttons["Back"]
        XCTAssertFalse(backButton.exists)
    }

    @MainActor
    func testHomeScreenDisplaysMovieCells() throws {
        let app = XCUIApplication()
        app.launch()
        
        let navBar = app.navigationBars["IMDUMB"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 10))
        
        let tables = app.tables
        XCTAssertTrue(tables.firstMatch.waitForExistence(timeout: 10))
        
        let firstCell = tables.firstMatch.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))
    }
    
    @MainActor
    func testTappingMovieCellNavigatesToDetailScreen() throws {
        let app = XCUIApplication()
        app.launch()
        
        let navBar = app.navigationBars["IMDUMB"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 10))
        
        let firstCell = app.tables.firstMatch.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))
        firstCell.tap()
        
        let detailScrollView = app.scrollViews.firstMatch
        XCTAssertTrue(detailScrollView.waitForExistence(timeout: 10))
    }
    
    @MainActor
    func testMovieTableCellShowsRatingWithStarEmoji() throws {
        let app = XCUIApplication()
        app.launch()
        
        let navBar = app.navigationBars["IMDUMB"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 10))
        
        let starRating = app.staticTexts.containing(NSPredicate(format: "label CONTAINS '⭐'")).firstMatch
        XCTAssertTrue(starRating.waitForExistence(timeout: 10))
    }
    
    @MainActor
    func testHomeScreenTitleIsIMDUMB() throws {
        let app = XCUIApplication()
        app.launch()
        
        let navBar = app.navigationBars["IMDUMB"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 10))
        XCTAssertTrue(navBar.staticTexts["IMDUMB"].exists)
    }
}
