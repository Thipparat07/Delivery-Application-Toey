import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; 
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // ใช้เพื่อเก็บค่าของเมนูที่เลือก
  final box = GetStorage();
  int userId = GetStorage().read('userId');
  String Name = GetStorage().read('Name');

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // เปลี่ยนค่าเมนูที่เลือก
    });

    // นำทางไปยังหน้าอื่นตามดัชนีที่เลือก
    switch (index) {
      case 0:
        Get.to(() => ()); // หน้าแรก
        break;
      case 1:
        Get.to(() => ()); // หน้าโปรไฟล์
        break;
      case 2:
        Get.to(() => ()); // หน้าสถานะการจัดส่ง
        break;
      case 3:
        Get.to(() => ()); // หน้าออกจากระบบ
        break;
    }
  }

  Widget _bottomNavItem(IconData icon, String label, int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.white), // ไอคอนเมนู
          onPressed: () => _onItemTapped(index),
          padding: const EdgeInsets.all(0), // ลด padding ของปุ่ม
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 10), // ข้อความใต้ไอคอน
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    log('userId :$userId');
    log('Name :$Name');
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset(
                'asset/images/cover.jpg',
                width: double.infinity, // ปรับขนาดภาพให้เต็มความกว้าง
                height: 300,
                fit: BoxFit.cover, // ปรับภาพให้เต็มพื้นที่
              ),
              Positioned(
                top: 5, // ระยะจากด้านบนของหน้าจอ
                right: 10, // ระยะจากขอบขวาของหน้าจอ
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end, // จัดเรียงเนื้อหาทางด้านขวา
                  children: [
                    Image.asset(
                      'asset/images/logo.png',
                      width: 91,
                      height: 81,
                    ),
                    const Text(
                      'Delivery Application',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A2A5A),
                        fontFamily: 'Aleo',
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 10, // ระยะจากด้านบนของหน้าจอ
                left: 10, // ระยะจากขอบซ้ายของหน้าจอ
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // จัดเรียงเนื้อหาทางด้านซ้าย
                  children: [
                    const Text(
                      'สวัสดี',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      Name, // แสดงชื่อผู้ใช้งาน
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 120), // ระยะจากขอบซ้ายและขวา
            child: ElevatedButton.icon(
              onPressed: () {
                // ฟังก์ชันเมื่อกดปุ่ม
              },
              icon: const Icon(Icons.add_box, color: Colors.white),
              label: const Text(
                'สั่งซื้อสินค้า',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF214FC6), // เปลี่ยนสีพื้นหลังของปุ่ม
                minimumSize: const Size(double.infinity, 120), // กำหนดขนาดปุ่มให้เต็มความกว้าง
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(fontSize: 12),
                foregroundColor: Colors.white, // เปลี่ยนสีของข้อความและไอคอนในปุ่ม
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF214FC6), // สีพื้นหลังของ BottomAppBar
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomNavItem(Icons.home, 'หน้าหลัก', 0), // เมนูหน้าหลัก
            _bottomNavItem(Icons.person, 'โปรไฟล์', 1), // เมนูโปรไฟล์
            _bottomNavItem(Icons.local_shipping, 'สถานะการจัดส่ง', 2), // เมนูสถานะการจัดส่ง
            _bottomNavItem(Icons.exit_to_app, 'ออกจากระบบ', 3), // เมนูออกจากระบบ
          ],
        ),
      ),
    );
  }
}
