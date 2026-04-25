import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'serieskorean.dart'; 
//import 'serieschinese.dart'; 
import 'user_create.dart';
import 'serieschinese.dart'; 
import 'serieswestern.dart'; 
 

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final Color customPink = const Color.fromARGB(255, 233, 184, 215);

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
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserCreate()),
              ),
              child: const Text(
                'Sign up',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 42, 40, 42), // สีเดิมที่คุณใช้
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              ),
              child: const Text(
                'Log in',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 42, 40, 42), // สีเดิมที่คุณใช้
                ),
              ),
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
      ),
    );
  }
}
