//
//  ComicDetailView.swift
//  XKCDViewer
//
//  Created by Kiarash Asar on 6/2/25.
//

import SwiftUI

struct ComicDetailView: View {
    let comicNumber: Int
    
    @State var comic: Comic?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text(comic?.title ?? "Comic Title")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                let comicDate = comic?.date ?? .now
                Text(comicDate.displayFormattedDate)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                let comicImageURLString = comic?.img ?? ""
                AsyncImage(url: URL(string: comicImageURLString)) { image in
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
            .padding()
        }
        .navigationTitle("Comic #\(String(comicNumber))")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            comic = try? await XKCDService().fetchComic(number: comicNumber)
        }
    }
}

#Preview {
    NavigationStack {
        ComicDetailView(comicNumber: 50)
    }
}
