import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});
  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  // กำหนดสีชมพูพาสเทลให้นุ่มนวล
  final Color pastelPink = const Color.fromARGB(255, 255, 230, 240);
  final Color deepPastelPink = const Color.fromARGB(255, 233, 184, 215);

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? myName = prefs.getString('admin_name');

      final response = await http.get(Uri.parse('https://api-application-blond.vercel.app/admin'));
      if (response.statusCode == 200) {
        List<dynamic> users = json.decode(response.body);
        setState(() {
          userData = users.firstWhere((u) => u['username'] == myName, orElse: () => null);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // พื้นหลังไล่เฉดสีชมพูอ่อน
      backgroundColor: pastelPink,
      appBar: AppBar(
        title: const Text('Admin Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.brown[700], // สีตัวอักษรให้ออกโทนอุ่น
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: deepPastelPink))
          : userData == null
              ? const Center(child: Text('ไม่พบข้อมูลโปรไฟล์ 🥺'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // --- ส่วนรูปโปรไฟล์ ---
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: deepPastelPink,
                            child: const Icon(Icons.person, size: 60, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // --- รายการข้อมูล (ใช้การตกแต่งแบบนุ่มฟูแทน Card) ---
                        _buildProfileItem('Name', (userData!['fname'] ?? '-') + " " + (userData!['lname'] ?? '-'), Icons.face_rounded),
                        _buildProfileItem('Username', userData!['username'] ?? '-', Icons.alternate_email_rounded),
                        _buildProfileItem('Email', userData!['email'] ?? 'ไม่มีข้อมูล', Icons.mail_outline_rounded),
                        _buildProfileItem('Phone', userData!['phone'] ?? 'ไม่มีข้อมูล', Icons.phone_android_rounded),
                        
                        const SizedBox(height: 20),
                        Icon(Icons.auto_awesome, color: deepPastelPink, size: 30), // เพิ่มไอคอนวิ้งๆ ตกแต่ง
                      ],
                    ),
                  ),
                ),
    );
  }

  // Widget สำหรับสร้างรายการข้อมูลแต่ละช่อง
  Widget _buildProfileItem(String title, String subtitle, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25), // ขอบมนๆ ดูนุ่มนวล
        boxShadow: [
          BoxShadow(
            color: deepPastelPink.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: pastelPink,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: deepPastelPink),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 17, color: Colors.brown[800], fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}