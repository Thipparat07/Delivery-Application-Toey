import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_delivery_1/home_page.dart';
import 'package:flutter_delivery_1/registerR.dart';
import 'package:flutter_delivery_1/registerU.dart';
import 'package:get/get.dart'; // นำเข้า Get
import 'package:http/http.dart' as http; // นำเข้า HTTP
import 'dart:convert'; // สำหรับ jsonEncode

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isPasswordVisible = false;
  bool _isLoading = false; // ตัวแปรสำหรับจัดการสถานะการโหลด
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    setState(() {
      _isLoading = true; // เปลี่ยนสถานะการโหลดเมื่อเริ่มทำงาน
    });

    final response = await http.post(
      Uri.parse(
          'https://api-delivery-application.vercel.app/login'), // เปลี่ยน URL ให้ตรงกับ API ของคุณ
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      // เข้าสู่ระบบสำเร็จ
      final data = jsonDecode(response.body);
      String userType = data['userType']; // สมมติว่า API ส่งข้อมูล UserType
      log('Login successful: ${data['message']}');

      // นำทางตามประเภทผู้ใช้
      if (userType == 'User') {
        // นำทางไปยังหน้า User
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
        Get.to(HomePage()); // เปลี่ยนเป็นหน้าที่เหมาะสมสำหรับ User
      } else if (userType == 'Rider') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
        // นำทางไปยังหน้า Rider
        Get.to(Registerr()); // เปลี่ยนเป็นหน้าที่เหมาะสมสำหรับ Rider
      }
    } else {
      // แสดงข้อผิดพลาด
      final data = jsonDecode(response.body);
      log('Login failed: ${data['message']}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
    }

    setState(() {
      _isLoading = false; // เปลี่ยนสถานะการโหลดเมื่อเสร็จสิ้น
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 70),
            Center(
              child: Image.asset(
                'asset/images/logo.png',
                width: 149,
                height: 155,
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -30),
              child: const Text(
                'Delivery Application',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0C1C8D),
                    fontFamily: 'Aleo'),
              ),
            ),
            const SizedBox(height: 30),

            // ช่องกรอกอีเมล
            TextFormField(
              controller: _emailController, // ใช้ Controller
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // ช่องกรอกรหัสผ่าน
            TextFormField(
              controller: _passwordController, // ใช้ Controller
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),

            // ปุ่ม Sign In
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : _login, // ป้องกันไม่ให้กดปุ่มในขณะที่กำลังโหลด
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A2A5A),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 150, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white) // แสดงตัวโหลดเมื่อกำลังทำงาน
                  : const Text('Sign In'),
            ),
            const SizedBox(height: 40),

            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Or sign in with'),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 60),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      // เข้าสู่ระบบด้วย Google
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    child: Image.asset(
                      'asset/images/google.png',
                      height: 32,
                      width: 32,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      // เข้าสู่ระบบด้วย Facebook
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    child: Image.asset(
                      'asset/images/facebook.png',
                      height: 32,
                      width: 32,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 80),

            // ลิงก์ไปยังหน้าสมัครสมาชิก
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                GestureDetector(
                  onTap: () {
                    // เรียกแสดง Modal Bottom Sheet
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top:
                              Radius.circular(30.0), // ปรับค่ารัศมีของมุมที่นี่
                        ),
                      ),
                      builder: (BuildContext context) {
                        return Container(
                          padding: const EdgeInsets.all(16.0),
                          height: 240, // กำหนดความสูงของป็อปอัป
                          decoration: const BoxDecoration(
                            color: Color(0xFF214FC6), // สีพื้นหลัง
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(
                                  30.0), // ต้องตรงกับค่าที่ตั้งใน shape
                            ),
                          ),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'เลือกประเภทบัญชีที่จะสร้าง',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(
                                          0xFFFFFFFF), // กำหนดสีที่ต้องการที่นี่
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'ผู้ใช้ระบบหรือไรเดอร์',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color(
                                          0xFFFFFFFF), // กำหนดสีที่ต้องการที่นี่
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // ปุ่มสำหรับ User
                                      ElevatedButton(
                                        onPressed: () {
                                          Get.to(
                                              const Registeru()); // นำทางไปยังหน้าสมัคร User
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 80, vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.person,
                                                color: Color(0xFF0C1C8D)),
                                            SizedBox(width: 8),
                                            Text(
                                              'User',
                                              style: TextStyle(
                                                  color: Color(0xFF0C1C8D)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // ปุ่มสำหรับ Rider
                                      ElevatedButton(
                                        onPressed: () {
                                          Get.to(
                                              const Registerr()); // นำทางไปยังหน้าสมัคร Rider
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 80, vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.motorcycle,
                                                color: Color(
                                                    0xFF0C1C8D)), // ใช้ไอคอนมอเตอร์ไซค์
                                            SizedBox(width: 8),
                                            Text(
                                              'Rider',
                                              style: TextStyle(
                                                  color: Color(0xFF0C1C8D)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Positioned(
                                left: 5,
                                top: 6,
                                child: IconButton(
                                  icon: const Icon(Icons.close,
                                      color: Colors.white),
                                  onPressed: () {
                                    Navigator.pop(context); // ปิดป็อปอัป
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Sign up',
                    style: TextStyle(
                      color: Color(0xFF0C1C8D),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
