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
                } else if let errorMessage = viewModel.errorMessage {
                    errorView(message: errorMessage)
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
    
    func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.red)
            
            Text("Error")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Try Again") {
                Task {
                    await viewModel.fetchComic(number: comicNumber)
                }
            }
            .buttonStyle(.borderedProminent)
            .accessibilityIdentifier("comic-retry-button")
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
                    .accessibilityLabel(comic.transcript.isEmpty ? comic.alt : comic.transcript)
                    .accessibilityIdentifier("comic-image")
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray5))
                    .aspectRatio(1, contentMode: .fit)
                    .overlay {
                        ProgressView()
                    }
            }
            
            let caption = comic.alt
            if !caption.isEmpty {
                captionView(caption: caption)
            }
        }
        .padding(.horizontal)
    }
    
    func captionView(caption: String) -> some View {
        DisclosureGroup("Caption") {
            VStack(alignment: .leading, spacing: 8) {
                Text(caption)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
        .font(.footnote)
        .accessibilityIdentifier("comic-caption-toggle")
    }
}

#Preview {
    NavigationStack {
        ComicDetailView(comicNumber: 50)
    }
}
