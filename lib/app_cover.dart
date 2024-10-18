import 'package:flutter/material.dart';
import 'package:flutter_delivery_1/login.dart';
import 'package:get/get.dart'; // เพิ่ม import สำหรับ get

class AppCover extends StatelessWidget {
  const AppCover({super.key});

  @override
  Widget build(BuildContext context) {
    // รอเวลา 3 วินาทีแล้วนำทางไปยังหน้าล็อกอิน
    Future.delayed(const Duration(seconds: 3), () {
      Get.off(const Login()); // ใช้ Get.off แทนการนำทาง
    });

    return Scaffold(
      body: Container(
        color: const Color(0xFF0C1C8D),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // จัดให้อยู่ตรงกลางแนวตั้ง
            children: [
              Image.asset(
                'asset/images/logo.png', 
                width: 223, 
                height: 230,
              ),
              Transform.translate(
                offset: const Offset(0, -40), 
                child: const Text(
                  'Delivery Application',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFFE400),
                    fontFamily: 'Aleo',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
