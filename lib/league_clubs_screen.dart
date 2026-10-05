import 'package:flutter/material.dart';
import 'formation_screen.dart'; // Sesuaikan jika nama file Anda berbeda

class LeagueClubsScreen extends StatelessWidget {
  final String username;
  final String leagueName;

  // Halaman ini meminta 2 data wajib saat dipanggil: username dan nama liga
  const LeagueClubsScreen({
    super.key,
    required this.username,
    required this.leagueName,
  });

  @override
  Widget build(BuildContext context) {
    // Database sederhana berisi daftar klub untuk masing-masing liga
    final Map<String, List<Map<String, String>>> allClubs = {
      'English League': [
        {'name': 'Manchester Blue', 'stadium': 'Etihad Stadium'},
        {'name': 'Arsenal', 'stadium': 'Emirates Stadium'},
        {'name': 'Manchester Red', 'stadium': 'Old Trafford'},
      ],
      'Spanish League': [
        {'name': 'Real Madrid', 'stadium': 'Santiago Bernabéu'},
        {'name': 'Barcelona', 'stadium': 'Camp Nou'},
      ],
      'Ligue 1': [
        {'name': 'Paris Saint-Germain', 'stadium': 'Parc des Princes'},
        {'name': 'Marseille', 'stadium': 'Stade Vélodrome'},
      ],
      'Italian League': [
        {'name': 'Juventus', 'stadium': 'Allianz Stadium'},
        {'name': 'Inter Milan', 'stadium': 'San Siro'},
      ],
      'Trendyol Süper Lig': [
        {'name': 'Galatasaray', 'stadium': 'RAMS Park'},
        {'name': 'Fenerbahçe', 'stadium': 'Şükrü Saracoğlu'},
      ],
      'English 2nd Division': [{'name': 'Leicester City', 'stadium': 'King Power'}],
      'Spanish 2nd Division': [{'name': 'Espanyol', 'stadium': 'Stage Front'}],
      'Italian 2nd Division': [{'name': 'Parma', 'stadium': 'Ennio Tardini'}],
      
    };

    // Mengambil data klub sesuai liga yang diklik (jika kosong, tampilkan list default)
    final clubsToShow = allClubs[leagueName] ?? [{'name': 'Klub Belum Tersedia', 'stadium': '-'}];

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: Text(
          leagueName, // Judul AppBar otomatis berubah sesuai liga
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0D3269),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: clubsToShow.length,
        itemBuilder: (context, index) {
          final club = clubsToShow[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 15),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: const Icon(Icons.sports_soccer, size: 40, color: Colors.blueGrey),
              title: Text(club['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: Text('Stadion: ${club['stadium']}'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Berpindah ke halaman formasi dengan membawa data klub
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FormationScreen(
                      clubData: club, // Mengirim data klub yang sedang diklik
                      imagePath: '', // Sementara dikosongkan
                    ), 
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}