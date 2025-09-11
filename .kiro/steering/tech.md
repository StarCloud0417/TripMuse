# TripMuse Tech Stack & Build System

## Framework & Core Technologies
- **Flutter**: 3.x with Dart SDK >=3.0.0
- **State Management**: Riverpod for reactive state management
- **Maps**: MapBox Maps Flutter SDK for interactive mapping
- **Backend**: Node.js Express server on Google Cloud Run
- **AI**: Google Gemini API for trip generation
- **Places**: Google Places API for location data enhancement

## Key Dependencies
- **Data Models**: Freezed + JSON Annotation for immutable models with serialization
- **Local Storage**: Hive + Flutter Secure Storage for offline-first architecture
- **HTTP Client**: Dio with interceptors for API communication
- **Authentication**: Firebase Auth + Google Sign-In
- **Database**: Cloud Firestore for cloud sync
- **Testing**: flutter_test, mockito for unit/widget tests

## Backend Stack
- **Runtime**: Node.js >=18.0.0
- **Framework**: Express.js with CORS, Helmet, Compression
- **AI Integration**: @google/generative-ai for Gemini API
- **Cloud Services**: Google Cloud Secret Manager, Firebase Admin
- **Logging**: Winston for structured logging
- **Validation**: Joi for request validation

## Build & Development Commands

### Flutter App
```bash
# Install dependencies
flutter pub get

# Run code generation (for Freezed models)
flutter packages pub run build_runner build

# Run app with MapBox token
flutter run --dart-define=ACCESS_TOKEN=YOUR_MAPBOX_TOKEN

# Run tests
flutter test

# Run integration tests
flutter test integration_test/

# Build for production
flutter build apk --release
flutter build ios --release
```

### Backend (gcp-backend/)
```bash
# Install dependencies
npm install

# Run development server
npm run dev

# Run production server
npm start

# Deploy to Cloud Run (requires gcloud CLI)
gcloud run deploy tripmuse-api --source .
```

## Code Generation
- Run `flutter packages pub run build_runner build` after modifying Freezed models
- Use `--delete-conflicting-outputs` flag if needed for clean rebuilds
- Hive type adapters are auto-generated for local storage models

## Environment Setup
- MapBox access token required via --dart-define=ACCESS_TOKEN
- Backend requires GEMINI_API_KEY environment variable
- Firebase configuration needed for authentication features