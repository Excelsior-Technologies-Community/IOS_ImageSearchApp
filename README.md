📸 ImageSearchApp

Product Image Search using SwiftUI, Google Vision API & SerpAPI

ImageSearchApp is a SwiftUI-based iOS application that allows users to select or capture a product image and automatically find similar products online using image recognition and shopping search APIs.

This project demonstrates SwiftUI + MVVM, real-world API integration, and clean architecture suitable for learning, interviews, and portfolio showcase.

⸻

✨ Features
    •    📷 Select a product image from gallery
    •    🧠 Detect product type using image recognition
    •    🛒 Search similar products from Google Shopping
    •    🖼 Display product image + title
    •    ⚡ Fully SwiftUI based
    •    🧩 Clean MVVM architecture
    •    📱 iOS 15+ supported

⸻

🧠 How the App Works

User selects product image
        ↓
Google Vision API detects product keyword
        ↓
Keyword sent to SerpAPI (Google Shopping)
        ↓
Similar products displayed in UI


⸻

📸 What Type of Image Should You Use?

✅ Recommended (Works Best)
    •    Shoes 👟
    •    Mobile phones 📱
    •    Watches ⌚
    •    Bottles 🧴
    •    Headphones 🎧

❌ Avoid These (Will Fail)
    •    Screenshots
    •    App UI images
    •    Website screenshots
    •    Text-heavy images

⚠️ The image must be a real photo of a physical product, not a screenshot.

⸻

🏗️ Project Folder Structure (Professional)

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

This structure follows MVVM + Clean Architecture, commonly used in real production apps.

⸻

🔑 API Setup (Step-by-Step Guide)

This project uses two APIs:
    1.    Google Vision API – Image recognition
    2.    SerpAPI – Google Shopping product search

👉 Both APIs are FREE to use within their free tiers
👉 Google asks for billing setup, but FREE usage is guaranteed
👉 No money is deducted unless free limits are exceeded

🔥 FREE means no charge — billing is only for verification.

⸻

1️⃣ Google Vision API Setup
    1.    Go to https://console.cloud.google.com
    2.    Create a new project named ImageSearchApp
    3.    Enable Cloud Vision API
    4.    Enable billing (required but FREE tier)
    5.    Create and copy API key

⸻

2️⃣ SerpAPI Setup
    1.    Visit https://serpapi.com
    2.    Sign up using Google or GitHub
    3.    Copy API key from dashboard

Free tier: 100 searches/month (FREE)

⸻

🔐 Where to Put API Keys

Open:

Presentation/Views/ContentView.swift

Replace:

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
    6.    View similar products 🎉

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
 
