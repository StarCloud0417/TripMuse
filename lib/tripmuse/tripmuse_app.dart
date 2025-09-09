import 'package:flutter/material.dart';

/// TripMuse 主應用入口
class TripMuseApp extends StatelessWidget {
  const TripMuseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧳 TripMuse'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map,
              size: 80,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            Text(
              'TripMuse',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'AI 智能旅行規劃助手',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 40),
            Text(
              '功能開發中...',
              style: TextStyle(
                fontSize: 14,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}