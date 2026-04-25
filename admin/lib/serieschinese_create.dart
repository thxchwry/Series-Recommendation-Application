import 'package:admin/home_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class SeriesChineseCreate extends StatefulWidget {
  const SeriesChineseCreate({super.key});

  @override
  State<StatefulWidget> createState() {
    return SeriesChineseCreateState();
  }
}

class SeriesChineseCreateState extends State<SeriesChineseCreate> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _poster1Controller = TextEditingController();
  final TextEditingController _poster2Controller = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final TextEditingController _epController = TextEditingController();
  final TextEditingController _applicationController = TextEditingController();
  final TextEditingController _actorController = TextEditingController();
  final TextEditingController _actorpictureController = TextEditingController();
  final TextEditingController _actressController = TextEditingController();
  final TextEditingController _actresspictureController = TextEditingController();
  final TextEditingController _support1Controller = TextEditingController();
  final TextEditingController _supportpicture1Controller = TextEditingController();
  final TextEditingController _support2Controller = TextEditingController();
  final TextEditingController _supportpicture2Controller = TextEditingController();

  // สีชมพูที่ใช้ในหน้าอื่นๆ
  final Color customPink = const Color.fromARGB(255, 233, 184, 215);

  Future<void> _create() async {
    final url = Uri.parse('https://api-application-blond.vercel.app/serieschinese/');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'name': _nameController.text,
      'poster1': _poster1Controller.text,
      'poster2': _poster2Controller.text,
      'detail': _detailController.text,
      'ep': _epController.text,
      'application': _applicationController.text,
      'actor': _actorController.text,
      'actorpicture': _actorpictureController.text,
      'actress': _actressController.text,
      'actresspicture': _actresspictureController.text,
      'support1': _support1Controller.text,
      'supportpicture1': _supportpicture1Controller.text,
      'support2': _support2Controller.text,
      'supportpicture2': _supportpicture2Controller.text
    });

    final res = await http.post(url, headers: headers, body: body);
    if (!mounted) return; 
    if (res.statusCode == 200 || res.statusCode == 201) {  
      _showSnackBar('Create Success');  
      Navigator.pushReplacement( 
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      _showSnackBar('Error creating user');  
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: customPink,
      duration: const Duration(seconds: 2),
    ));
  }
  
  // ตัวช่วยสร้างสไตล์ InputDecoration ให้ช่องกรอกดูสวยเหมือนกันทุกช่อง
  InputDecoration _buildInputDeco(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: customPink),
      filled: true,
      fillColor: Colors.grey[50],
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: customPink, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('New Series', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: customPink,
        foregroundColor: const Color.fromARGB(255, 42, 40, 42),
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(children: [

              Center(
                child: Column(
                  children: [
                    Icon(Icons.movie_creation_outlined, size: 60, color: customPink),
                    const SizedBox(height: 10),
                    Text(
                      'Create Korean Series',
                      style: TextStyle(
                        fontSize: 26, 
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              TextFormField(
                controller: _nameController,
                decoration: _buildInputDeco('Name of Series', Icons.title),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name of series';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _poster1Controller,
                decoration: _buildInputDeco('Vertical Picture (URL)', Icons.image_outlined),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your vertical picture';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _poster2Controller,
                decoration: _buildInputDeco('Horizontal Picture (URL)', Icons.panorama_outlined),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your horizontal picture';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _detailController,
                maxLines: 3, // ขยายช่องให้พิมพ์รายละเอียดได้ง่ายขึ้น
                decoration: _buildInputDeco('Detail', Icons.description_outlined),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your detail';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _epController,
                decoration: _buildInputDeco('EP', Icons.playlist_play),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your ep';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 15),
              
              TextFormField(
                controller: _applicationController,
                decoration: _buildInputDeco('Application', Icons.app_shortcut),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your application';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 25),
              const Divider(), // เส้นคั่นแบ่งหมวดหมู่นักแสดง
              const SizedBox(height: 25),

              TextFormField(
                controller: _actorController,
                decoration: _buildInputDeco('Actor Name', Icons.person),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your actor';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _actorpictureController,
                decoration: _buildInputDeco('Actor Picture (URL)', Icons.link),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your actor picture';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _actressController, // เพิ่ม controller actress
                decoration: _buildInputDeco('Actress Name', Icons.person_3),
                validator: (value) {
                   if (value == null || value.isEmpty) {
                    return 'Please enter your actress';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _actresspictureController,
                decoration: _buildInputDeco('Actress Picture (URL)', Icons.link),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your actress picture';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _support1Controller,
                decoration: _buildInputDeco('Support 1 Name', Icons.people_outline),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your support 1';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _supportpicture1Controller,
                decoration: _buildInputDeco('Support Picture 1 (URL)', Icons.link),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your support picture 1';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _support2Controller, // เพิ่ม controller support 2
                decoration: _buildInputDeco('Support 2 Name', Icons.people_outline),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your support 2';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _supportpicture2Controller,
                decoration: _buildInputDeco('Support Picture 2 (URL)', Icons.link),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your support picture 2';
                  } else {
                    return null;
                  }
                },
              ),

              const SizedBox(height: 30),
              
              SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: customPink,
                        foregroundColor: const Color.fromARGB(255, 42, 40, 42),
                        shape: const StadiumBorder(),
                        elevation: 2,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _create();
                        }
                      },
                      child: const Text('CREATE SERIES', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))))
            ]),
          ),
        ),
      ),
    );
  }
}