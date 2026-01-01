//
//  ContentView.swift
//  ImageSearchApp
//
//  Created by Noman belim on 01/01/26.
//
import UIKit

final class VisionService {

    private let apiKey: String

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func detectLabels(
        image: UIImage,
        completion: @escaping ([String]) -> Void
    ) {

        guard let imageData = image.jpegData(compressionQuality: 0.7) else { return }
        let base64Image = imageData.base64EncodedString()

        let body: [String: Any] = [
            "requests": [[
                "image": ["content": base64Image],
                "features": [[
                    "type": "LABEL_DETECTION",
                    "maxResults": 5
                ]]
            ]]
        ]

        let url = URL(
            string: "https://vision.googleapis.com/v1/images:annotate?key=\(apiKey)"
        )!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard
                let data,
                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let responses = json["responses"] as? [[String: Any]],
                let labels = responses.first?["labelAnnotations"] as? [[String: Any]]
            else { return }

            let keywords = labels.compactMap { $0["description"] as? String }
            completion(keywords)
        }.resume()
    }
}
