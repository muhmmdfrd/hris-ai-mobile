import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class MapsScreen extends StatefulWidget {
  final String title;

  const MapsScreen({super.key, required this.title});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  LatLng? _currentLocation;
  // -6.267309422089223, 106.82337488468106
  final LatLng _officeLocation = LatLng(-6.2666, 106.8169);
  final double _radiusInMeter = 100.0;
  bool _isInRadius = false;

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

                  // CARD AT BOTTOM
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
                          const Row(
                            children: [
                              Icon(Icons.camera_alt, size: 48, color: Colors.grey),
                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Absen Masuk',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text('Tanggal dan jam', style: TextStyle(fontSize: 14)),
                                ],
                              ),
                              Spacer(),
                              Icon(Icons.notes, color: Colors.grey),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const SizedBox(width: 60),
                              Text(dateFormatted, style: const TextStyle(fontSize: 14, color: Colors.black)),
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
                                  _isInRadius
                                      ? () {
                                        // TODO: Ambil Foto
                                      }
                                      : null,
                              icon: const Icon(Icons.camera_alt),
                              label: const Text('Ambil foto'),
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
