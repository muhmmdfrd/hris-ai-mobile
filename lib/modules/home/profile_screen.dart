import 'package:flutter/material.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil'), backgroundColor: Colors.deepPurple),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.feedback, color: Colors.deepPurple),
            title: const Text('Isi Feedback'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigasi ke form feedback
            },
          ),
        ],
      ),
    );
  }
}
