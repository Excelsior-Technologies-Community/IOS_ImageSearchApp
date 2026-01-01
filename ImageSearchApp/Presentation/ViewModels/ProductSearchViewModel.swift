//
//  ContentView.swift
//  ImageSearchApp
//
//  Created by Noman belim on 01/01/26.
//

import SwiftUI

final class ProductSearchViewModel: ObservableObject {

    @Published var products: [Product] = []
    @Published var isLoading = false

    private let visionService: VisionService
    private let productService: ProductSearchService

    init(googleVisionKey: String, serpApiKey: String) {
        self.visionService = VisionService(apiKey: googleVisionKey)
        self.productService = ProductSearchService(apiKey: serpApiKey)
    }

    func search(image: UIImage) {
        isLoading = true
        products.removeAll()

        visionService.detectLabels(image: image) { [weak self] keywords in
            guard let self else { return }

            let filteredKeywords = keywords.filter {
                !["screenshot", "text", "font", "display", "screen"]
                    .contains($0.lowercased())
            }

            guard let keyword = filteredKeywords.first else {
                DispatchQueue.main.async { self.isLoading = false }
                return
            }

            self.productService.searchProducts(keyword: keyword) { products in
                DispatchQueue.main.async {
                    self.products = products
                    self.isLoading = false
                }
            }
        }
    }
}
