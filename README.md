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

User selects product image
↓
Google Vision API detects product keyword
↓
Keyword sent to SerpAPI (Google Shopping)
↓
Similar products displayed in UI

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

⚠️ The image must be a real photo of a physical product, not a screenshot.

---

## 🏗️ Project Folder Structure (Professional)

ImageSearchApp
│
├── App
│   └── ImageSearchAppApp.swift
│
├── Presentation
│   ├── Views
│   │   └── ContentView.swift
│   │
│   └── ViewModels
│       └── ProductSearchViewModel.swift
│
├── Domain
│   └── Models
│       └── Product.swift
│
├── Data
│   └── Services
│       ├── VisionService.swift
│       └── ProductSearchService.swift
│
├── Utilities
│   └── ImagePicker.swift
│
├── Resources
│   └── Assets.xcassets
│
└── Supporting Files
└── Info.plist

This structure follows **MVVM + Clean Architecture**, commonly used in real production apps.

---

## 🔑 API Setup (Step-by-Step Guide)

This project uses two APIs:

1. **Google Vision API** – Image recognition  
2. **SerpAPI** – Google Shopping product search  

👉 Both APIs are **FREE** to use within their free tiers  
👉 Google asks for billing setup, but **FREE usage is guaranteed**  
👉 No money is deducted unless free limits are exceeded  

🔥 **FREE** means no charge — billing is only for verification.

---

## 1️⃣ Google Vision API Setup (Image Recognition)

### Step 1: Create Project

1. Go to 👉 https://console.cloud.google.com
2. Create a new project named **ImageSearchApp**

### Step 2: Enable Vision API

1. APIs & Services → Library
2. Search **Cloud Vision API**
3. Click **Enable**

### Step 3: Enable Billing (IMPORTANT)

- Google requires billing even for **FREE tier**
- Free tier: **1000 images/month**
- Add card → set budget alert → ₹0

👉 This API is **FREE** under free tier  
👉 Billing ≠ Paid usage

### Step 4: Create API Key

1. APIs & Services → Credentials
2. Create API Key
3. Copy the key

---

## 2️⃣ SerpAPI Setup (Product Search)

### Step 1: Create Account

- Visit 👉 https://serpapi.com
- Sign up using Google or GitHub

### Step 2: Get API Key

- Open dashboard
- Copy API key

### Free Tier

- 100 searches/month
- **FREE**
- Perfect for learning and demos

---

## 🔐 Where to Put API Keys

Open:

Presentation/Views/ContentView.swift

Replace:

```swift
private let GOOGLE_VISION_API_KEY = "YOUR_GOOGLE_VISION_API_KEY"
private let SERP_API_KEY = "YOUR_SERPAPI_KEY"

⚠️ Never commit real API keys to public repositories.

⸻

▶️ How to Run the App
    1.    Clone the repository
    2.    Open ImageSearchApp.xcodeproj
    3.    Paste your API keys
    4.    Run on simulator or real device
    5.    Select a real product image
    6.    View similar products instantly 🎉

⸻

🧩 Code Explanation (Why Each File Exists)

ContentView.swift
    •    Main UI screen
    •    Injects API keys
    •    Starts image search on image change
    •    Displays results
    •    Uses @StateObject to keep ViewModel alive

ProductSearchViewModel.swift
    •    Business logic layer
    •    Coordinates Vision API and SerpAPI
    •    Filters bad keywords (like Screenshot)
    •    Exposes UI state using @Published

VisionService.swift
    •    Sends image to Google Vision API
    •    Converts image to Base64
    •    Extracts detected product keywords

ProductSearchService.swift
    •    Sends keyword to SerpAPI
    •    Fetches Google Shopping results
    •    Maps JSON into Product models

Product.swift
    •    Represents a product item
    •    Conforms to Identifiable for SwiftUI lists

ImagePicker.swift
    •    UIKit → SwiftUI bridge
    •    Handles image selection
    •    Uses Coordinator pattern

⸻

❗ Common Issues & Fixes

Only shows “Searching image…”
    •    Billing not enabled for Vision API

Keyword detected as “Screenshot”
    •    You selected a screenshot
    •    Use a real product photo

No products displayed
    •    Invalid SerpAPI key
    •    Free quota exceeded

⸻

📱 Requirements
    •    iOS 15+
    •    Xcode 14+
    •    Internet connection

⸻

🎯 Learning Outcomes

By building this project, you learn:
    •    SwiftUI state management
    •    MVVM architecture
    •    API integration
    •    Image recognition flow
    •    Async image loading
    •    Dependency injection

⸻

🚀 Future Improvements
    •    Camera-only capture
    •    Grid layout (LazyVGrid)
    •    Open product link on tap
    •    Offline CoreML (no APIs)
    •    Amazon / Flipkart integration
    •    Price comparison

⸻

📌 Final Notes
    •    APIs used are FREE
    •    Billing does NOT mean paid usage
    •    This is a real portfolio-level project
    •    Suitable for interviews & GitHub showcase


