import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SeriesWesternDetail extends StatefulWidget {
  final int id;
  final Color customPink = const Color.fromARGB(255, 233, 184, 215);

  const SeriesWesternDetail({super.key, required this.id});

  @override
  State<StatefulWidget> createState() {
    return _SeriesWesternDetailState();
  }
}

class _SeriesWesternDetailState extends State<SeriesWesternDetail> {
  Map<dynamic, dynamic>? _seriesDetail;

  @override
  void initState() {
    super.initState();
    _fetchSeriesDetail();
  }

  Future<void> _fetchSeriesDetail() async {
    final response = await http.get(
        Uri.parse('https://api-application-blond.vercel.app/serieswestern/${widget.id}'));
    setState(() {
      _seriesDetail = json.decode(response.body)[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // พื้นหลังขาวคลีน
      appBar: AppBar(
        title: const Text('Detail', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: widget.customPink,
        foregroundColor: const Color.fromARGB(255, 42, 40, 42),
        elevation: 0,
      ),
      
      body: _seriesDetail == null
          ? Center(
              child: CircularProgressIndicator(color: widget.customPink),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- ส่วนรูปภาพ Poster ด้านบน ---
                  Stack(
                    children: [
                      ClipRRect(
                        child: Image.network(
                          _seriesDetail!['poster2'],
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // เพิ่ม Gradient ด้านล่างรูปภาพเพื่อให้ข้อความเด่น
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.white],
                          ),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- ชื่อเรื่อง ---
                        Center(
                          child: Text(
                            _seriesDetail!['name'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28, 
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Container(
                            width: 60,
                            height: 4,
                            decoration: BoxDecoration(
                              color: widget.customPink,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24), 
                        
                        // --- เรื่องย่อ ---
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'เรื่องย่อ\n', 
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20, 
                                  color: Colors.grey[800],
                                  height: 2.0,
                                ),
                              ),
                              TextSpan(
                                text: _seriesDetail!['detail'],
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey[600],
                                  height: 1.6,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.justify,
                        ),

                        const SizedBox(height: 20),

                        // --- ข้อมูลเพิ่มเติม (EP & Platform) ---
                        _buildInfoRow(Icons.playlist_add_check_rounded, 'จำนวนตอน : ', '${_seriesDetail!['ep']} ตอน'),
                        const SizedBox(height: 10),
                        _buildInfoRow(Icons.tv_rounded, 'รับชมได้ที่ : ', _seriesDetail!['application']),

                        const SizedBox(height: 30),

                        // --- ส่วนแสดงนักแสดง ---
                        Row(
                          children: [
                            Container(width: 4, height: 20, color: widget.customPink),
                            const SizedBox(width: 8),
                            const Text(
                              "นักแสดง",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildActorItem(_seriesDetail!['actorpicture'], _seriesDetail!['actor']),
                              _buildActorItem(_seriesDetail!['actresspicture'], _seriesDetail!['actress']),
                              _buildActorItem(_seriesDetail!['supportpicture1'], _seriesDetail!['support1']),
                              _buildActorItem(_seriesDetail!['supportpicture2'], _seriesDetail!['support2']),
                            ],
                          ),
                        ),

                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // ตัวช่วยสร้างแถวข้อมูล (Info Row)
  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: widget.customPink, size: 22),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(child: Text(value, style: TextStyle(fontSize: 16, color: Colors.grey[700]))),
        ],
      ),
    );
  }

  Widget _buildActorItem(String imageUrl, String name) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black, blurRadius: 8, offset: const Offset(0, 4)),
              ],
              border: Border.all(color: widget.customPink, width: 2),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(imageUrl),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 90,
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[800]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}