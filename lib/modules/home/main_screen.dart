import 'package:flutter/material.dart';
import 'package:hris_ai/modules/maps/maps_screen.dart';
import 'package:jiffy/jiffy.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final today = Jiffy.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Absensi', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(children: [_buildTodayCard(today, context)]),
    );
  }

  Widget _buildTodayCard(Jiffy today, BuildContext context) {
    final formattedDay = today.format(pattern: 'EEEE, dd MMMM yyyy');

    return Container(
      margin: const EdgeInsets.all(16),
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
              // Tombol Masuk
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MapsScreen(title: 'Absen Masuk')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Icon(Icons.login, size: 28, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  const Text('07:25', style: TextStyle(fontSize: 14, color: Colors.black)),
                ],
              ),

              // Tombol Keluar
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MapsScreen(title: 'Absen Keluar')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Icon(Icons.logout, size: 28, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  const Text('Belum keluar', style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Center(
            child: Column(
              children: [
                Text('Durasi kehadiran', style: TextStyle(fontSize: 14)),
                SizedBox(height: 4),
                Text('03 : 00', style: TextStyle(fontSize: 32, color: Colors.deepPurple, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
