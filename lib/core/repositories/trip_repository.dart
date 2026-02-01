import '../models/trip.dart';
import 'base_repository.dart';

/// Repository interface for Trip data management
abstract class TripRepository extends BaseRepository<Trip, String> {
  /// Get trips by user ID
  Future<List<Trip>> getTripsByUserId(String userId);
  
  /// Get recent trips (limited number)
  Future<List<Trip>> getRecentTrips({int limit = 10});
  
  /// Search trips by destination or title
  Future<List<Trip>> searchTrips(String query);
  
  /// Sync trips with remote server
  Future<void> syncTrips();
  
  /// Get trips that need to be synced
  Future<List<Trip>> getUnsyncedTrips();
  
  /// Mark trip as synced
  Future<void> markAsSynced(String tripId);
  
  /// Get offline edited trips
  Future<List<Trip>> getOfflineEditedTrips();
}