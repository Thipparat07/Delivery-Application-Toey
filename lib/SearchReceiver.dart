import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SearchReceiverPage extends StatelessWidget {
  final TextEditingController _phoneController = TextEditingController();
  final ProductController productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ค้นหาผู้รับ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'หมายเลขโทรศัพท์',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String phoneNumber = _phoneController.text.trim();
                if (phoneNumber.isNotEmpty) {
                  productController.searchReceiver(phoneNumber);
                } else {
                  Get.snackbar('Error', 'กรุณากรอกหมายเลขโทรศัพท์');
                }
              },
              child: Text('ค้นหา'),
            ),
            SizedBox(height: 16),
            Obx(() {
              if (productController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              if (productController.receivers.isEmpty && !productController.isLoading.value) {
                return Text('ไม่พบผู้รับ');
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: productController.receivers.length,
                  itemBuilder: (context, index) {
                    final receiver = productController.receivers[index];
                    return ListTile(
                      title: Text(receiver.name),
                      subtitle: Text(receiver.phoneNumber),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class ProductController extends GetxController {
  var receivers = <Receiver>[].obs; // Observable list of receivers
  var isLoading = false.obs; // Observable for loading state

  // Function to search for receiver by phone number
  Future<void> searchReceiver(String phoneNumber) async {
    isLoading.value = true; // Set loading state to true
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/api/receivers?phoneNumber=$phoneNumber'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        receivers.value = data.map((receiverJson) => Receiver.fromJson(receiverJson)).toList();
        log(response.body);
      } else {
        Get.snackbar('Error', 'ไม่สามารถค้นหาผู้รับได้');
      }
    } catch (error) {
      Get.snackbar('Error', 'เกิดข้อผิดพลาด: $error');
    } finally {
      isLoading.value = false; // Stop loading when data is fetched
    }
  }
}

// Receiver Model
class Receiver {
  final String name;
  final String phoneNumber;

  Receiver({required this.name, required this.phoneNumber});

  factory Receiver.fromJson(Map<String, dynamic> json) {
    return Receiver(
      name: json['Name'], // ใช้ชื่อคีย์ที่ถูกต้อง
      phoneNumber: json['PhoneNumber'], // ใช้ชื่อคีย์ที่ถูกต้อง
    );
  }
}
