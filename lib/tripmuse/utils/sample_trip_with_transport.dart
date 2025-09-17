import '../models/models.dart';

/// 創建包含交通信息的示例行程
class SampleTripWithTransport {
  /// 創建台北一日遊示例行程（包含交通信息）
  static Trip createTaipeiDayTrip() {
    // 創建活動
    final activities = [
      Activity(
        id: 'activity_1',
        name: '台北101',
        description: '世界知名的摩天大樓，可登頂觀景',
        lat: 25.0340,
        lng: 121.5645,
        timeFrom: '09:00',
        timeTo: '11:00',
        category: ActivityCategory.sightseeing,
        priority: ActivityPriority.high,
        estimatedCost: '600元',
        tips: '建議提早購票，避免排隊等候',
      ),
      Activity(
        id: 'activity_2',
        name: '象山步道',
        description: '拍攝台北101的最佳地點，輕鬆的登山步道',
        lat: 25.0235,
        lng: 121.5684,
        timeFrom: '11:30',
        timeTo: '13:00',
        category: ActivityCategory.nature,
        priority: ActivityPriority.medium,
        tips: '穿著舒適的運動鞋，帶足夠的水',
      ),
      Activity(
        id: 'activity_3',
        name: '信義區美食街',
        description: '品嚐台灣在地美食',
        lat: 25.0330,
        lng: 121.5654,
        timeFrom: '13:30',
        timeTo: '14:30',
        category: ActivityCategory.food,
        priority: ActivityPriority.high,
        estimatedCost: '300元',
      ),
      Activity(
        id: 'activity_4',
        name: '國父紀念館',
        description: '緬懷國父孫中山先生，欣賞建築之美',
        lat: 25.0408,
        lng: 121.5598,
        timeFrom: '15:00',
        timeTo: '16:30',
        category: ActivityCategory.culture,
        priority: ActivityPriority.medium,
        tips: '每小時有衛兵交接儀式',
      ),
      Activity(
        id: 'activity_5',
        name: '松山文創園區',
        description: '文創商品展示，創意市集',
        lat: 25.0434,
        lng: 121.5614,
        timeFrom: '17:00',
        timeTo: '18:30',
        category: ActivityCategory.culture,
        priority: ActivityPriority.low,
        estimatedCost: '200元',
      ),
    ];

    // 生成活動之間的交通信息（手動設定更真實的交通方式）
    final transports = <TransportInfo>[
      // 台北101 到 象山步道 - 步行
      TransportInfo(
        mode: TransportMode.walking,
        durationMinutes: 8,
        distanceMeters: 650,
        estimatedCost: null,
      ),
      // 象山步道 到 信義區美食街 - 步行
      TransportInfo(
        mode: TransportMode.walking,
        durationMinutes: 12,
        distanceMeters: 950,
        estimatedCost: null,
      ),
      // 信義區美食街 到 國父紀念館 - 地鐵
      TransportInfo(
        mode: TransportMode.metro,
        durationMinutes: 5,
        distanceMeters: 800,
        estimatedCost: '20元',
      ),
      // 國父紀念館 到 松山文創園區 - 步行
      TransportInfo(
        mode: TransportMode.walking,
        durationMinutes: 6,
        distanceMeters: 450,
        estimatedCost: null,
      ),
    ];

    // 創建日程計畫
    final dayPlan = DayPlan(
      dayIndex: 1,
      date: DateTime.now(),
      theme: '台北都市探索之旅',
      activities: activities,
      transports: transports,
      notes: '輕鬆的台北一日遊，結合自然、文化與美食',
      estimatedTotalCost: '1100元',
    );

    // 創建目的地
    final destination = Destination(
      name: '台北市',
      city: '台北',
      country: '台灣',
      lat: 25.0330,
      lng: 121.5654,
    );

    // 創建行程
    return Trip(
      id: 'taipei_day_trip_with_transport',
      title: '台北一日遊 | 都市探索',
      destination: destination,
      days: [dayPlan],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: TripStatus.draft,
      notes: '包含完整交通信息的台北一日遊行程',
    );
  }

