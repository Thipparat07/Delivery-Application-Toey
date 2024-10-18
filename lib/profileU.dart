import 'package:flutter/material.dart';
import 'package:get/get.dart'; // นำเข้า Get

class Profileu extends StatelessWidget {
  const Profileu({super.key});

  @override
  Widget build(BuildContext context) {
    // ตัวอย่างข้อมูลผู้ใช้
    final String userName = "John Doe";
    final String phoneNumber = "123-456-7890";
    final String email = "john.doe@example.com";

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(
            'asset/images/icon_back.png',
            width: 25,
            height: 29.32,
          ),
          onPressed: () {
            Get.back(); // ใช้ Get เพื่อกลับไปยังหน้าก่อนหน้า
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // จัดตำแหน่งไปด้านบน
          children: [
            // กล่องสำหรับรูปโปรไฟล์
            Container(
              width: 113,
              height: 113,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(7),
                color: Colors.grey[200], // สีพื้นหลัง
                image: const DecorationImage(
                  image: AssetImage('asset/images/ProfileU.jpg'), // ตรวจสอบที่อยู่ภาพ
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16), // ระยะห่างระหว่างรูปโปรไฟล์และชื่อ
            // ช่องแสดงชื่อผู้ใช้
            _buildInfoContainer(userName),
            const SizedBox(height: 16), // ระยะห่างระหว่างช่อง
            // ช่องแสดงเบอร์โทรศัพท์
            _buildInfoContainer(phoneNumber),
            const SizedBox(height: 16), // ระยะห่างระหว่างช่อง
            // ช่องแสดงอีเมล
            _buildInfoContainer(email),
          ],
        ),
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

  // ฟังก์ชันสำหรับสร้างช่องแสดงข้อมูล
  Widget _buildInfoContainer(String info) {
    return Container(
      width: double.infinity, // กำหนดให้กว้างสุด
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9), // เปลี่ยนให้เป็นสีโค้ดที่คุณต้องการ
        borderRadius: BorderRadius.circular(8), // กำหนดความมนของมุม
      ),
      child: Text(
        info,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black, // สีของข้อมูล
        ), // ขนาดตัวอักษร
        textAlign: TextAlign.left, // จัดข้อความไปทางซ้าย
      ),
    );
  }

  Widget _bottomNavItem(IconData icon, String label, int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.white), // ไอคอนเมนู
          onPressed: () {
            // นำทางไปยังหน้าต่างที่เหมาะสม
            // switch (index) {
            //   case 0:
            //     Get.to(() => HomePage()); // นำไปหน้าหลัก
            //     break;
            //   case 1:
            //     Get.to(() => Profileu()); // นำไปหน้าโปรไฟล์
            //     break;
            //   case 2:
            //     Get.to(() => Container()); // นำไปหน้าสถานะการจัดส่ง
            //     break;
            //   case 3:
            //     Get.to(() => Container()); // นำไปหน้าออกจากระบบ
            //     break;
            // }
          },
          padding: const EdgeInsets.all(0), // ลด padding ของปุ่ม
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 10), // ข้อความใต้ไอคอน
        ),
      ],
    );
  }
}
