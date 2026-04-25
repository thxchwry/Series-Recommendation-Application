import 'package:flutter/material.dart';
import 'dart:convert';
import 'serieskorean_detail.dart';
import 'package:http/http.dart' as http;


class SeriesKorean extends StatefulWidget {
  const SeriesKorean({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SeriesKoreanState();
  }
}

class _SeriesKoreanState extends State<SeriesKorean> {
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
    final response = await http.get(Uri.parse('https://api-application-blond.vercel.app/serieskorean'));
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
                          color: Colors.black.withOpacity(0.05),
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
                        fillColor: const Color.fromARGB(255, 225, 223, 223),
                        filled: true,
                      ),
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
                                  builder: (context) => SeriesKoreanDetail(id: series['id']),
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
                                      Text(
                                        'Read more ....',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF4A4A4A),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4), // เพิ่มช่องว่างนิดนึง
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