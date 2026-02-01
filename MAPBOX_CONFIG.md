# Mapbox Configuration Guide

## Overview
TripMuse now uses Mapbox Maps Flutter v2.10.0 for map functionality.

## Configuration Files

### 1. pubspec.yaml
```yaml
dependencies:
  mapbox_maps_flutter: ^2.10.0
```

### 2. android/gradle.properties
```properties
# Mapbox SDK Registry Token
MAPBOX_DOWNLOADS_TOKEN=YOUR_MAPBOX_ACCESS_TOKEN
```

### 3. android/app/build.gradle.kts
```gradle
defaultConfig {
    // Mapbox configuration
    manifestPlaceholders["com.mapbox.token"] = "YOUR_MAPBOX_ACCESS_TOKEN"
}
```

### 4. android/app/src/main/AndroidManifest.xml
```xml
<!-- Mapbox Configuration -->
<meta-data
    android:name="com.mapbox.token"
    android:value="YOUR_MAPBOX_ACCESS_TOKEN" />
```

### 5. ios/Runner/Info.plist
```xml
<key>MBXAccessToken</key>
<string>YOUR_MAPBOX_ACCESS_TOKEN</string>
```

## Environment Variables
Set the following environment variable for development:
```bash
MAPBOX_DOWNLOADS_TOKEN=YOUR_MAPBOX_ACCESS_TOKEN
```

## Usage Example
See `lib/widgets/mapbox_map_screen.dart` for a complete example of how to use Mapbox maps in the app.

## Token Information
- **Token**: `YOUR_MAPBOX_ACCESS_TOKEN`
- **Type**: Public Access Token
- **Permissions**: Maps, Navigation, Search

## Troubleshooting
1. Ensure all configuration files have the correct token
2. Set the MAPBOX_DOWNLOADS_TOKEN environment variable
3. Clean and rebuild the project: `flutter clean && flutter pub get`
4. Check AndroidManifest.xml and Info.plist for correct meta-data entries
