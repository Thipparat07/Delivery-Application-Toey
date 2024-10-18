import 'dart:developer';
import 'dart:io'; // For File usage
import 'package:flutter/material.dart';
import 'package:flutter_delivery_1/map_page.dart';
import 'package:get/get.dart'; // Import Get
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart'; // Import Geolocator
import 'package:geocoding/geocoding.dart'; // Import Geocoding
import 'package:permission_handler/permission_handler.dart';

class Registeru extends StatefulWidget {
  const Registeru({super.key});

  @override
  _RegisteruState createState() => _RegisteruState();
}

class _RegisteruState extends State<Registeru> {
  File? _image; // Variable to store selected image
  final _formKey = GlobalKey<FormState>(); // Key for the form
  bool _isPasswordVisible = false; // Password visibility status
  bool _isConfirmPasswordVisible = false; // Confirm password visibility status
  String? _address; // Variable to store address
  bool _isLoading = false; // Variable for loading status
  String? _email; // Variable to store email

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery); // Pick image from gallery

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Store path of the selected image
      });
    }
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null; // GPS not enabled
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      return null; // Permission denied
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high); // Get current position
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (placemarks.isNotEmpty) {
        setState(() {
          _address =
              '${placemarks.first.name}, ${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.country}'; // Update address
        });
      }
    } catch (e) {
      log('Error retrieving address: $e');
    }
  }

  Future<void> _handleGPSCoordinates() async {
    setState(() => _isLoading = true); // Show loading before getting location

    Position? currentPosition =
        await _getCurrentLocation(); // Try to get current location

    if (currentPosition != null) {
      final LatLng? selectedPosition = await Get.to(() => MapPage(
            latitude: currentPosition.latitude,
            longitude: currentPosition.longitude,
          ));

      if (selectedPosition != null) {
        await _getAddressFromLatLng(
            selectedPosition); // Get the address from selected coordinates
        log('Address: $_address');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ไม่สามารถดึงตำแหน่งปัจจุบันได้")),
      );
    }

    setState(() => _isLoading = false); // Hide loading
  }

  Future<void> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      print('Location permission granted');
    } else if (status.isDenied) {
      print('Location permission denied');
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
          onPressed: () =>
              Get.back(), // Use Get to go back to the previous screen
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
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[200], // Background color if no image
                      child: _image != null
                          ? Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            )
                          : Center(
                              child: Image.asset(
                                'asset/images/photo_icon.png', // Icon if no image selected
                                width: 40,
                                height: 40,
                              ),
                            ),
                    ),
                  ),
                ),
                if (_image == null) // Show text only if no image is selected
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
                      decoration: const InputDecoration(
                        labelText: 'Email', // Email field label
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress, // Email keyboard type
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกอีเมล';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'กรุณากรอกอีเมลที่ถูกต้อง'; // Email format validation
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _email = value; // Store email value
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2, // Allow multiple lines
                      readOnly:
                          true, // Make the field read-only, since the address is fetched automatically
                      controller: TextEditingController(
                          text:
                              _address), // Use a TextEditingController to set the address dynamically
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกที่อยู่';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Show loading indicator
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return const Center(
                                child:
                                    CircularProgressIndicator(), // Loading spinner
                              );
                            },
                          );

                          // Get current location
                          Position? currentPosition =
                              await _getCurrentLocation();

                          // Close loading dialog
                          Navigator.of(context).pop();

                          if (currentPosition != null) {
                            final LatLng? selectedPosition =
                                await Get.to(() => MapPage(
                                      latitude: currentPosition.latitude,
                                      longitude: currentPosition.longitude,
                                    ));

                            if (selectedPosition != null) {
                              await _getAddressFromLatLng(
                                  selectedPosition); // Get the address from selected coordinates
                              log('Address: $_address');
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("ไม่สามารถดึงตำแหน่งปัจจุบันได้")),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0C1C8D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'asset/images/Gps.png',
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'GPS Coordinates',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone, // Phone keyboard type
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกหมายเลขโทรศัพท์';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      obscureText:
                          !_isPasswordVisible, // Toggle password visibility
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
                              _isPasswordVisible =
                                  !_isPasswordVisible; // Toggle password visibility
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกรหัสผ่าน';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      obscureText:
                          !_isConfirmPasswordVisible, // Toggle confirm password visibility
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
                                  !_isConfirmPasswordVisible; // Toggle confirm password visibility
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกยืนยันรหัสผ่าน';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Form validation successful
                          // Proceed with registration logic
                          log('Registration successful');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0C1C8D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
