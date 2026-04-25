import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admin_profile.dart'; 
import 'login_screen.dart';
import 'serieskorean.dart'; 
import 'serieschinese.dart'; 
import 'serieswestern.dart'; 
import 'admin_create.dart';
 

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final Color customPink = const Color.fromARGB(255, 233, 184, 215);

  // ฟังก์ชันสำหรับแสดง Dialog ยืนยันการออกจากระบบ
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Confirm log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text('Log Out', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white, // พื้นหลังแอปสีขาวสะอาด
        appBar: AppBar(
          backgroundColor: customPink, // ใช้สีชมพูของคุณ
          elevation: 0,
          title: const Text(
            'HOME',
            style: TextStyle(color: Color.fromARGB(255, 42, 40, 42), fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.face_retouching_natural, color: Color.fromARGB(255, 42, 40, 42)), // ไอคอนน่ารักขึ้น
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminProfile()),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.power_settings_new, color: Color.fromARGB(255, 42, 40, 42)),
              onPressed: () => _showLogoutDialog(context),
            ),
          ],
          bottom: TabBar(
            indicatorColor: Color.fromARGB(255, 42, 40, 42),
            indicatorWeight: 4,
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
            tabs: const [
              Tab(child: Text("Chinese")), 
              Tab(child: Text("Korean")),
              Tab(child: Text("Western")),
            ],
          ),
        ),

        body: const TabBarView(
          children: [
            SeriesChinese(),   
            SeriesKorean(),  
            SeriesWestern(),
          ],
        ),

        // --- ปรับปุ่ม CREATE ให้ดู 'Pop' และน่ารักขึ้น ---
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: customPink,
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30), // ดันขึ้นจากขอบล่าง
          child: ElevatedButton.icon( // ใช้แบบ .icon
            style: ElevatedButton.styleFrom(
              backgroundColor: customPink, // ใช้สีชมพูแทนสีดำเพื่อให้คุมโทน
              foregroundColor: Color.fromARGB(255, 42, 40, 42),
              //minimumSize: const Offset(double.infinity, 55),
              shape: const StadiumBorder(), // ขอบมนเป็นแคปซูล
              elevation: 5,
              shadowColor: customPink,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminCreate()),
              );
            },
            label: const Text(
              'CREATE NEW ADMIN',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
          ),
        ),
      ),
    );
  }
}