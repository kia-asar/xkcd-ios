//
//  XKCDService.swift
//  XKCDViewer
//
//  Created by Kiarash Asar on 6/2/25.
//

import Foundation

protocol XKCDServicing {
    func fetchComic(number: Int) async throws -> Comic
}

final class XKCDService: XKCDServicing {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetchComic(number: Int) async throws -> Comic {
        let url = URL(string: "https://xkcd.com/\(number)/info.0.json")!
        let (data, _) = try await urlSession.data(from: url)
        
        let comic = try JSONDecoder().decode(Comic.self, from: data)
        return comic
    }
}
