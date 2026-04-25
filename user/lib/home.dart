import 'package:admin/admin_profile.dart';
import 'package:admin/home_screen.dart';
import 'package:admin/serieschinese.dart';
import 'package:admin/serieswestern.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'serieskorean.dart'; 


class Home extends StatelessWidget {
  const Home({super.key});

  final Color customPink = const Color.fromARGB(255, 233, 184, 215);
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการออกจากระบบ'),
          content: const Text('คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false,
                );
              },
              child: const Text('ออกจากระบบ', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // กำหนดไว้ 3 แท็บ
      child: Scaffold(
        backgroundColor: Colors.white, 
        appBar: AppBar(
          backgroundColor: customPink, 
          elevation: 0,
          title: const Text(
            'HOME', // ชื่อแอปของคุณ
            style: TextStyle(color: Color.fromARGB(255, 42, 40, 42), fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.face_retouching_natural, color: Color.fromARGB(255, 42, 40, 42)), // ไอคอนน่ารักขึ้น
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserProfile()),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.power_settings_new, color: Color.fromARGB(255, 42, 40, 42)),
              onPressed: () => _showLogoutDialog(context),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Color.fromARGB(255, 42, 40, 42),
            indicatorWeight: 4,
            labelColor: Color.fromARGB(255, 42, 40, 42),
            unselectedLabelColor: Color.fromARGB(255, 100, 100, 100),
            tabs: [
              Tab(text: "Chinese"), 
              Tab(text: "Korean"),
              Tab(text: "Western"),
            ],
          ),
        ),

        // แก้ไข: ใส่ลูกให้ครบ 3 ตัวตามค่า length: 3 เพื่อไม่ให้หน้าจอขาว
        body: const TabBarView(
          children: [
            SeriesChinese(),   
            SeriesKorean(),
            SeriesWestern(),
          ],
        ),
      ),
    );
  }
}