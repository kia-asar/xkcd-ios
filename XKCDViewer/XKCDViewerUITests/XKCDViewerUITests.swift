//
//  XKCDViewerUITests.swift
//  XKCDViewerUITests
//
//  Created by Kiarash Asar on 6/2/25.
//

import XCTest

final class XKCDViewerUITests: XCTestCase {
    
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Essential UI Tests
    
    @MainActor
    func testHappyPath_EnterValidComicNumberAndNavigate() throws {
        // Given: App launches with input view
        let inputField = app.textFields["comic-number-input"]
        let viewButton = app.buttons["view-comic-button"]
        XCTAssertTrue(inputField.exists)
        XCTAssertTrue(viewButton.exists)
        
        // When: Enter valid comic number
        inputField.tap()
        inputField.typeText("353")
        
        // Then:
        XCTAssertTrue(viewButton.isEnabled)
        
        viewButton.tap()
        
        // Verify navigation occurred (input field should disappear)
        XCTAssertFalse(inputField.waitForExistence(timeout: 3), "Should navigate away from input view")
        
        // Wait for content to load (caption toggle indicates success)
        let captionToggle = app.buttons["comic-caption-toggle"]
        XCTAssertTrue(captionToggle.waitForExistence(timeout: 10), "Caption toggle should appear when comic loads")
    }
    
    @MainActor
    func testGracefulFailure_ComicDoesNotExist() throws {
        // Given: App launches with input view
        let inputField = app.textFields["comic-number-input"]
        let viewButton = app.buttons["view-comic-button"]
        XCTAssertTrue(inputField.exists)
        XCTAssertTrue(viewButton.exists)
        
        // When: Enter a comic number that doesn't exist (very high number)
        inputField.tap()
        inputField.typeText("999999")
        
        // Then:
        XCTAssertTrue(viewButton.isEnabled)
        
        viewButton.tap()
        
        let comicNavBar = app.navigationBars["Comic #999999"]
        XCTAssertTrue(comicNavBar.waitForExistence(timeout: 3))
        
        let retryButton = app.buttons["comic-retry-button"]
        XCTAssertTrue(retryButton.waitForExistence(timeout: 10))
        
        retryButton.tap()
        XCTAssertTrue(retryButton.waitForExistence(timeout: 10))
    }
}
