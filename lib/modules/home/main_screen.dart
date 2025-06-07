import 'package:flutter/material.dart';
import 'package:hris_ai/http/api_client.dart';
import 'package:hris_ai/modules/maps/maps_screen.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? checkIn;
  String? checkOut;
  String? duration;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTodayAttendance();
  }

  Future<void> _loadTodayAttendance() async {
    setState(() => isLoading = true);

    try {
      final response = await ApiClient().dio.get('/attendance/recent');

      if (response.statusCode == 200 && response.data['attendances'] is List) {
        final List attendances = response.data['attendances'];
        final String todayDate = Jiffy.now().format(pattern: 'yyyy-MM-dd');

        final todayData = attendances.cast<Map<String, dynamic>>().firstWhere(
          (item) => item['date'] == todayDate,
          orElse: () => {},
        );

        String? localCheckIn;
        String? localCheckOut;
        String? calculatedDuration;

        if (todayData.isNotEmpty && todayData['check_in_time'] != null) {
          final date = todayData['date'];
          final checkInTime = todayData['check_in_time'];
          final checkOutTime = todayData['check_out_time'];

          // Ubah ke lokal (WIB)
          localCheckIn = _formatToLocalTime(date, checkInTime);
          if (checkOutTime != null) {
            localCheckOut = _formatToLocalTime(date, checkOutTime);
          }

          // Hitung durasi
          final checkInDateTime = DateTime.parse('$date $checkInTime').add(const Duration(hours: 7));
          final now = DateTime.now();

          if (checkOutTime != null) {
            final checkOutDateTime = DateTime.parse('$date $checkOutTime').add(const Duration(hours: 7));
            final diff = checkOutDateTime.difference(checkInDateTime);
            calculatedDuration = _formatDuration(diff);
          } else {
            final diff = now.difference(checkInDateTime);
            calculatedDuration = _formatDuration(diff);
          }
        }

        setState(() {
          checkIn = localCheckIn;
          checkOut = localCheckOut;
          duration = calculatedDuration;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal mengambil data absen: $e')));
    }
  }

  /// Format durasi ke "HH:mm"
  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  String _formatToLocalTime(String date, String time) {
    try {
      final input = DateTime.parse('$date $time');
      final wib = input.add(const Duration(hours: 7)); // Tambah 7 jam (WIB)
      return DateFormat.Hm().format(wib); // Format ke "HH:mm"
    } catch (e) {
      return '--:--';
    }
  }

  Future<void> _navigateAndRefresh(Widget page) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    // Jika dari MapsScreen kembali, refresh data
    if (result == true) {
      _loadTodayAttendance();
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = Jiffy.now();
    final formattedDay = today.format(pattern: 'EEEE, dd MMMM yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Absensi', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _loadTodayAttendance,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(formattedDay, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const Text('08:00 - 17:00', style: TextStyle(fontSize: 14, color: Colors.grey)),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  ElevatedButton(
                                    onPressed:
                                        () =>
                                            checkIn != null
                                                ? null
                                                : _navigateAndRefresh(const MapsScreen(title: 'Absen Masuk')),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.all(20),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    child: const Icon(Icons.login, size: 28, color: Colors.white),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(checkIn ?? '--:--', style: const TextStyle(fontSize: 14, color: Colors.black)),
                                ],
                              ),
                              Column(
                                children: [
                                  ElevatedButton(
                                    onPressed:
                                        () =>
                                            checkOut != null
                                                ? null
                                                : _navigateAndRefresh(const MapsScreen(title: 'Absen Keluar')),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.all(20),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    child: const Icon(Icons.logout, size: 28, color: Colors.white),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(checkOut ?? 'Belum keluar', style: TextStyle(fontSize: 14, color: Colors.black)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          Center(
                            child: Column(
                              children: [
                                const Text('Durasi kehadiran', style: TextStyle(fontSize: 14)),
                                const SizedBox(height: 4),
                                Text(
                                  duration ?? '-- : --',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
