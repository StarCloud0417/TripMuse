/// Base repository interface defining common CRUD operations
abstract class BaseRepository<T, ID> {
  /// Get all items
  Future<List<T>> getAll();
  
  /// Get item by ID
  Future<T?> getById(ID id);
  
  /// Save item (create or update)
  Future<void> save(T item);
  
  /// Delete item by ID
  Future<void> delete(ID id);
  
  /// Check if item exists
  Future<bool> exists(ID id);
  
  /// Clear all items
  Future<void> clear();
}