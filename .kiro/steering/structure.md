# TripMuse Project Structure & Organization

## Root Structure
```
├── lib/                          # Flutter app source code
├── gcp-backend/                  # Node.js backend API server
├── test/                         # Unit and widget tests
├── integration_test/             # Integration tests
├── assets/                       # Static assets (MapBox styles, images)
├── android/                      # Android platform code
├── ios/                          # iOS platform code
└── .kiro/                        # Kiro AI assistant configuration
```

## Flutter App Structure (lib/)
```
lib/
├── main.dart                     # App entry point with MapBox examples
├── tripmuse/                     # TripMuse app implementation
│   ├── tripmuse_app.dart         # Main TripMuse app with bottom navigation
│   ├── models/                   # Data models with Freezed
│   │   ├── trip.dart             # Trip data model
│   │   ├── activity.dart         # Activity data model
│   │   ├── user.dart             # User data model
│   │   └── *.freezed.dart        # Generated Freezed files
│   ├── services/                 # Business logic and API layer
│   │   ├── api_client.dart       # HTTP client with Dio
│   │   ├── trip_service.dart     # Trip management service
│   │   ├── places_service.dart   # Google Places integration
│   │   └── storage/              # Local storage with Hive
│   ├── providers/                # Riverpod state management
│   │   ├── trip_provider.dart    # Trip state management
│   │   └── user_provider.dart    # User state management
│   ├── screens/                  # UI screens
│   │   ├── home_screen.dart      # Main dashboard
│   │   ├── map_screen.dart       # MapBox integration
│   │   └── api_test_screen.dart  # API testing interface
│   ├── widgets/                  # Reusable UI components
│   │   ├── trip_card.dart        # Trip display component
│   │   └── trip_generation_*.dart # Trip generation UI
│   ├── theme/                    # Material 3 theme configuration
│   └── utils/                    # Utility functions
└── *.dart                        # MapBox example files (preserved)
```

## Backend Structure (gcp-backend/)
```
gcp-backend/
├── server.js                     # Express server with API routes
├── package.json                  # Node.js dependencies
├── Dockerfile                    # Container configuration
├── .env.example                  # Environment variables template
└── README.md                     # Backend documentation
```

## Test Structure
```
test/
├── tripmuse/                     # TripMuse-specific tests
│   ├── trip_generation_ui_test.dart
│   └── *_test.dart
├── compilation_test.dart         # Import/compilation verification
├── coordinate_validator_test.dart
└── places_api_test.dart

integration_test/
├── all_test.dart                 # Main integration test suite
├── map_interface_test.dart       # MapBox integration tests
└── */                            # Feature-specific integration tests
```

## Naming Conventions
- **Files**: snake_case (e.g., `trip_service.dart`)
- **Classes**: PascalCase (e.g., `TripService`)
- **Variables/Functions**: camelCase (e.g., `generateTrip`)
- **Constants**: SCREAMING_SNAKE_CASE (e.g., `ACCESS_TOKEN`)
- **Freezed Models**: Include `.freezed.dart` and `.g.dart` generated files

## Architecture Patterns
- **Repository Pattern**: Data access abstraction in services/repositories/
- **Provider Pattern**: Riverpod for state management
- **Freezed Models**: Immutable data classes with JSON serialization
- **Service Layer**: Business logic separation from UI
- **Offline-First**: Hive local storage with cloud sync capability

## Import Organization
1. Flutter/Dart imports first
2. Third-party package imports
3. Local project imports (relative paths)
4. Separate groups with blank lines

## Asset Organization
- MapBox styles and configurations in `assets/`
- Images and icons in `assets/symbols/`
- GeoJSON data in `assets/` root
- Cluster configurations in `assets/cluster/`