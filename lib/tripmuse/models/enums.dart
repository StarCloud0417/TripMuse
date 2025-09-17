/// TripMuse 應用的列舉類型定義
/// 
/// 包含活動類別、優先級、旅行節奏等核心列舉類型

/// 活動類別
enum ActivityCategory {
  food('美食'),
  sightseeing('觀光'),
  culture('文化'),
  nature('自然'),
  shopping('購物'),
  outdoor('戶外'),
  transportation('交通');

  const ActivityCategory(this.displayName);
  final String displayName;
}

/// 活動優先級
enum ActivityPriority {
  high('高'),
  medium('中'),
  low('低');

  const ActivityPriority(this.displayName);
  final String displayName;
}

/// 旅行節奏
enum TravelPace {
  slow('放鬆'),
  medium('適中'),
  fast('緊湊');

  const TravelPace(this.displayName);
  final String displayName;
}

/// 預算範圍
enum BudgetRange {
  low('經濟'),
  mid('中等'),
  high('豪華');

  const BudgetRange(this.displayName);
  final String displayName;
}

/// 旅行風格
enum TravelStyle {
  leisure('休閒'),
  adventure('冒險'),
  cultural('文化'),
  business('商務');

  const TravelStyle(this.displayName);
  final String displayName;
}

/// 交通方式
enum TransportMode {
  walking('步行'),
  driving('開車'),
  transit('大眾運輸'),
  cycling('騎車'),
  taxi('計程車'),
  metro('地鐵');

  const TransportMode(this.displayName);
  final String displayName;
}