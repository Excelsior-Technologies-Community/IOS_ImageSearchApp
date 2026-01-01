# 📸 ImageSearchApp

## Product Image Search using SwiftUI, Google Vision API & SerpAPI

ImageSearchApp is a SwiftUI-based iOS application that allows users to select or capture a product image and automatically find similar products online using image recognition and shopping search APIs.

This project demonstrates **SwiftUI + MVVM**, real-world API integration, and clean architecture suitable for learning, interviews, and portfolio showcase.

---

## ✨ Features

- 📷 Select a product image from gallery
- 🧠 Detect product type using image recognition
- 🛒 Search similar products from Google Shopping
- 🖼 Display product image + title
- ⚡ Fully SwiftUI based
- 🧩 Clean MVVM architecture
- 📱 iOS 15+ supported

---

## 🧠 How the App Works

```
User selects product image
        ↓
Google Vision API detects product keyword
        ↓
Keyword sent to SerpAPI (Google Shopping)
        ↓
Similar products displayed in UI
```

---

## 📸 What Type of Image Should You Use?

### ✅ Recommended (Works Best)

- Shoes 👟
- Mobile phones 📱
- Watches ⌚
- Bottles 🧴
- Headphones 🎧

### ❌ Avoid These (Will Fail)

- Screenshots
- App UI images
- Website screenshots
- Text-heavy images

---

## 🗂️ Project Folder Structure (Professional)

```
ImageSearchApp
├── App
│   └── ImageSearchAppApp.swift
├── Presentation
│   ├── Views
│   │   └── ContentView.swift
│   └── ViewModels
│       └── ProductSearchViewModel.swift
├── Domain
│   └── Models
│       └── Product.swift
├── Data
│   └── Services
│       ├── VisionService.swift
│       └── ProductSearchService.swift
├── Utilities
│   └── ImagePicker.swift
├── Resources
│   └── Assets.xcassets
└── Supporting Files
    └── Info.plist
```

This structure follows **MVVM + Clean Architecture**, commonly used in real production apps.

---

## 🔑 API Setup (Step-by-Step Guide)

This project uses two APIs:

1. **Google Vision API** – Image recognition
2. **SerpAPI** – Google Shopping product search

> 👉 Both APIs are **FREE** to use within their free tiers  
> 👉 Google asks for billing setup, but FREE usage is guaranteed  
> 👉 No money is deducted unless free limits are exceeded  
> 🔥 **FREE means no charge** — billing is only for verification

---

### 1️⃣ Google Vision API Setup (Image Recognition)

#### Step 1: Create Project

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Create a new project named `ImageSearchApp`

#### Step 2: Enable Vision API

1. Navigate to **APIs & Services → Library**
2. Search for **Cloud Vision API**
3. Click **Enable**

#### Step 3: Enable Billing (IMPORTANT)

- Google requires billing even for FREE tier
- **Free tier**: 1000 images/month
- Add card → set budget alert → ₹0

> 👉 This API is **FREE** under free tier  
> 👉 Billing ≠ Paid usage

#### Step 4: Create API Key

1. Navigate to **APIs & Services → Credentials**
2. Click **Create Credentials → API Key**
3. Copy the generated key

---

### 2️⃣ SerpAPI Setup (Product Search)

#### Step 1: Create Account

