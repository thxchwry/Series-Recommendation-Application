import 'package:admin/home_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SeriesWesternUpdate extends StatefulWidget {
  final int id;

  const SeriesWesternUpdate({super.key, required this.id});

  @override
  State<StatefulWidget> createState() {
    return SeriesWesternUpdateState();
  }
}

class SeriesWesternUpdateState extends State<SeriesWesternUpdate> {
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

  // สีประจำธีม
  final Color customPink = const Color.fromARGB(255, 233, 184, 215);

  @override
  void initState() {
    super.initState();
    _fetchSeries();
  }

  Future<void> _fetchSeries() async {
    final url =
        Uri.parse('https://api-application-blond.vercel.app/serieswestern/${widget.id}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final seriesData = jsonDecode(response.body)[0];
      _loadSeriesData(seriesData);
    } else {
      _showSnackBar('Failed to fetch data', Colors.redAccent);
    }
  }

  void _loadSeriesData(Map<String, dynamic> seriesData) {
    _nameController.text = seriesData['name'] ?? '';
    _poster1Controller.text = seriesData['poster1'] ?? '';
    _poster2Controller.text = seriesData['poster2'] ?? '';
    _detailController.text = seriesData['detail'] ?? '';
    _epController.text = seriesData['ep'] ?? '';
    _applicationController.text = seriesData['application'] ?? '';
    _actorController.text = seriesData['actor'] ?? '';
    _actorpictureController.text = seriesData['actorpicture'] ?? '';
    _actressController.text = seriesData['actress'] ?? '';
    _actresspictureController.text = seriesData['actresspicture'] ?? '';
    _support1Controller.text = seriesData['support1'] ?? '';
    _supportpicture1Controller.text = seriesData['supportpicture1'] ?? '';
    _support2Controller.text = seriesData['support2'] ?? '';
    _supportpicture2Controller.text = seriesData['supportpicture2'] ?? '';
    setState(() {});
  }

  Future<void> _update() async {
    final url = Uri.parse('https://api-application-blond.vercel.app/serieswestern/');
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
      'supportpicture2': _supportpicture2Controller.text,
      'id': widget.id,
    });

    final res = await http.put(url, headers: headers, body: body);
    if (!mounted) return;
    if (res.statusCode == 200 || res.statusCode == 201) {
      _showSnackBar('Update Success ✨', customPink);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      _showSnackBar('Error Updating', Colors.redAccent);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
    ));
  }

  // ตัวช่วยสร้างสไตล์ช่องกรอกข้อมูล
  InputDecoration _buildInputDeco(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: customPink),
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey[200]!)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: customPink, width: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Series', style: TextStyle(fontWeight: FontWeight.bold)),
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
                    Icon(Icons.edit_note_rounded, size: 60, color: customPink),
                    const SizedBox(height: 10),
                    const Text(
                      'Update Korean Series',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // --- ข้อมูลทั่วไป ---
              TextFormField(
                controller: _nameController,
                decoration: _buildInputDeco('Name of Series', Icons.movie_edit),
                validator: (value) => (value == null || value.isEmpty) ? 'Please enter name' : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _poster1Controller,
                decoration: _buildInputDeco('Vertical Picture URL', Icons.image_outlined),
                validator: (value) => (value == null || value.isEmpty) ? 'Please enter URL' : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _poster2Controller,
                decoration: _buildInputDeco('Horizontal Picture URL', Icons.panorama_outlined),
                validator: (value) => (value == null || value.isEmpty) ? 'Please enter URL' : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _detailController,
                maxLines: 3,
                decoration: _buildInputDeco('Detail', Icons.description_outlined),
                validator: (value) => (value == null || value.isEmpty) ? 'Please enter detail' : null,
              ),
              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _epController,
                      decoration: _buildInputDeco('EP', Icons.numbers_rounded),
                      validator: (value) => (value == null || value.isEmpty) ? 'Enter EP' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _applicationController,
                      decoration: _buildInputDeco('App', Icons.tv_rounded),
                      validator: (value) => (value == null || value.isEmpty) ? 'Enter App' : null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 20),

              // --- ส่วนนักแสดง ---
              TextFormField(controller: _actorController, decoration: _buildInputDeco('Actor Name', Icons.person)),
              const SizedBox(height: 15),
              TextFormField(controller: _actorpictureController, decoration: _buildInputDeco('Actor Picture URL', Icons.link)),
              const SizedBox(height: 15),
              TextFormField(controller: _actresspictureController, decoration: _buildInputDeco('Actress Picture URL', Icons.link)),
              const SizedBox(height: 15),
              
              const Divider(),
              const SizedBox(height: 20),

              // --- ส่วนนักแสดงสมทบ ---
              TextFormField(controller: _support1Controller, decoration: _buildInputDeco('Support 1', Icons.people_outline)),
              const SizedBox(height: 15),
              TextFormField(controller: _supportpicture1Controller, decoration: _buildInputDeco('Support Pic 1 URL', Icons.link)),
              const SizedBox(height: 15),
              TextFormField(controller: _supportpicture2Controller, decoration: _buildInputDeco('Support Pic 2 URL', Icons.link)),

              const SizedBox(height: 40),
              
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
                      _update();
                    }
                  },
                  child: const Text('EDIT & SAVE', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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