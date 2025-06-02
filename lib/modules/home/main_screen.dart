import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final today = Jiffy.parse('2025-06-02'); // kamu bisa sesuaikan ke Jiffy.now()

    return Scaffold(
      appBar: AppBar(
        title: const Text('Absensi'),
        backgroundColor: Colors.deepPurple,
        leading: const BackButton(color: Colors.white),
        actions: const [
          Padding(padding: EdgeInsets.only(right: 16.0), child: Icon(Icons.assignment_turned_in, color: Colors.white)),
        ],
      ),
      body: Column(children: [_buildTodayCard(today)]),
    );
  }

  Widget _buildTodayCard(Jiffy today) {
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
        children: [
          Text(formattedDay, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Text('08:00 - 17:00', style: TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Masuk', style: TextStyle(color: Colors.green)),
              const Text('07:25', style: TextStyle(color: Colors.black)),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: handle check-out
                },
                icon: const Icon(Icons.logout),
                label: const Text('Keluar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Durasi kehadiran', style: TextStyle(fontSize: 14)),
          const SizedBox(height: 4),
          const Text('03 : 00', style: TextStyle(fontSize: 32, color: Colors.green, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
