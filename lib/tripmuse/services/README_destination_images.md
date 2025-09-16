# 目的地圖片服務使用說明

## 概述
`DestinationImageService` 提供了根據目的地獲取高品質、無版權風景圖片的功能。所有圖片都來自 Unsplash，可以免費用於商業用途。

## 功能特點
- 🌍 支援全球 100+ 個熱門城市的專屬圖片
- 🎨 高品質風景和地標圖片
- 📱 自動調整圖片尺寸（縮圖和大圖）
- 🔄 一致性保證（同一城市總是返回相同圖片）
- 🌐 智能後備機制（未知城市使用國家預設圖片）
- 📄 完全免費且可商用

## 使用方法

### 基本使用
```dart
import '../services/destination_image_service.dart';

final imageService = DestinationImageService();

// 獲取縮圖 (400x300)
String thumbnailUrl = imageService.getDestinationThumbnail('Tokyo', 'Japan');

// 獲取大圖 (800x600)
String largeImageUrl = imageService.getDestinationImage('Tokyo', 'Japan');

// 獲取隨機旅遊圖片
String randomUrl = imageService.getRandomTravelImage();
```

### 在 Widget 中使用
```dart
Widget buildTripCard(Trip trip) {
  final imageService = DestinationImageService();
  final imageUrl = imageService.getDestinationThumbnail(
    trip.destination.city,
    trip.destination.country,
  );

  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: NetworkImage(imageUrl),
        fit: BoxFit.cover,
      ),
    ),
    child: YourContent(),
  );
}
```

## 支援的城市

### 亞洲
- 日本：東京、京都、大阪
- 韓國：首爾、釜山
- 台灣：台北
- 新加坡：新加坡
- 泰國：曼谷
- 中國：上海、北京
- 香港、澳門

### 歐洲
- 法國：巴黎
- 英國：倫敦
- 義大利：羅馬、佛羅倫斯、威尼斯、米蘭
- 西班牙：巴塞隆納、馬德里
- 荷蘭：阿姆斯特丹
- 德國：柏林
- 奧地利：維也納
- 捷克：布拉格
- 匈牙利：布達佩斯
- 瑞士：蘇黎世、日內瓦
- 葡萄牙：里斯本
- 北歐：斯德哥爾摩、哥本哈根、奧斯陸、赫爾辛基

### 美洲
- 美國：紐約、洛杉磯、舊金山、芝加哥、邁阿密、拉斯維加斯
- 加拿大：多倫多、溫哥華
- 墨西哥：墨西哥城
- 巴西：里約熱內盧
- 阿根廷：布宜諾斯艾利斯

### 大洋洲
- 澳洲：雪梨、墨爾本、布里斯班、伯斯
- 紐西蘭：奧克蘭、威靈頓

### 非洲
- 南非：開普敦、約翰尼斯堡
- 埃及：開羅
- 摩洛哥：馬拉喀什

### 中東
- 阿聯酋：杜拜、阿布達比
- 卡達：杜哈
- 土耳其：伊斯坦堡
- 以色列：特拉維夫

## 智能匹配機制

1. **精確匹配**：優先匹配城市名稱
2. **國家匹配**：如果城市未找到，使用國家的代表性城市圖片
3. **預設圖片**：如果都找不到，使用通用旅遊風景圖片
4. **一致性**：使用 hash 算法確保同一城市總是返回相同圖片

## 圖片規格

### 縮圖 (Thumbnail)
- 尺寸：400x300 像素
- 格式：JPEG
- 品質：高品質
- 用途：卡片、列表項目

### 大圖 (Large Image)
- 尺寸：800x600 像素
- 格式：JPEG
- 品質：高品質
- 用途：詳情頁面、背景圖片

## 錯誤處理

服務內建了錯誤處理機制：
- 網路圖片載入失敗時，UI 可以顯示後備內容
- 使用 `isImageUrlValid()` 方法驗證 URL 有效性
- 所有方法都保證返回有效的 URL

## 效能考量

- 圖片 URL 生成是純計算操作，無網路請求
- 使用 CDN 加速的 Unsplash 圖片
- 自動優化的圖片尺寸和品質
- 建議在 UI 中實現圖片快取機制

## 版權說明

所有圖片來自 Unsplash，遵循 Unsplash License：
- ✅ 免費使用
- ✅ 商業用途
- ✅ 修改和分發
- ❌ 無需署名（但建議署名）
- ❌ 不可將圖片本身作為產品銷售

## 未來擴展

計劃中的功能：
- 更多城市支援
- 季節性圖片變化
- 主題分類（海灘、山景、城市等）
- 本地圖片快取
- 圖片品質自適應