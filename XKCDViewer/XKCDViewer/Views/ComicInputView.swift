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
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()
                
                VStack(spacing: 16) {
                    Image(systemName: "newspaper")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                        .accessibilityHidden(true)
                    
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
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isInputFocused ? Color.blue : Color(.systemGray4), lineWidth: 2)
                        )
                        .focused($isInputFocused)
                        .accessibilityIdentifier("comic-number-input")
                    
                    Button(action: submitComic) {
                        Text("View Comic")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isValidInput ? Color.blue : Color.gray)
                            .cornerRadius(10)
                    }
                    .disabled(!isValidInput)
                    .accessibilityIdentifier("view-comic-button")
                    
                    if !comicNumberText.isEmpty && !isValidInput {
                        Text("Please enter a valid comic number")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .background(Color.clear)
            .contentShape(Rectangle())
            .onTapGesture {
                isInputFocused = false
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isInputFocused = true
                }
            }
            .navigationDestination(isPresented: $showingComicDetail) {
                if let comicNumber = selectedComicNumber {
                    ComicDetailView(comicNumber: comicNumber)
                }
            }
        }
    }
}

// MARK: - Logic Helpers

private extension ComicInputView {
    var selectedComicNumber: Int? {
        guard let number = Int(comicNumberText), number > 0 else {
            return nil
        }
        return number
    }
    var isValidInput: Bool {
        selectedComicNumber != nil
    }
    
    func submitComic() {
        guard isValidInput else { return }
        isInputFocused = false
        showingComicDetail = true
    }
}

#Preview {
    ComicInputView()
}
