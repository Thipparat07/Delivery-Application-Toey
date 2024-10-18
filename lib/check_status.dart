import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckStatus extends StatefulWidget {
  const CheckStatus({super.key});

  @override
  _CheckStatusState createState() => _CheckStatusState();
}

class _CheckStatusState extends State<CheckStatus> {
  int _selectedIndex = 0; // ใช้เพื่อเก็บค่าของเมนูที่เลือก

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
          style: const TextStyle(
              color: Colors.white, fontSize: 10), // ข้อความใต้ไอคอน
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final String userName = 'Phuri Ngomsaraku';
    final String riderName = 'ชื่อไรเดอร์'; // ชื่อไรเดอร์
    final String riderImage = 'asset/images/rider_image.png'; // รูปไรเดอร์

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // จัดเนื้อหาให้ชิดซ้าย
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
                  crossAxisAlignment:
                      CrossAxisAlignment.end, // จัดเรียงเนื้อหาทางด้านขวา
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
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // จัดเรียงเนื้อหาทางซ้าย
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
                      userName, // แสดงชื่อผู้ใช้งาน
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
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.only(left: 16.0), // ระยะห่างจากขอบซ้าย
            child: Text(
              'ตรวจสอบสถานะการจัดส่ง',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF0A2A5A), // สีข้อความ
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 30), // เพิ่มระยะห่างระหว่างข้อความและส่วนถัดไป

          // กล่องพื้นหลังสีน้ำเงินอ่อน
          Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 16.0), // ระยะห่างจากขอบ
            padding: const EdgeInsets.all(16.0), // ระยะห่างภายในกล่อง
            decoration: BoxDecoration(
              color: const Color(0xFF7FB2FF), // สีพื้นหลัง
              borderRadius: BorderRadius.circular(10), // มุมโค้ง
            ),
            child: Row(
              // เปลี่ยนจาก Column เป็น Row เพื่อให้สามารถจัดวางปุ่มทางด้านขวาได้
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  // ใช้ Expanded เพื่อให้พื้นที่ด้านซ้าย
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // จัดเรียงข้อความทางซ้าย
                    children: [
                      Row(
                        children: [
                          // กล่องแสดงภาพสินค้าที่สั่ง
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(10), // มุมโค้งของกล่องภาพ
                            child: Image.asset(
                              'asset/images/coke.jpg', // ใส่เส้นทางภาพสินค้าที่ต้องการแสดง
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover, // ปรับขนาดภาพให้เต็มพื้นที่
                            ),
                          ),
                          const SizedBox(
                              width: 16), // ระยะห่างระหว่างกล่องภาพและข้อความ
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // จัดเรียงข้อความทางซ้าย
                              children: [
                                const Text(
                                  'ชื่อสินค้า:', // ใส่ชื่อสินค้าที่สั่ง
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                    height: 2), // ลดระยะห่างระหว่างข้อความ
                                const Text(
                                  'รายละเอียดสินค้า:', // ใส่รายละเอียดสินค้าที่สั่ง
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(
                                    height:
                                        20), // เพิ่มระยะห่างระหว่างรายละเอียดสินค้าและรูปไรเดอร์
                                // แสดงรูปไรเดอร์
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          30), // มุมโค้งของรูปไรเดอร์
                                      child: Container(
                                        width: 35,
                                        height: 35,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                'asset/images/โปรไฟล์ไรเดอร์.jpg'), // เปลี่ยนเป็น URL ของรูปไรเดอร์
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                        width:
                                            16), // ระยะห่างระหว่างกล่องภาพไรเดอร์และชื่อไรเดอร์
                                    Expanded(
                                      child: Text(
                                        riderName, // แสดงชื่อไรเดอร์
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // เพิ่มปุ่มตรวจสอบสถานะที่นี่
                ElevatedButton(
                  onPressed: () {
                    Get.snackbar('สถานะ', 'กำลังตรวจสอบสถานะ',
                        snackPosition: SnackPosition.BOTTOM);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD9D9D9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 9,
                        horizontal: 15), // ปรับ padding ตามต้องการ
                  ),
                  child: const Text(
                    'ตรวจสอบสถานะ',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
              height:30), // เพิ่มระยะห่างระหว่างกล่องข้อมูลและ Bottom Navigation Bar
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF214FC6), // สีพื้นหลังของ BottomAppBar
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomNavItem(Icons.home, 'หน้าหลัก', 0), // เมนูหน้าหลัก
            _bottomNavItem(Icons.person, 'โปรไฟล์', 1), // เมนูโปรไฟล์
            _bottomNavItem(Icons.local_shipping, 'สถานะการจัดส่ง',
                2), // เมนูสถานะการจัดส่ง
            _bottomNavItem(
                Icons.exit_to_app, 'ออกจากระบบ', 3), // เมนูออกจากระบบ
          ],
        ),
      ),
    );
  }
}
