import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  String _nama = '-';
  String _email = '-';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nama = prefs.getString('employee_name') ?? '-';
      _email = prefs.getString('employee_email') ?? '-';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            color: Colors.deepPurple,
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 36, color: Colors.deepPurple),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_nama, style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                    Text(_email, style: const TextStyle(fontSize: 14, color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Menu List
          Expanded(
            child: ListView(
              children: [
                _buildMenuItem(icon: Icons.person_outline, label: 'Informasi personal', onTap: () {}),
                _buildMenuItem(icon: Icons.apartment_outlined, label: 'Informasi kepegawaian', onTap: () {}),
                _buildMenuItem(icon: Icons.swap_horizontal_circle_outlined, label: 'Riwayat mutasi', onTap: () {}),
                _buildMenuItem(icon: Icons.warning_amber_outlined, label: 'Riwayat SP', onTap: () {}),
                _buildMenuItem(icon: Icons.insert_drive_file_outlined, label: 'File saya', onTap: () {}),
                _buildMenuItem(icon: Icons.lock_outline, label: 'Ubah password', onTap: () {}),
                _buildMenuItem(icon: Icons.pin_outlined, label: 'Ubah PIN', onTap: () {}),
                _buildMenuItem(
                  icon: Icons.star,
                  label: 'Kirim Feedback',
                  onTap: () {
                    Navigator.pushNamed(context, '/feedback');
                  },
                ),
                const Divider(),
                _buildMenuItem(
                  icon: Icons.logout,
                  label: 'Logout',
                  color: Colors.red,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            title: const Text('Keluar Aplikasi'),
                            content: const Text('Apakah Anda yakin ingin logout?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Batal', style: TextStyle(color: Colors.black)),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  final prefs = await SharedPreferences.getInstance();
                                  await prefs.clear();
                                  Navigator.pushNamedAndRemoveUntil(context, '/auth', (_) => false);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Logout'),
                              ),
                            ],
                          ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.grey,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
