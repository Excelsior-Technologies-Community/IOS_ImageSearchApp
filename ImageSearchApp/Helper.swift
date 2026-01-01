//
//  Helper.swift
//  ImageSearchApp
//
//  Created by Noman belim  
//
//
//import Foundation
//import SwiftUI
//import UIKit
//
//enum APIKeys {
//    static let googleVision = "AIzaSyCqafK_zWnJ1h7ZY_KTpsxmHRCQDAZzw_Q"
//    static let serpAPI = "182085de76d60935cc6e34ddc0b6c449397c7fe5cc68191b808df49433a1088d"
//}
//import Foundation
//
//struct Product: Identifiable {
//    let id = UUID()
//    let title: String
//    let imageUrl: String
//    let link: String
//}
//
//
//
//struct ImagePicker: UIViewControllerRepresentable {
//
//    @Binding var image: UIImage?
//
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.delegate = context.coordinator
//        picker.sourceType = .photoLibrary
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//
//        let parent: ImagePicker
//
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//        }
//
//        func imagePickerController(
//            _ picker: UIImagePickerController,
//            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
//        ) {
//            parent.image = info[.originalImage] as? UIImage
//            picker.dismiss(animated: true)
//        }
//    }
//}
// 
//final class VisionService {
//
//    private let apiKey: String
//
//    init(apiKey: String) {
//        self.apiKey = apiKey
//    }
//
//    func detectLabels(
//        image: UIImage,
//        completion: @escaping ([String]) -> Void
//    ) {
//
//        print("🟡 VisionService started")
//
//        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
//            print("❌ Image conversion failed")
//            return
//        }
//
//        let base64Image = imageData.base64EncodedString()
//
//        let body: [String: Any] = [
//            "requests": [[
//                "image": ["content": base64Image],
//                "features": [[
//                    "type": "LABEL_DETECTION",
//                    "maxResults": 5
//                ]]
//            ]]
//        ]
//
//        let url = URL(
//            string: "https://vision.googleapis.com/v1/images:annotate?key=\(apiKey)"
//        )!
//
//        print("🌍 Vision API URL:", url)
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        URLSession.shared.dataTask(with: request) { data, _, error in
//
//            if let error {
//                print("❌ Vision error:", error.localizedDescription)
//                return
//            }
//
//            guard let data else {
//                print("❌ Vision returned no data")
//                return
//            }
//
//            print("📦 Vision response received")
//
//            guard
//                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
//                let responses = json["responses"] as? [[String: Any]],
//                let labels = responses.first?["labelAnnotations"] as? [[String: Any]]
//            else {
//                print("❌ Vision parse failed")
//                return
//            }
//
//            let keywords = labels.compactMap { $0["description"] as? String }
//            print("✅ Vision keywords:", keywords)
//
//            completion(keywords)
//
//        }.resume()
//    }
//}
//import Foundation
//
//import Foundation
//
//final class ProductSearchService {
//
//    private let apiKey: String
//
//    init(apiKey: String) {
//        self.apiKey = apiKey
//    }
//
//    func searchProducts(
//        keyword: String,
//        completion: @escaping ([Product]) -> Void
//    ) {
//
//        print("🔍 SerpAPI search started for:", keyword)
//
//        let encoded = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//
//        let url = URL(
//            string: "https://serpapi.com/search.json?q=\(encoded)&tbm=shop&api_key=\(apiKey)"
//        )!
//
//        print("🌍 SerpAPI URL:", url)
//
//        URLSession.shared.dataTask(with: url) { data, _, error in
//
//            if let error {
//                print("❌ SerpAPI error:", error.localizedDescription)
//                return
//            }
//
//            guard let data else {
//                print("❌ SerpAPI returned no data")
//                return
//            }
//
//            print("📦 SerpAPI response received")
//
//            guard
//                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
//                let results = json["shopping_results"] as? [[String: Any]]
//            else {
//                print("❌ SerpAPI parse failed")
//                return
//            }
//
//            let products = results.map {
//                Product(
//                    title: $0["title"] as? String ?? "Unknown",
//                    imageUrl: $0["thumbnail"] as? String ?? "",
//                    link: $0["link"] as? String ?? ""
//                )
//            }
//
//            print("✅ Products found:", products.count)
//            completion(products)
//
//        }.resume()
//    }
//}
//
//
//final class ProductSearchViewModel: ObservableObject {
//
//    @Published var products: [Product] = []
//    @Published var isLoading = false
//
//    private let visionService: VisionService
//    private let productService: ProductSearchService
//
//    init(googleVisionKey: String, serpApiKey: String) {
//        self.visionService = VisionService(apiKey: googleVisionKey)
//        self.productService = ProductSearchService(apiKey: serpApiKey)
//    }
//
//    func search(image: UIImage) {
//
//        print("🟢 ViewModel search started")
//        isLoading = true
//        products.removeAll()
//
//        visionService.detectLabels(image: image) { [weak self] keywords in
//
//            guard let self else { return }
//
//            let filtered = keywords.filter {
//                !["screenshot", "text", "font", "display"].contains($0.lowercased())
//            }
//
//            guard let keyword = filtered.first else {
//                print("❌ No valid keyword found")
//                DispatchQueue.main.async { self.isLoading = false }
//                return
//            }
//
//            self.productService.searchProducts(keyword: keyword) { products in
//                DispatchQueue.main.async {
//                    self.products = products
//                    self.isLoading = false
//                    print("🎉 UI updated")
//                }
//            }
//        }
//    }
//}
