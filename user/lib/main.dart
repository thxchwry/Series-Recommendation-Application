import 'package:flutter/material.dart';
import 'splash_screen.dart';
 
void main() {
  // 1. เรียกใช้งาน MyApp
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. ให้ MyApp เป็นตัวครอบ MaterialApp เพียงตัวเดียว
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // ปิดแถบ Debug แดงๆ มุมขวาบน (ใส่หรือไม่ใส่ก็ได้)
      home: SplashScreen(), // 3. ตั้งค่าหน้าแรกเป็น SplashScreen
    );
  }
}