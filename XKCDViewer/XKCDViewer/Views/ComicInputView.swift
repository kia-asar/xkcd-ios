//
//  ComicInputView.swift
//  XKCDViewer
//
//  Created by Kiarash Asar on 6/2/25.
//

import SwiftUI

struct ComicInputView: View {
    @State private var comicNumberText = ""
    @State private var showingComicDetail = false
    @State private var selectedComicNumber: Int?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()
                
                VStack(spacing: 16) {
                    Image(systemName: "newspaper")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    
                    Text("XKCD Comic Viewer")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Enter a comic number to view")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 16) {
                    TextField("Comic Number", text: $comicNumberText)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    
                    Button(action: submitComic) {
                        Text("View Comic")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $showingComicDetail) {
                if let comicNumber = selectedComicNumber {
                    ComicDetailView(comicNumber: comicNumber)
                }
            }
        }
    }
    
    private func submitComic() {
        guard let number = Int(comicNumberText), number > 0 else {
            return
        }
        selectedComicNumber = number
        showingComicDetail = true
    }
}

#Preview {
    ComicInputView()
}
