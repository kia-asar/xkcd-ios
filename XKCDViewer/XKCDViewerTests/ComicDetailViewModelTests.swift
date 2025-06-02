//
//  ComicDetailViewModelTests.swift
//  XKCDViewer
//
//  Created by Kiarash Asar on 6/2/25.
//

import XCTest
@testable import XKCDViewer

@MainActor
final class ComicDetailViewModelTests: XCTestCase {
    
    var sut: ComicDetailViewModel!
    var mockService: MockXKCDService!
    
    override func setUp() {
        super.setUp()
        mockService = MockXKCDService()
        sut = ComicDetailViewModel(xkcdService: mockService)
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }
    
    func testFetchComic_Success_UpdatesComicProperty() async {
        // Given
        let expectedComic = createMockComic()
        mockService.mockComic = expectedComic
        
        // When
        await sut.fetchComic(number: 50)
        
        // Then
        XCTAssertEqual(sut.comic?.title, expectedComic.title)
        XCTAssertEqual(sut.comic?.date, expectedComic.date)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }
    
    func testFetchComic_Failure_UpdatesErrorMessage() async {
        // Given
        mockService.shouldThrowError = true
        mockService.errorToThrow = XKCDError.invalidComicNumber
        
        // When
        await sut.fetchComic(number: -1)
        
        // Then
        XCTAssertNil(sut.comic)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertEqual(sut.errorMessage, XKCDError.invalidComicNumber.localizedDescription)
    }
    
    // MARK: - Helper Methods
    
    private func createMockComic() -> Comic {
        return Comic(
            id: 50,
            title: "Penny Arcade",
            img: "https://imgs.xkcd.com/comics/penny_arcade.jpg",
            alt: "Of course, Penny Arcade has already mocked themselves for this. They don't care.",
            month: "1",
            day: "17",
            year: "2006",
            safeTitle: "Penny Arcade",
            transcript: "Test transcript",
            news: "",
            link: ""
        )
    }
}

// MARK: - Mock XKCDService

class MockXKCDService: XKCDServicing {
    var mockComic: Comic?
    var shouldThrowError = false
    var errorToThrow: Error = XKCDError.invalidComicNumber
    
    func fetchComic(number: Int) async throws -> Comic {
        if shouldThrowError {
            throw errorToThrow
        }
        
        guard let comic = mockComic else {
            throw XKCDError.noData
        }
        
        return comic
    }
}
