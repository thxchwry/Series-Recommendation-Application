import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart'; // แก้ไข: Import หน้า Home (User) แทน HomeScreen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  final Color customPink = const Color.fromARGB(255, 243, 213, 232);
  final Color appBarPink = const Color.fromARGB(255, 233, 184, 215);

  // เพิ่ม dispose เพื่อเคลียร์หน่วยความจำ
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final response = await http.get(Uri.parse('https://api-application-blond.vercel.app/register'));

      if (response.statusCode == 200) {
        final List<dynamic> users = json.decode(response.body);
        final username = _usernameController.text.trim();
        final password = _passwordController.text.trim();

        var loggedInUser = users.firstWhere(
          (user) => user['username'].toString() == username && user['password'].toString() == password,
          orElse: () => null,
        );

        if (loggedInUser != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          // บันทึก user_name ไว้ใช้แสดงผลในหน้าโปรไฟล์
          await prefs.setString('user_name', username);

          if (!mounted) return;
          
          // แก้ไข: ล็อกอินสำเร็จให้พาไปหน้า Home (หน้าที่มีปุ่ม Profile/Logout)
          Navigator.pushAndRemoveUntil(
            context, 
            MaterialPageRoute(builder: (context) => const Home()),
            (route) => false, // ล้างประวัติการย้อนกลับทั้งหมด
          );
        } else {
          _showSnackBar('Username หรือ Password ไม่ถูกต้อง', Colors.red);
        }
      }
    } catch (e) {
      _showSnackBar('เกิดข้อผิดพลาด: ตรวจสอบการเชื่อมต่ออินเทอร์เน็ต', Colors.orange);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customPink, 
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 42, 40, 42))),
        centerTitle: true,
        backgroundColor: appBarPink, 
        elevation: 0,
        // เพิ่มปุ่มย้อนกลับไปหน้า Guest เผื่อเปลี่ยนใจไม่ล็อกอิน
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color.fromARGB(255, 42, 40, 42)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center( 
        child: SingleChildScrollView( 
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.lock_person_rounded, size: 80, color: Color.fromARGB(255, 42, 40, 42)),
                ),
                const SizedBox(height: 40),
                
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: const Icon(Icons.person_outline, color: Color.fromARGB(255, 42, 40, 42)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? 'กรุณากรอก Username' : null,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline, color: Color.fromARGB(255, 42, 40, 42)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? 'กรุณากรอก Password' : null,
                ),
                const SizedBox(height: 40),
                
                _isLoading 
                  ? const CircularProgressIndicator(color: Color.fromARGB(255, 42, 40, 42)) 
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 42, 40, 42),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            elevation: 0,
                          ),
                          onPressed: _login, 
                          child: const Text('LOG IN', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}