# ✈️ TripMuse

> **Describe your dream trip. Let AI plan it.**

TripMuse is a cross-platform travel planning app built with Flutter. Tell it where you want to go and what you enjoy — it generates a personalized day-by-day itinerary using AI, visualizes it on an interactive map, and lets you export it as a beautiful PDF to take offline.

---

## ✨ Features

- 🤖 **AI Itinerary Generation** — describe your trip in natural language and get a complete personalized schedule
- 🗺️ **Interactive Map View** — visualize your itinerary on a map with route overlays
- 📅 **Day-by-Day Timeline** — clean timeline UI for daily planning and time management
- 📄 **PDF Export** — export your full itinerary as a shareable PDF document
- 🔐 **Authentication** — Google Sign-In + Firebase Auth with guest mode
- 💾 **Offline Storage** — Hive-powered local storage so your plans are always accessible
- 🌐 **Cross-Platform** — supports Android, iOS, Web, Windows, Linux, and macOS

---

## 🛠 Tech Stack

| Layer | Technology |
|-------|------------|
| Framework | Flutter 3.x + Dart 3 |
| State Management | Riverpod 2.x |
| Networking | Dio 5.x |
| Local Storage | Hive + Flutter Secure Storage |
| Authentication | Firebase Auth + Google Sign-In |
| Maps | Google Maps Flutter |
| PDF Generation | `pdf` package |
| Data Models | Freezed + JSON serialization |
| Routing | GoRouter |

---

## 🏗 Project Structure

```
lib/
├── core/
│   ├── models/          # Trip, DayPlan, Activity, User, etc.
│   ├── services/        # AI service, Logger, ErrorHandler, Cache
│   ├── providers/       # Riverpod state management
│   ├── widgets/         # Shared UI components
│   └── exceptions/      # Custom exception types
├── screens/             # App pages (Home, Planning, Map, Export)
└── utils/               # Helpers and constants
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter 3.9.0+
- Dart 3.0+
- A Firebase project (for Auth)
- Google Maps API key
- Google Places API key

### Setup

```bash
# Clone the repo
git clone https://github.com/StarCloud0417/TripMuse.git
cd TripMuse

# Install dependencies
flutter pub get
```

### Configure API Keys

**Google Maps (Android)**  
In `android/app/build.gradle.kts`, set:
```gradle
manifestPlaceholders["com.google.android.geo.API_KEY"] = "YOUR_GOOGLE_MAPS_API_KEY"
```

**Google Maps (iOS)**  
In `ios/Runner/AppDelegate.swift`, add:
```swift
GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
```

Firebase config goes in `google-services.json` (Android) and `GoogleService-Info.plist` (iOS).

### Run

```bash
# Debug mode
flutter run --debug

# Release build (APK)
flutter build apk --release

# Release build (iOS)
flutter build ios --release
```

---

## 📋 Roadmap

- [x] Flutter project architecture
- [x] Riverpod state management & data layer
- [x] Firebase Auth + Google Sign-In
- [x] Hive local storage (offline support)
- [x] Google Maps integration
- [x] PDF export
- [x] Timeline UI
- [ ] AI itinerary generation service (LLM integration)
- [ ] Smart activity recommendation engine
- [ ] Collaborative trip planning (multi-user)
- [ ] App Store & Play Store release

---

## 🐛 Changelog

### v0.0.5
- Merged Mapbox map integration branch
- Improved timeline and map view switching

### v0.0.4
- Fixed Hive `typeId` conflict (`User` and `ActivityCategory` both used typeId 4)
- Fixed local storage initialization order ("local storage not initialized" error)
- Updated repository implementation to use lazy box access
- Regenerated Hive adapters

### v0.0.3
- Core architecture and dependency setup complete

---

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.