- Visit [SerpAPI](https://serpapi.com)
- Sign up using Google or GitHub

#### Step 2: Get API Key

- Open your dashboard
- Copy your API key

**Free Tier:**
- 100 searches/month
- **FREE**
- Perfect for learning and demos

---

## 🔐 Where to Put API Keys

Open the file:

```
Presentation/Views/ContentView.swift
```

Replace the placeholder values with your own API keys:

```swift
// ✅ GLOBAL CONSTANTS (outside the View)
private let GOOGLE_VISION_API_KEY = "YOUR_GOOGLE_VISION_API_KEY"
private let SERP_API_KEY = "YOUR_SERPAPI_KEY"
```

> ⚠️ **Never commit real API keys to public repositories.**

---

## ▶️ How to Run the App

1. Clone the repository
   ```bash
   git clone https://github.com/yourusername/ImageSearchApp.git
   cd ImageSearchApp
   ```

2. Open `ImageSearchApp.xcodeproj` in Xcode

3. Paste your API keys in `ContentView.swift`

4. Run on simulator or real device

5. Select a real product image

6. View similar products instantly 🎉

---

## 🧩 Complete Code Structure & Explanation

### 📄 `Product.swift` - Domain Model

**Purpose**: Represents a single product with all necessary information for display.

```swift
import Foundation

struct Product: Identifiable {
    let id = UUID()
    let title: String
    let imageUrl: String
    let link: String
}
```

**Why this code?**
- `Identifiable` protocol allows SwiftUI's `List` to uniquely identify each product
- `UUID()` generates a unique identifier automatically
- Simple, immutable struct following value-type semantics
- Contains only the data needed for UI display

---

### 🔍 `VisionService.swift` - Image Recognition

**Purpose**: Handles communication with Google Vision API to detect objects in images.

```swift
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
```

**Why this code?**
- **Dependency Injection**: API key passed via initializer for testability
- **Base64 Encoding**: Google Vision API requires images in Base64 format
- **Compression**: `compressionQuality: 0.7` reduces file size without losing quality
- **Label Detection**: Extracts up to 5 labels/keywords from the image
- **Completion Handler**: Async pattern for network calls
- **Error Handling**: `guard` statements safely unwrap optional JSON data
- **compactMap**: Filters out nil values while extracting descriptions

---

### 🛍️ `ProductSearchService.swift` - Product Search

**Purpose**: Searches for products using SerpAPI's Google Shopping integration.

```swift
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
```

**Why this code?**
- **URL Encoding**: `addingPercentEncoding` handles special characters in search queries
- **tbm=shop**: SerpAPI parameter to search specifically in Google Shopping
- **Safe Unwrapping**: `??` operator provides fallback values for missing data
- **map vs compactMap**: Using `map` because we want to keep all results with fallbacks
- **Separation of Concerns**: Service only handles API communication, not business logic

---

### 🧠 `ProductSearchViewModel.swift` - Business Logic

**Purpose**: Coordinates between Vision and Search services, manages app state.

```swift
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
```

**Why this code?**
- **ObservableObject**: Makes ViewModel observable by SwiftUI views
- **@Published**: Automatically notifies views when data changes
- **Dependency Injection**: Services injected via initializer for loose coupling
- **[weak self]**: Prevents memory leaks in async closures
- **guard let self**: Modern Swift pattern to safely unwrap weak self
- **Keyword Filtering**: Removes non-product terms like "screenshot" to improve search accuracy
- **DispatchQueue.main.async**: UI updates must happen on main thread
- **products.removeAll()**: Clears old results before new search
- **MVVM Pattern**: View doesn't know about API implementation, only ViewModel

---

### 🖼️ `ImagePicker.swift` - UIKit Bridge

**Purpose**: Bridges UIKit's image picker with SwiftUI using the Coordinator pattern.

```swift
import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {

    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(
        _ uiViewController: UIImagePickerController,
        context: Context
    ) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject,
                             UINavigationControllerDelegate,
                             UIImagePickerControllerDelegate {

        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            parent.image = info[.originalImage] as? UIImage
            picker.dismiss(animated: true)
        }
    }
}
```

**Why this code?**
- **UIViewControllerRepresentable**: Protocol to use UIKit components in SwiftUI
- **@Binding**: Two-way data binding with parent view
- **Coordinator Pattern**: Required to handle UIKit delegate callbacks in SwiftUI
- **makeUIViewController**: Creates the UIKit view controller once
- **updateUIViewController**: Called when SwiftUI state changes (empty here as no updates needed)
- **makeCoordinator**: Creates coordinator before view controller
- **NSObject**: Required base class for UIKit delegates
- **UIImagePickerControllerDelegate**: Handles image selection events
- **UINavigationControllerDelegate**: Required companion protocol
- **.originalImage**: Gets full-resolution image (not edited version)

---

### 🎨 `ContentView.swift` - Main UI

**Purpose**: Main user interface that ties everything together.

```swift
import SwiftUI

// ✅ GLOBAL CONSTANTS (outside the View)
private let GOOGLE_VISION_API_KEY = "YOUR_GOOGLE_VISION_API_KEY"
private let SERP_API_KEY = "YOUR_SERPAPI_KEY"

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
```

**Why this code?**
- **Global Constants**: API keys outside struct to avoid recreation on every view update
- **@StateObject**: Ensures ViewModel survives view recreations
- **Custom init()**: Safely initializes @StateObject with dependencies
- **_viewModel**: Underscore accesses property wrapper itself, not the value
- **@State**: For simple local state (image, picker visibility)
- **if let**: Optional binding to show image only when selected
- **.resizable()**: Makes image scalable
- **.scaledToFit()**: Maintains aspect ratio
- **.sheet**: Presents ImagePicker modally
- **AsyncImage**: Modern SwiftUI way to load remote images asynchronously
- **phase**: Handles loading, success, and error states elegantly
- **@unknown default**: Future-proofs against new enum cases
- **.onChange**: Triggers search automatically when image is selected
- **List + Identifiable**: Automatic list generation with unique IDs
- **#Preview**: Modern SwiftUI preview macro

---

## 🔄 Data Flow Diagram

```
┌─────────────────┐
│  ContentView    │
│   (UI Layer)    │
└────────┬────────┘
         │ User selects image
         ▼
┌─────────────────────────┐
│ ProductSearchViewModel  │
│   (Business Logic)      │
└───────┬────────┬────────┘
        │        │
        │        └─────────────┐
        ▼                      ▼
┌──────────────┐      ┌────────────────┐
│VisionService │      │ProductSearch   │
│  (API Call)  │      │   Service      │
└──────┬───────┘      └───────┬────────┘
       │                      │
       │ Keywords             │ Products
       └──────────┬───────────┘
                  ▼
         ┌─────────────────┐
         │   ContentView   │
         │  (Display List) │
         └─────────────────┘
```

---

## ⚠️ Common Issues & Fixes

| Issue | Solution |
|-------|----------|
| Only shows "Searching image…" | Billing not enabled for Vision API |
| Keyword detected as "Screenshot" | You selected a screenshot – use a real product photo |
| No products displayed | Invalid SerpAPI key or free quota exceeded |
| App crashes on image selection | Check photo library permissions in Info.plist |
| Blank images in results | Network issue or invalid thumbnail URLs |

---

## 📱 Requirements

- iOS 15+
- Xcode 14+
- Internet connection
- Valid API keys

---

## 🎯 Learning Outcomes

By building this project, you learn:

- ✅ SwiftUI declarative UI
- ✅ MVVM architecture pattern
- ✅ Dependency injection
- ✅ API integration (REST)
- ✅ Async/await patterns
- ✅ Image processing
- ✅ UIKit-SwiftUI bridge
- ✅ ObservableObject & @Published
- ✅ Error handling
- ✅ Clean architecture

---

## 🚀 Future Improvements

- [ ] Camera-only capture
- [ ] Grid layout (LazyVGrid)
- [ ] Open product link on tap
- [ ] Offline CoreML (no APIs)
- [ ] Amazon / Flipkart integration
- [ ] Price comparison
- [ ] Favorites/Wishlist
- [ ] Share product feature

---

## 📌 Key Architecture Decisions

### Why MVVM?
- Separates business logic from UI
- Makes code testable
- Industry-standard pattern

### Why Dependency Injection?
- Makes components reusable
- Easy to mock for testing
- Loose coupling

### Why Services Layer?
- Single Responsibility Principle
- Easy to swap APIs
- Centralized error handling

---

## 🔒 Security Best Practices

> ⚠️ **Important**: The code shows API keys directly for learning purposes only.

**For Production Apps:**

```swift
// ✅ Use environment variables or config files
// ✅ Store keys in Keychain
// ✅ Use backend proxy to hide keys
// ✅ Add .gitignore for config files
```

---
 
