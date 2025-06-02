//
//  ComicDetailView.swift
//  XKCDViewer
//
//  Created by Kiarash Asar on 6/2/25.
//

import SwiftUI

struct ComicDetailView: View {
    let comicNumber: Int
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Comic Title")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(Date.now.displayFormattedDate)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                AsyncImage(url: nil) { image in
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
    }
}

#Preview {
    NavigationStack {
        ComicDetailView(comicNumber: 50)
    }
}
