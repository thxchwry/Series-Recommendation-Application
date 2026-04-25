import 'package:admin/serieschinese_update.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'serieschinese_detail.dart';
import 'serieschinese_create.dart';
import 'package:http/http.dart' as http;


class SeriesChinese extends StatefulWidget {
  const SeriesChinese({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SeriesChineseState();
  }
}

class _SeriesChineseState extends State<SeriesChinese> {
  // เก็บข้อมูลที่กรองแล้วสำหรับแสดงผล
  List<dynamic> _series = [];
  // เก็บข้อมูลต้นฉบับทั้งหมด เพื่อไม่ให้ข้อมูลหายตอนลบคำค้นหา
  List<dynamic> _allSeries = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchSeries();
  }

  Future<void> _fetchSeries() async {
    final response = await http.get(Uri.parse('https://api-application-blond.vercel.app/serieschinese'));
    if (response.statusCode == 200) {
      setState(() {
        _allSeries = json.decode(response.body);
        _series = _allSeries; // เริ่มต้นให้แสดงข้อมูลทั้งหมด
      });
    }
  }

  // ฟังก์ชันสำหรับค้นหา (ทำงานทันทีที่พิมพ์)
  void _runFilter(String enteredKeyword) {
    List<dynamic> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allSeries; // ถ้าไม่ได้พิมพ์อะไร ให้แสดงทั้งหมด
    } else {
      // ค้นหาโดยไม่สนใจตัวพิมพ์เล็ก/ใหญ่ (toLowerCase)
      results = _allSeries
          .where((series) => series['name']
              .toString()
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _series = results;
    });
  }

  // ฟังก์ชันสำหรับแสดง Dialog ยืนยันการลบ
  Future<void> _showDeleteConfirmationDialog(int id, String seriesName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // บังคับให้ผู้ใช้ต้องกดปุ่มใดปุ่มหนึ่ง
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: Text('Are you sure to delete '"$seriesName"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCLE', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop(); // ปิด Dialog โดยไม่ทำอะไร
              },
            ),
            TextButton(
              child: const Text('DELETE', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop(); // ปิด Dialog ก่อน
                _delUsers(id); // ค่อยเรียกฟังก์ชันลบข้อมูล
              },
            ),
          ],
        );
      },
    );
  }

  // ปรับการลบให้ลบด้วย ID แทน Index เพื่อป้องกันบั๊กตอนค้นหาแล้วลบข้อมูล
  Future<void> _delUsers(int id) async {
    final url = Uri.parse('https://api-application-blond.vercel.app/serieschinese/');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'id': id});
    
    final res = await http.delete(url, headers: headers, body: body);
    if (res.statusCode == 200 || res.statusCode == 201) {
      setState(() {
        // ลบออกจากทั้ง 2 ลิสต์
        _allSeries.removeWhere((item) => item['id'] == id);
        _series.removeWhere((item) => item['id'] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deleted successfully')),
      );
    } else {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // กำหนดสีประจำตัวแอป (ใช้ค่าความสว่างที่พอดี)
    final Color customPink = const Color.fromARGB(255, 233, 184, 215);

    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          // --- แถวของปุ่ม Search และ Create ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => _runFilter(value),
                      decoration: InputDecoration(
                        hintText: 'Search series...',
                        prefixIcon: Icon(Icons.search, color: customPink),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        fillColor: Colors.grey[50],
                        filled: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SeriesChineseCreate()),
                    ).then((value) => _fetchSeries());
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('CREATE'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customPink,
                    foregroundColor: const Color.fromARGB(255, 60, 60, 60), // ปรับสีตัวอักษรให้เข้มพอดี
                    elevation: 1,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // --- รายการ GridView ---
          Expanded(
            child: _series.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.movie_filter, size: 60, color: customPink),
                        const SizedBox(height: 10),
                        Text('No series found.', style: TextStyle(color: customPink, fontSize: 14)),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6, // ปรับอัตราส่วนให้พอดี
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemCount: _series.length,
                    itemBuilder: (context, index) {
                      final series = _series[index];
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: customPink, // เงาสีชมพูจางๆ จะดูแพงกว่า
                              blurRadius: 10,
                              spreadRadius: 1,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Card(
                          elevation: 0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SeriesChineseDetail(id: series['id']),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Image.network(
                                    series['poster1'],
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => 
                                        Container(
                                          color: Colors.grey[100],
                                          child: const Icon(Icons.broken_image, size: 30, color: Colors.grey),
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        series['name'] ?? 'Untitled',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF4A4A4A),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8), // เพิ่มช่องว่างนิดนึง
                                      
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextButton(
                                              onPressed: () => _showDeleteConfirmationDialog(series['id'], series['name'] ?? 'this series'),
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.red[300],
                                                padding: EdgeInsets.zero,
                                                minimumSize: const Size(0, 30),
                                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              ),
                                              child: const Text('DEL', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => SeriesChineseUpdate(id: series['id']))
                                                ).then((_) => _fetchSeries());
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue[50],
                                                foregroundColor: Colors.blue[600],
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                padding: EdgeInsets.zero,
                                                minimumSize: const Size(0, 30),
                                              ),
                                              child: const Text('EDIT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}