//
//  XKCDServiceTests.swift
//  XKCDViewer
//
//  Created by Kiarash Asar on 6/2/25.
//

import XCTest
@testable import XKCDViewer

final class XKCDServiceTests: XCTestCase {
    
    var sut: XKCDService!
    var mockURLSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        sut = XKCDService(urlSession: mockURLSession)
    }
    
    override func tearDown() {
        sut = nil
        mockURLSession = nil
        super.tearDown()
    }
    
    func testFetchComic_ValidNumber_ReturnsComic() async throws {
        // Given
        let expectedComic = createMockComic()
        let jsonData = try JSONEncoder().encode(expectedComic)
        mockURLSession.data = jsonData
        mockURLSession.response = HTTPURLResponse(
            url: URL(string: "https://xkcd.com/50/info.0.json")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When
        let comic = try await sut.fetchComic(number: 50)
        
        // Then
        XCTAssertEqual(comic.id, expectedComic.id)
        XCTAssertEqual(comic.title, expectedComic.title)
        XCTAssertEqual(comic.img, expectedComic.img)
    }
    
    func testFetchComic_InvalidNumber_ThrowsError() async {
        // Given
        let invalidNumber = -1
        
        // When & Then
        do {
            _ = try await sut.fetchComic(number: invalidNumber)
            XCTFail("Expected error to be thrown")
        } catch let error as XKCDError {
            XCTAssertEqual(error, .invalidComicNumber)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    func testFetchComic_404Response_ThrowsInvalidComicNumberError() async {
        // Given
        mockURLSession.response = HTTPURLResponse(
            url: URL(string: "https://xkcd.com/999999/info.0.json")!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )
        mockURLSession.data = Data()
        
        // When & Then
        do {
            _ = try await sut.fetchComic(number: 999999)
            XCTFail("Expected error to be thrown")
        } catch let error as XKCDError {
            XCTAssertEqual(error, .invalidComicNumber)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    func testFetchComic_InvalidJSON_ThrowsDecodingError() async {
        // Given
        mockURLSession.data = "invalid json".data(using: .utf8)!
        mockURLSession.response = HTTPURLResponse(
            url: URL(string: "https://xkcd.com/50/info.0.json")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When & Then
        do {
            _ = try await sut.fetchComic(number: 50)
            XCTFail("Expected error to be thrown")
        } catch let error as XKCDError {
            XCTAssertEqual(error, .decodingError)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
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

// MARK: - Mock URLSession

final class MockURLSession: URLSessioning, @unchecked Sendable {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        
        return (data ?? Data(), response ?? URLResponse())
    }
}
