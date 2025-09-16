/// 目的地圖片服務測試
/// 
/// 測試目的地圖片服務的各種功能

import 'package:flutter_test/flutter_test.dart';
import '../../lib/tripmuse/services/destination_image_service.dart';

void main() {
  group('DestinationImageService', () {
    late DestinationImageService service;

    setUp(() {
      service = DestinationImageService();
    });

    test('should return valid image URL for known cities', () {
      // 測試知名城市
      final tokyoUrl = service.getDestinationThumbnail('Tokyo', 'Japan');
      final parisUrl = service.getDestinationThumbnail('Paris', 'France');
      final newYorkUrl = service.getDestinationThumbnail('New York', 'USA');

      expect(tokyoUrl, contains('images.unsplash.com'));
      expect(parisUrl, contains('images.unsplash.com'));
      expect(newYorkUrl, contains('images.unsplash.com'));
      
      expect(service.isImageUrlValid(tokyoUrl), isTrue);
      expect(service.isImageUrlValid(parisUrl), isTrue);
      expect(service.isImageUrlValid(newYorkUrl), isTrue);
    });

    test('should return default image for unknown cities', () {
      final unknownUrl = service.getDestinationThumbnail('UnknownCity', 'UnknownCountry');
      
      expect(unknownUrl, contains('images.unsplash.com'));
      expect(service.isImageUrlValid(unknownUrl), isTrue);
    });

    test('should return country default for unknown city but known country', () {
      final japanUrl = service.getDestinationThumbnail('UnknownCity', 'Japan');
      final franceUrl = service.getDestinationThumbnail('UnknownCity', 'France');
      
      expect(japanUrl, contains('images.unsplash.com'));
      expect(franceUrl, contains('images.unsplash.com'));
      expect(service.isImageUrlValid(japanUrl), isTrue);
      expect(service.isImageUrlValid(franceUrl), isTrue);
    });

    test('should return consistent images for same city', () {
      final url1 = service.getDestinationThumbnail('Tokyo', 'Japan');
      final url2 = service.getDestinationThumbnail('Tokyo', 'Japan');
      
      expect(url1, equals(url2));
    });

    test('should return different images for different cities', () {
      final tokyoUrl = service.getDestinationThumbnail('Tokyo', 'Japan');
      final parisUrl = service.getDestinationThumbnail('Paris', 'France');
      
      expect(tokyoUrl, isNot(equals(parisUrl)));
    });

    test('should handle case insensitive city names', () {
      final lowerUrl = service.getDestinationThumbnail('tokyo', 'japan');
      final upperUrl = service.getDestinationThumbnail('TOKYO', 'JAPAN');
      final mixedUrl = service.getDestinationThumbnail('Tokyo', 'Japan');
      
      expect(lowerUrl, equals(upperUrl));
      expect(lowerUrl, equals(mixedUrl));
    });

    test('should return valid random travel image', () {
      final randomUrl = service.getRandomTravelImage();
      
      expect(randomUrl, contains('images.unsplash.com'));
      expect(service.isImageUrlValid(randomUrl), isTrue);
    });

    test('should return large image URL', () {
      final thumbnailUrl = service.getDestinationThumbnail('Tokyo', 'Japan');
      final largeUrl = service.getDestinationImage('Tokyo', 'Japan');
      
      expect(thumbnailUrl, contains('w=400&h=300'));
      expect(largeUrl, contains('w=800&h=600'));
    });
  });
}