//
//  ComicDetailView.swift
//  XKCDViewer
//
//  Created by Kiarash Asar on 6/2/25.
//

import SwiftUI

struct ComicDetailView: View {
    let comicNumber: Int
    
    @StateObject private var viewModel = ComicDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                if viewModel.isLoading {
                    loadingView()
                } else if let comic = viewModel.comic {
                    comicContentView(comic: comic)
                }
            }
            .padding()
        }
        .navigationTitle("Comic #\(String(comicNumber))")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchComic(number: comicNumber)
        }
    }
}

// MARK: - Subviews

private extension ComicDetailView {
    func loadingView() -> some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Loading comic...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 100)
    }
    
    func comicContentView(comic: Comic) -> some View {
        VStack(spacing: 20) {
            Text(comic.title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text(comic.date?.displayFormattedDate ?? "")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            AsyncImage(url: URL(string: comic.img)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(8)
            } placeholder: {
                Image(systemName: "photo")
                    .font(.system(size: 80))
                    .padding()
            }
        }
    }
}

#Preview {
    NavigationStack {
        ComicDetailView(comicNumber: 50)
    }
}
