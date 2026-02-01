/// Utility class for generating consistent cache keys
class CacheKeys {
  // Trip related cache keys
  static String tripList(String? userId) => 'trips_${userId ?? 'guest'}';
  static String trip(String tripId) => 'trip_$tripId';
  static String tripGeneration(String requestHash) => 'trip_generation_$requestHash';
  
  // User related cache keys
  static String userProfile(String userId) => 'user_profile_$userId';
  static String userPreferences(String userId) => 'user_preferences_$userId';
  
  // Places API cache keys
  static String placeDetails(String placeId) => 'place_details_$placeId';
  static String placeSearch(String query) => 'place_search_${query.hashCode}';
  static String placePhotos(String placeId) => 'place_photos_$placeId';
  
  // Map related cache keys
  static String mapTiles(String tileId) => 'map_tiles_$tileId';
  static String routeData(String routeHash) => 'route_data_$routeHash';
  
  // API response cache keys
  static String apiResponse(String endpoint, Map<String, dynamic>? params) {
    final paramsHash = params?.toString().hashCode ?? 0;
    return 'api_${endpoint.replaceAll('/', '_')}_$paramsHash';
  }
  
  // Settings cache keys
  static const String appSettings = 'app_settings';
  static const String userSettings = 'user_settings';
  static const String mapSettings = 'map_settings';
}