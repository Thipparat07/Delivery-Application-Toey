import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_delivery_1/login.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON access
import 'package:http_parser/http_parser.dart'; // Import MediaType from http_parser

class Registerr extends StatefulWidget {
  const Registerr({super.key});

  @override
  _RegisterrState createState() => _RegisterrState();
}

class _RegisterrState extends State<Registerr> {
  File? _image; // Variable to hold the selected image
  final _formKey = GlobalKey<FormState>(); // Form key
  bool _isPasswordVisible = false; // Password visibility status
  bool _isConfirmPasswordVisible = false; // Confirm password visibility status
  bool _isLoading = false; // Loading status for the button
  
  // TextEditingController to capture form inputs
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _vehicleRegistrationController = TextEditingController();

  Uint8List? _imageBytes; // Variable to store the image bytes

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery); // Pick image from gallery

    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes(); // Read the file as bytes
      setState(() {
        _image = File(pickedFile.path); // Store the file for display
        _imageBytes = imageBytes; // Store the image bytes for sending to API
      });
    }
  }

  Future<void> _register() async {
    log('Register function called');

    // Log input values
    log('Name: ${_nameController.text}');
    log('Email: ${_emailController.text}');
    log('Phone: ${_phoneNumberController.text}');
    log('Password: ${_passwordController.text}');
    log('Vehicle Registration: ${_vehicleRegistrationController.text}');

    // Prepare the request
    final uri = Uri.parse('https://api-delivery-application.vercel.app/register/riders');
    final request = http.MultipartRequest('POST', uri);

    // Add form data
    request.fields['Name'] = _nameController.text;
    request.fields['email'] = _emailController.text;
    request.fields['password'] = _passwordController.text;
    request.fields['phoneNumber'] = _phoneNumberController.text;
    request.fields['vehicleRegistration'] = _vehicleRegistrationController.text;

    // Add image file if selected
    if (_imageBytes != null) {
      log('Image selected, adding to request');
      request.files.add(http.MultipartFile.fromBytes(
        'profilePicture',
        _imageBytes!,
        filename: _image!.path.split('/').last,
        contentType: MediaType('image', 'jpeg'),
      ));
    } else {
      log('No image selected');
    }

    setState(() {
      _isLoading = true; // Set loading state to true
    });

    try {
      final response = await request.send(); // Send request

      if (response.statusCode == 201) {
        log('Registration successful');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("ลงทะเบียนสำเร็จ")),
        );
        Get.to(() => const Login()); // Navigate to login page
      } else {
        log('Registration failed with status code: ${response.statusCode}');
        final responseData = await response.stream.bytesToString();
        log('Error: $responseData');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("เกิดข้อผิดพลาด: $responseData")),
        );
      }
    } catch (e) {
      log('Error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์")),
      );
    } finally {
      setState(() {
        _isLoading = false; // Set loading state to false after request completes
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset('asset/images/icon_back.png', width: 25, height: 29.32),
          onPressed: () {
            Get.off(() => const Login());
          },
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('asset/images/logo.png', width: 81, height: 71),
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
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[200],
                      child: _image != null
                          ? Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            )
                          : Center(
                              child: Image.asset(
                                'asset/images/photo_icon.png',
                                width: 40,
                                height: 40,
                              ),
                            ),
                    ),
                  ),
                ),
                if (_image == null)
                  Transform.translate(
                    offset: const Offset(0, -15),
                    child: const Text(
                      'Add Profile Photo',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกชื่อ';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกเบอร์โทรศัพท์';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกอีเมล';
                        }
                        final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        if (!emailRegExp.hasMatch(value)) {
                          return 'กรุณากรอกอีเมลให้ถูกต้อง';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
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
                      obscureText: !_isPasswordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกรหัสผ่าน';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !_isConfirmPasswordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณายืนยันรหัสผ่าน';
                        }
                        if (value != _passwordController.text) {
                          return 'รหัสผ่านไม่ตรงกัน';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _vehicleRegistrationController,
                      decoration: const InputDecoration(
                        labelText: 'Vehicle Registration',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกเลขทะเบียนรถ';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null // Disable button if loading
                          : () {
                              if (_formKey.currentState!.validate()) {
                                _register();
                              }
                            },
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text('Sign up'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

