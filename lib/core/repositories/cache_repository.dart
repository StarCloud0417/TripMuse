/// Repository interface for cache management
abstract class CacheRepository {
  /// Get cached data by key
  Future<T?> get<T>(String key);
  
  /// Set cached data with optional TTL
  Future<void> set<T>(String key, T value, {Duration? ttl});
  
  /// Remove cached data by key
  Future<void> remove(String key);
  
  /// Clear all cached data
  Future<void> clear();
  
  /// Check if key exists in cache
  Future<bool> contains(String key);
  
  /// Get cache size in bytes
  Future<int> getCacheSize();
  
  /// Clean up expired entries
  Future<void> cleanupExpired();
  
  /// Get cache statistics
  Future<CacheStats> getStats();
}

/// Cache statistics model
class CacheStats {
  final int totalEntries;
  final int expiredEntries;
  final int sizeInBytes;
  final DateTime lastCleanup;
  
  const CacheStats({
    required this.totalEntries,
    required this.expiredEntries,
    required this.sizeInBytes,
    required this.lastCleanup,
  });
}