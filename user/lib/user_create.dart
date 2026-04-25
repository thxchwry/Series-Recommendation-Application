import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'login_screen.dart';

class UserCreate extends StatefulWidget {
  const UserCreate({super.key});

  @override
  State<StatefulWidget> createState() {
    return UserCreateState();
  }
}

class UserCreateState extends State<UserCreate> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // สีที่ใช้ตกแต่ง (พอประมาณ)
  final Color customPink = const Color.fromARGB(255, 233, 184, 215);

  Future<void> _create() async {
    try {
      final url = Uri.parse('https://api-application-blond.vercel.app/register/');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'fname': _fnameController.text,
        'lname': _lnameController.text,
        'username': _usernameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'password': _passwordController.text
      });

      final res = await http.post(url, headers: headers, body: body);
      
      if (!mounted) return; 

      if (res.statusCode == 200 || res.statusCode == 201) {  
        _showSnackBar('Create user success');  
        
        Navigator.pushAndRemoveUntil( 
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      } else {
        print("Server Error: ${res.body}");
        _showSnackBar('Error: ${res.statusCode} - สร้างไม่ได้');  
      }
    } catch (e) {
      print("Connect Error: $e");
      _showSnackBar('ไม่สามารถเชื่อมต่อกับ Server ได้');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: customPink, // ให้แถบแจ้งเตือนเป็นสีชมพูด้วย
      duration: const Duration(seconds: 2),
    ));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // พื้นหลังขาวสะอาด
      appBar: AppBar(
        title: const Text('Create Account', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: customPink,
        foregroundColor: const Color.fromARGB(255, 42, 40, 42),
        elevation: 0, // AppBar แบบเรียบๆ
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(children: [
              // เพิ่มไอคอนให้ดูมีอะไรนิดนึง
              Icon(Icons.person_add_rounded, size: 80, color: customPink),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Create New Account',
                  style: TextStyle(
                    fontSize: 26, 
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 42, 40, 42),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // ตกแต่ง TextFormField ให้ขอบมนและมีไอคอนหน้าช่อง
              TextFormField(
                controller: _fnameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  prefixIcon: Icon(Icons.person_outline, color: customPink),
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey[200]!)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: customPink, width: 2)),
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'กรุณากรอกชื่อ' : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _lnameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  prefixIcon: Icon(Icons.person_outline, color: customPink),
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey[200]!)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: customPink, width: 2)),
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'กรุณากรอกนามสกุล' : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.badge_outlined, color: customPink),
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey[200]!)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: customPink, width: 2)),
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'กรุณากรอก Username' : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined, color: customPink),
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey[200]!)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: customPink, width: 2)),
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'กรุณากรอก Email' : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  prefixIcon: Icon(Icons.phone_android_rounded, color: customPink),
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey[200]!)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: customPink, width: 2)),
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'กรุณากรอกเบอร์โทรศัพท์' : null,
              ),
              const SizedBox(height: 15),
              
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline_rounded, color: customPink),
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey[200]!)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: customPink, width: 2)),
                ),
                validator: (value) => (value == null || value.length < 6) ? 'รหัสผ่านต้องมี 6 ตัวขึ้นไป' : null,
              ),

              const SizedBox(height: 35),
              
              // ปุ่ม SAVE สไตล์มนแบบ Stadium
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customPink,
                    foregroundColor: const Color.fromARGB(255, 42, 40, 42),
                    shape: const StadiumBorder(), // ทรงแคปซูล
                    elevation: 3,
                    shadowColor: customPink,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _create();
                    }
                  },
                  child: const Text('SAVE', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
            ]),
          ),
        ),
      ),
    );
  }
}