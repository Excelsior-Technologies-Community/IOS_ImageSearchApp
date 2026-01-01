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

## 🧩 Code Explanation (Why Each File Exists)

### `ContentView.swift`
- Entry UI of the app
- Injects API keys into ViewModel
- Observes image selection
- Automatically triggers image search
- Displays product list
- Uses `@StateObject` to preserve ViewModel lifecycle

### `ProductSearchViewModel.swift`
- Business logic layer (MVVM)
- Coordinates Vision API and SerpAPI
- Filters non-product keywords (e.g. Screenshot)
- Publishes UI state using `@Published`
- Keeps Views clean and testable

### `VisionService.swift`
- Handles image recognition
- Converts image to Base64
- Sends request to Google Vision API
- Extracts detected labels as keywords

### `ProductSearchService.swift`
- Searches products using SerpAPI
- Queries Google Shopping
- Maps API response into domain models

### `Product.swift`
- Domain model for product data
- Conforms to `Identifiable`
- Used directly in SwiftUI lists

### `ImagePicker.swift`
- UIKit → SwiftUI bridge
- Uses `UIImagePickerController`
- Implements Coordinator pattern
- Handles image selection safely

---

## ⚠️ Common Issues & Fixes

| Issue | Solution |
|-------|----------|
| Only shows "Searching image…" | Billing not enabled for Vision API |
| Keyword detected as "Screenshot" | You selected a screenshot – use a real product photo |
| No products displayed | Invalid SerpAPI key or free quota exceeded |

---

## 📱 Requirements

- iOS 15+
- Xcode 14+
- Internet connection

---

## 🎯 Learning Outcomes

By building this project, you learn:

- SwiftUI state management
- MVVM architecture
- API integration
- Image recognition flow
- Async image loading
- Dependency injection

---

## 🚀 Future Improvements

- [ ] Camera-only capture
- [ ] Grid layout (LazyVGrid)
- [ ] Open product link on tap
- [ ] Offline CoreML (no APIs)
- [ ] Amazon / Flipkart integration
- [ ] Price comparison

---

## 📌 Final Notes

- ✅ APIs used are **FREE**
- ✅ Billing does **NOT** mean paid usage
- ✅ This is a real portfolio-level project
- ✅ Suitable for interviews & GitHub showcase

---
 
