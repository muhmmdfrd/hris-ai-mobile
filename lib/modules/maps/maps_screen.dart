import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hris_ai/http/api_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class MapsScreen extends StatefulWidget {
  final String title;

  const MapsScreen({super.key, required this.title});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  LatLng? _currentLocation;
  final LatLng _officeLocation = LatLng(-6.267309422089223, 106.82337488468106);
  final double _radiusInMeter = 100.0;
  bool _isInRadius = false;
  bool _isSubmitting = false;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
        return;
      }
    }

    final pos = await Geolocator.getCurrentPosition();
    final current = LatLng(pos.latitude, pos.longitude);
    final distance = Geolocator.distanceBetween(
      current.latitude,
      current.longitude,
      _officeLocation.latitude,
      _officeLocation.longitude,
    );

    setState(() {
      _currentLocation = current;
      _isInRadius = distance <= _radiusInMeter;
    });
  }

  Future<void> _ambilFoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 40,
    );

    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateFormatted = DateFormat('dd MMM yyyy | HH:mm:ss').format(now);

    return Scaffold(
      appBar: AppBar(title: Text(widget.title), backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
      body:
          _currentLocation == null
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  FlutterMap(
                    options: MapOptions(center: _currentLocation, zoom: 17),
                    children: [
                      TileLayer(urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png"),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _officeLocation,
                            width: 40,
                            height: 40,
                            child: const Icon(Icons.location_city, size: 36, color: Colors.deepPurple),
                          ),
                          Marker(
                            point: _currentLocation!,
                            width: 40,
                            height: 40,
                            child: const Icon(Icons.person_pin_circle, size: 36, color: Colors.blue),
                          ),
                        ],
                      ),
                      CircleLayer(
                        circles: [
                          CircleMarker(
                            point: _officeLocation,
                            radius: _radiusInMeter,
                            color: Colors.deepPurple.withOpacity(0.2),
                            borderStrokeWidth: 2,
                            useRadiusInMeter: true,
                            borderColor: Colors.deepPurple,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.deepPurple, width: 1.5),
                        boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black26)],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child:
                                    _pickedImage == null
                                        ? const Icon(Icons.camera_alt, size: 48, color: Colors.grey)
                                        : Image.file(_pickedImage!, width: 48, height: 48, fit: BoxFit.cover),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Absen Masuk',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(dateFormatted, style: const TextStyle(fontSize: 14)),
                                ],
                              ),
                              const Spacer(),
                              const Icon(Icons.notes, color: Colors.grey),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (!_isInRadius)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Text(
                                'Anda berada di luar radius absen.',
                                style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                              ),
                            ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed:
                                  (_isInRadius && !_isSubmitting)
                                      ? () async {
                                        if (_pickedImage == null) {
                                          await _ambilFoto();
                                        } else {
                                          setState(() {
                                            _isSubmitting = true;
                                          });

                                          final bytes = await _pickedImage!.readAsBytes();
                                          final base64Photo = base64Encode(bytes);

                                          final requestBody = {
                                            'location_latitude': _currentLocation?.latitude,
                                            'location_longitude': _currentLocation?.longitude,
                                            'photo': base64Photo,
                                          };

                                          try {
                                            final response = await ApiClient().dio.post(
                                              '/attendance/check-in',
                                              data: requestBody,
                                            );

                                            if (response.statusCode == 201) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(const SnackBar(content: Text("Absen berhasil dikirim.")));
                                              setState(() {
                                                _pickedImage = null;
                                              });
                                              Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text("Gagal absen: ${response.statusMessage}")),
                                              );
                                            }
                                          } catch (e) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(SnackBar(content: Text("Terjadi kesalahan: $e")));
                                          } finally {
                                            setState(() {
                                              _isSubmitting = false;
                                            });
                                          }
                                        }
                                      }
                                      : null,
                              icon:
                                  _isSubmitting
                                      ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                      )
                                      : Icon(_pickedImage == null ? Icons.camera_alt : Icons.send),
                              label: Text(
                                _pickedImage == null
                                    ? 'Ambil foto'
                                    : _isSubmitting
                                    ? 'Mengirim...'
                                    : 'Kirim absen',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                disabledBackgroundColor: Colors.grey.shade300,
                                disabledForegroundColor: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
