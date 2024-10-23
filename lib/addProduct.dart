import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'เพิ่มข้อมูลสินค้า',
      home: AddProductPage(),
    );
  }
}

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  String _productName = '';
  String _productDescription = '';
  File? _image;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> _takePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }
Future<void> _addProduct() async {
  if (_formKey.currentState!.validate() && _image != null) {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.0.2.2:3000/add/products'), // เปลี่ยน URL เป็น API ของคุณ
    );

    request.fields['name'] = _productName;
    request.fields['description'] = _productDescription;

    // เพิ่มไฟล์รูปภาพไปยังคำขอ
    request.files.add(await http.MultipartFile.fromPath(
      'image', // ชื่อฟิลด์ที่ API คาดหวัง
      _image!.path,
      contentType: MediaType('image', 'jpeg'), // เปลี่ยนตามประเภทไฟล์ที่คุณอัปโหลด
    ));

    try {
      final response = await request.send();

      if (response.statusCode == 201) {
        final responseData = await response.stream.toBytes();
        final responseString = utf8.decode(responseData); // แปลงข้อมูลที่ได้รับเป็นข้อความ

        log('เพิ่มสินค้าเรียบร้อยแล้ว: $responseString');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เพิ่มสินค้าเรียบร้อยแล้ว')),
        );
      } else {
        log('เกิดข้อผิดพลาดในการเพิ่มสินค้า: ${response.reasonPhrase}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาดในการเพิ่มสินค้า')),
        );
      }
    } catch (e) {
      log('ข้อผิดพลาดในการเชื่อมต่อ: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ข้อผิดพลาดในการเชื่อมต่อ')),
      );
    }
  } else {
    if (_image == null) {
      log('กรุณาเลือกรูปภาพ');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรุณาเลือกรูปภาพ')),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลสินค้า'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'ชื่อสินค้า'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกชื่อสินค้า';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _productName = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'รายละเอียดสินค้า'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกรายละเอียดสินค้า';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _productDescription = value;
                  });
                },
              ),
              SizedBox(height: 20),
              // แสดงรูปภาพที่เลือกหรือถ่าย
              _image != null
                  ? Image.file(
                      _image!,
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    )
                  : Text('ไม่มีภาพที่เลือก'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('เลือกรูปภาพ'),
                  ),
                  ElevatedButton(
                    onPressed: _takePhoto,
                    child: Text('ถ่ายรูป'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addProduct,
                child: Text('เพิ่มสินค้า'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
