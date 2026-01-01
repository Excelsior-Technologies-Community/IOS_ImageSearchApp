//
//  ContentView.swift
//  ImageSearchApp
//
//  Created by Noman belim on 01/01/26.
//

import SwiftUI
import SwiftUI

// ✅ GLOBAL CONSTANTS (outside the View)
private let GOOGLE_VISION_API_KEY =
    "AIzaSyCqafK_zWnJ1h7ZY_KTpsxmHRCQDAZzw_Q"

private let SERP_API_KEY =
    "182085de76d60935cc6e34ddc0b6c449397c7fe5cc68191b808df49433a1088d"

struct ContentView: View {

    @StateObject private var viewModel: ProductSearchViewModel
    @State private var selectedImage: UIImage?
    @State private var showPicker = false

    // ✅ SAFE INIT
    init() {
        _viewModel = StateObject(
            wrappedValue: ProductSearchViewModel(
                googleVisionKey: GOOGLE_VISION_API_KEY,
                serpApiKey: SERP_API_KEY
            )
        )
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {

                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                }

                Button("Choose Image") {
                    showPicker = true
                }

                if viewModel.isLoading {
                    ProgressView("Searching image...")
                }
                List(viewModel.products) { product in
                    VStack(alignment: .leading, spacing: 8) {

                        // 🖼 Product Image
                        AsyncImage(url: URL(string: product.imageUrl)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(height: 140)

                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 140)
                                    .cornerRadius(10)

                            case .failure:
                                Image(systemName: "photo")
                                    .frame(height: 140)
                                    .foregroundColor(.gray)

                            @unknown default:
                                EmptyView()
                            }
                        }

                        // 🏷 Product Title
                        Text(product.title)
                            .font(.headline)
                            .lineLimit(2)
                    }
                    .padding(.vertical, 6)
                }
            }
            .padding()
            .navigationTitle("Product Image Search")
        }
        .sheet(isPresented: $showPicker) {
            ImagePicker(image: $selectedImage)
        }
        .onChange(of: selectedImage) { newImage in
            guard let image = newImage else { return }
            viewModel.search(image: image)
        }
    }
}

#Preview {
    ContentView()
}