  /// 創建台中兩日遊示例行程
  static Trip createTaichungTwoDayTrip() {
    // 第一天活動
    final day1Activities = [
      Activity(
        id: 'tc_activity_1',
        name: '台中火車站',
        description: '歷史悠久的火車站，台中的交通樞紐',
        lat: 24.1369,
        lng: 120.6839,
        timeFrom: '09:00',
        timeTo: '09:30',
        category: ActivityCategory.transportation,
        priority: ActivityPriority.medium,
      ),
      Activity(
        id: 'tc_activity_2',
        name: '宮原眼科',
        description: '知名的冰淇淋店，復古建築',
        lat: 24.1398,
        lng: 120.6856,
        timeFrom: '10:00',
        timeTo: '11:30',
        category: ActivityCategory.food,
        priority: ActivityPriority.high,
        estimatedCost: '250元',
      ),
      Activity(
        id: 'tc_activity_3',
        name: '台中公園',
        description: '台中市最古老的公園，湖心亭是地標',
        lat: 24.1438,
        lng: 120.6816,
        timeFrom: '12:00',
        timeTo: '13:30',
        category: ActivityCategory.nature,
        priority: ActivityPriority.medium,
      ),
      Activity(
        id: 'tc_activity_4',
        name: '逢甲夜市',
        description: '台灣最大的夜市之一，美食天堂',
        lat: 24.1797,
        lng: 120.6478,
        timeFrom: '18:00',
        timeTo: '21:00',
        category: ActivityCategory.food,
        priority: ActivityPriority.high,
        estimatedCost: '400元',
      ),
    ];

    // 第二天活動
    final day2Activities = [
      Activity(
        id: 'tc_activity_5',
        name: '彩虹眷村',
        description: '充滿彩繪的眷村，藝術與歷史的結合',
        lat: 24.1262,
        lng: 120.6178,
        timeFrom: '09:30',
        timeTo: '11:00',
        category: ActivityCategory.culture,
        priority: ActivityPriority.high,
      ),
      Activity(
        id: 'tc_activity_6',
        name: '高美濕地',
        description: '絕美的夕陽景點，生態豐富的濕地',
        lat: 24.3126,
        lng: 120.5497,
        timeFrom: '15:00',
        timeTo: '18:00',
        category: ActivityCategory.nature,
        priority: ActivityPriority.high,
        tips: '建議下午前往，可欣賞夕陽',
      ),
    ];

    // 第一天的交通信息
    final day1Transports = <TransportInfo>[
      // 台中火車站 到 宮原眼科 - 步行
      TransportInfo(
        mode: TransportMode.walking,
        durationMinutes: 5,
        distanceMeters: 400,
        estimatedCost: null,
      ),
      // 宮原眼科 到 台中公園 - 步行
      TransportInfo(
        mode: TransportMode.walking,
        durationMinutes: 8,
        distanceMeters: 650,
        estimatedCost: null,
      ),
      // 台中公園 到 逢甲夜市 - 大眾運輸
      TransportInfo(
        mode: TransportMode.transit,
        durationMinutes: 25,
        distanceMeters: 4200,
        estimatedCost: '20元',
      ),
    ];

    // 第二天的交通信息
    final day2Transports = <TransportInfo>[
      // 彩虹眷村 到 高美濕地 - 開車
      TransportInfo(
        mode: TransportMode.driving,
        durationMinutes: 35,
        distanceMeters: 18500,
        estimatedCost: '約 150元',
      ),
    ];

    // 創建日程計畫
    final day1Plan = DayPlan(
      dayIndex: 1,
      date: DateTime.now(),
      theme: '台中市區文化探索',
      activities: day1Activities,
      transports: day1Transports,
      notes: '探索台中市區的文化景點和美食',
    );

    final day2Plan = DayPlan(
      dayIndex: 2,
      date: DateTime.now().add(const Duration(days: 1)),
      theme: '自然生態與夕陽之美',
      activities: day2Activities,
      transports: day2Transports,
      notes: '體驗台中的自然美景',
    );

    // 創建目的地
    final destination = Destination(
      name: '台中市',
      city: '台中',
      country: '台灣',
      lat: 24.1477,
      lng: 120.6736,
    );

    return Trip(
      id: 'taichung_two_day_trip_with_transport',
      title: '台中兩日遊 | 文化美食之旅',
      destination: destination,
      days: [day1Plan, day2Plan],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: TripStatus.draft,
      notes: '包含完整交通信息的台中兩日遊行程',
    );
  }



  /// 獲取所有示例行程
  static List<Trip> getAllSampleTrips() {
    return [
      createTaipeiDayTrip(),
      createTaichungTwoDayTrip(),
    ];
  }
}