import 'dart:convert'; // นำเข้าเพื่อแปลงข้อมูล JSON
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_1/model/UesrsDataGetResponse.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class Profileu extends StatefulWidget {
  const Profileu({super.key});

  @override
  _ProfileuState createState() => _ProfileuState();
}

class _ProfileuState extends State<Profileu> {
  @override
  void initState() {
    super.initState();

    fetchUserData();
  }

  // ฟังก์ชันดึงข้อมูลผู้ใช้จาก API
  Future<UesrsDataGetResponse> fetchUserData() async {
    int userId = GetStorage().read('userId');
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3000/users/$userId'));

    if (response.statusCode == 200) {
      return uesrsDataGetResponseFromJson(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(
            'asset/images/icon_back.png',
            width: 25,
            height: 29.32,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'asset/images/logo.png',
                  width: 81,
                  height: 71,
                ),
                Transform.translate(
                  offset: const Offset(0, -15),
                  child: const Text(
                    'Delivery Application',
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0C1C8D),
                      fontFamily: 'Aleo',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        toolbarHeight: 92,
      ),
      body: FutureBuilder<UesrsDataGetResponse>(
        future: fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator()); // รอการดึงข้อมูล
          } else if (snapshot.hasError) {
            // แสดงข้อความข้อผิดพลาดเมื่อเกิดข้อผิดพลาด
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // หากได้ข้อมูลมาแล้ว แสดงข้อมูลใน UI
            final user = snapshot.data!.user;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Image.network(
                      user.profilePicture,
                      width: 113,
                      height: 113,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        return Container(
                          width: 113,
                          height: 113,
                          color: Colors.grey[200],
                          child: const Icon(
                              Icons.error), // แสดงไอคอนเมื่อโหลดภาพล้มเหลว
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoContainer(user.name),
                  const SizedBox(height: 16),
                  _buildInfoContainer(user.phoneNumber),
                  const SizedBox(height: 16),
                  _buildInfoContainer(user.email),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No user data available'));
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF214FC6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomNavItem(Icons.home, 'หน้าหลัก', 0),
            _bottomNavItem(Icons.person, 'โปรไฟล์', 1),
            _bottomNavItem(Icons.local_shipping, 'สถานะการจัดส่ง', 2),
            _bottomNavItem(Icons.exit_to_app, 'ออกจากระบบ', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoContainer(String info) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        info,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _bottomNavItem(IconData icon, String label, int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.white),
          onPressed: () {
            // นำทางไปยังหน้าต่างๆตาม index
          },
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
      ],
    );
  }
}
