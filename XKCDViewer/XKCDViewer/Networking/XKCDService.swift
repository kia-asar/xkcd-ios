//
//  XKCDService.swift
//  XKCDViewer
//
//  Created by Kiarash Asar on 6/2/25.
//

import Foundation

enum XKCDError: Error, LocalizedError {
    case invalidURL
    case invalidComicNumber
    case noData
    case decodingError
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidComicNumber:
            return "Invalid comic number. Please enter a valid comic number."
        case .noData:
            return "No data received from server"
        case .decodingError:
            return "Failed to decode comic data"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

protocol XKCDServicing {
    func fetchComic(number: Int) async throws -> Comic
}

final class XKCDService: XKCDServicing {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetchComic(number: Int) async throws -> Comic {
        guard number > 0 else {
            throw XKCDError.invalidComicNumber
        }
        
        guard let url = URL(string: "https://xkcd.com/\(number)/info.0.json") else {
            throw XKCDError.invalidURL
        }
        
        do {
            let (data, response) = try await urlSession.data(from: url)
            
            // Check for HTTP errors
            if let httpResponse = response as? HTTPURLResponse {
                guard httpResponse.statusCode == 200 else {
                    if httpResponse.statusCode == 404 {
                        throw XKCDError.invalidComicNumber
                    }
                    throw XKCDError.networkError(NSError(domain: "HTTP", code: httpResponse.statusCode))
                }
            }
            
            guard !data.isEmpty else {
                throw XKCDError.noData
            }
            
            let comic = try JSONDecoder().decode(Comic.self, from: data)
            return comic
            
        } catch is DecodingError {
            throw XKCDError.decodingError
        } catch let error as XKCDError {
            throw error
        } catch {
            throw XKCDError.networkError(error)
        }
    }
}
