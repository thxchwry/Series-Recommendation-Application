import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

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

  // สีชมพูที่คุณต้องการ
  final Color customPink = const Color.fromARGB(255, 243, 213, 232);
  final Color appBarPink = const Color.fromARGB(255, 233, 184, 215);

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final response = await http.get(Uri.parse('https://api-application-blond.vercel.app/admin'));

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
          await prefs.setString('admin_name', username);

          if (!mounted) return;
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
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
        title: const Text('Admin Login', style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 42, 40, 42))),
        centerTitle: true,
        backgroundColor: appBarPink, 
        elevation: 0,
      ),
      body: Center( 
        child: SingleChildScrollView( 
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ตกแต่งไอคอนให้ดูซอฟต์ขึ้น
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.lock_person_rounded, size: 80, color: Color.fromARGB(255, 42, 40, 42)),
                ),
                const SizedBox(height: 40),
                
                // ตกแต่งช่อง Username
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: const Icon(Icons.person_outline, color: Color.fromARGB(255, 42, 40, 42)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? 'กรุณากรอก Username' : null,
                ),
                const SizedBox(height: 16),
                
                // ตกแต่งช่อง Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline, color: Color.fromARGB(255, 42, 40, 42)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
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
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
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