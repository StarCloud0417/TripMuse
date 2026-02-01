import 'package:flutter_test/flutter_test.dart';
import 'package:tripmuse/core/models/models.dart';

void main() {
  group('Destination', () {
    test('should create destination from valid data', () {
      const destination = Destination(
        name: '台北, 台灣',
        city: '台北',
        country: '台灣',
        lat: 25.0330,
        lng: 121.5654,
        placeId: 'test-place-id',
      );

      expect(destination.name, equals('台北, 台灣'));
      expect(destination.city, equals('台北'));
      expect(destination.country, equals('台灣'));
      expect(destination.lat, equals(25.0330));
      expect(destination.lng, equals(121.5654));
      expect(destination.placeId, equals('test-place-id'));
    });

    test('should serialize to JSON correctly', () {
      const destination = Destination(
        name: '台北, 台灣',
        city: '台北',
        country: '台灣',
        lat: 25.0330,
        lng: 121.5654,
      );

      final json = destination.toJson();

      expect(json['name'], equals('台北, 台灣'));
      expect(json['city'], equals('台北'));
      expect(json['country'], equals('台灣'));
      expect(json['lat'], equals(25.0330));
      expect(json['lng'], equals(121.5654));
      expect(json['placeId'], isNull);
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'name': '台北, 台灣',
        'city': '台北',
        'country': '台灣',
        'lat': 25.0330,
        'lng': 121.5654,
        'placeId': 'test-place-id',
      };

      final destination = Destination.fromJson(json);

      expect(destination.name, equals('台北, 台灣'));
      expect(destination.city, equals('台北'));
      expect(destination.country, equals('台灣'));
      expect(destination.lat, equals(25.0330));
      expect(destination.lng, equals(121.5654));
      expect(destination.placeId, equals('test-place-id'));
    });
  });

  group('Coordinates', () {
    test('should create coordinates from valid data', () {
      const coordinates = Coordinates(lat: 25.0330, lng: 121.5654);

      expect(coordinates.lat, equals(25.0330));
      expect(coordinates.lng, equals(121.5654));
    });

    test('should serialize and deserialize correctly', () {
      const coordinates = Coordinates(lat: 25.0330, lng: 121.5654);
      final json = coordinates.toJson();
      final deserialized = Coordinates.fromJson(json);

      expect(deserialized.lat, equals(coordinates.lat));
      expect(deserialized.lng, equals(coordinates.lng));
    });
  });
}