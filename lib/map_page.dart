import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';

class MapPage extends StatefulWidget {
  final double latitude;
  final double longitude;

  const MapPage({super.key, required this.latitude, required this.longitude});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController; // Google Map controller
  late LatLng selectedPosition; // Selected position
  String selectedAddress = ''; // Selected address

  @override
  void initState() {
    super.initState();
    selectedPosition = LatLng(widget.latitude, widget.longitude);
    _updateAddress(selectedPosition); // Fetch initial address
  }

  void _updateAddress(LatLng position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        setState(() {
          selectedAddress =
              '${placemarks.first.name}, ${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.country}'; // Update address
        });
      }
    } catch (e) {
      log('Error retrieving address: $e');
    }
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      selectedPosition = position; // Update selected position
    });
    _updateAddress(position); // Convert coordinates to address
    log('Selected position: $position'); // Log the selected position
  }

  void _sendLocation() {
    log('Sending location: $selectedPosition'); // Log the position to be sent back
    Get.back(
        result: selectedPosition); // Send the position back instead of the address
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _sendLocation,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blueAccent),
            ),
            margin: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selected Address:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text(
                  selectedAddress.isNotEmpty
                      ? selectedAddress
                      : 'Tap on the map to select an address',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.latitude, widget.longitude),
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('currentLocation'),
                  position: selectedPosition, // Use selected position
                ),
              },
              onTap: _onMapTapped, // Update onTap to use the method
            ),
          ),
        ],
      ),
    );
  }
}
