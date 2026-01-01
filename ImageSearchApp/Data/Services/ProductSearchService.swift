//
//  ContentView.swift
//  ImageSearchApp
//
//  Created by Noman belim on 01/01/26.
//
import Foundation

final class ProductSearchService {

    private let apiKey: String

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func searchProducts(
        keyword: String,
        completion: @escaping ([Product]) -> Void
    ) {

        let encoded = keyword.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ) ?? ""

        let url = URL(
            string: "https://serpapi.com/search.json?q=\(encoded)&tbm=shop&api_key=\(apiKey)"
        )!

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard
                let data,
                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let results = json["shopping_results"] as? [[String: Any]]
            else { return }

            let products = results.map {
                Product(
                    title: $0["title"] as? String ?? "Unknown Product",
                    imageUrl: $0["thumbnail"] as? String ?? "",
                    link: $0["link"] as? String ?? ""
                )
            }

            completion(products)
        }.resume()
    }
}
