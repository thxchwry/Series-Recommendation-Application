import 'package:flutter/material.dart';
import 'login_screen.dart'; // อย่าลืม import หน้า Login

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // ตั้งเวลาหน่วง 2 วินาที แล้วให้เปลี่ยนไปหน้า Login
    Future.delayed(const Duration(seconds: 2), () {
      // ใช้ pushReplacement เพื่อไม่ให้กดย้อนกลับมาหน้า Splash ได้
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor:  Color.fromARGB(255, 233, 184, 215), // เปลี่ยนสีพื้นหลังตามต้องการ
      body: Center(
        child: Text(
          'IN3VERT', // ใส่โลโก้ หรือ ชื่อแอปของคุณ
          style: TextStyle(
            fontSize: 49, 
            fontWeight: FontWeight.bold, 
            color:  Color.fromARGB(255, 42, 40, 42)
          ),
        ),
      ),
    );
  }
}