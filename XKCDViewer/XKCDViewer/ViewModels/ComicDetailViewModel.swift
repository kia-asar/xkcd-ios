//
//  ComicViewModel.swift
//  XKCDViewer
//
//  Created by Kiarash Asar on 6/2/25.
//

import Foundation

@MainActor
final class ComicDetailViewModel: ObservableObject {
    @Published var comic: Comic?
    @Published var errorMessage: String?
    
    private let xkcdService: XKCDServicing
    
    init(xkcdService: XKCDServicing = XKCDService()) {
        self.xkcdService = xkcdService
    }
    
    func fetchComic(number: Int) async {
        errorMessage = nil
        comic = nil
        
        do {
            let fetchedComic = try await xkcdService.fetchComic(number: number)
            comic = fetchedComic
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
