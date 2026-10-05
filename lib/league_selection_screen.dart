import 'package:flutter/material.dart';
import 'package:flutter/services.dart';// Menghubungkan ke FootballClubScreen
import 'league_clubs_screen.dart';
import 'main.dart';

class LeagueSelectionScreen extends StatefulWidget {
  final String username; // Menangkap nama dari halaman login

  const LeagueSelectionScreen({super.key, required this.username});

  @override
  State<LeagueSelectionScreen> createState() => _LeagueSelectionScreenState();
}

class _LeagueSelectionScreenState extends State<LeagueSelectionScreen> {
  String selectedRegion = 'Europe';

  // Data Liga yang ditampilkan
  final List<Map<String, dynamic>> leagues = [
    {'name': 'English League', 'color': const Color(0xFF0D3269), 'flag': '🏴󠁧󠁢󠁥󠁮󠁧󠁿'},
    {'name': 'Spanish 2nd Division', 'color': const Color(0xFF004D40), 'flag': '🇪🇸'},
    {'name': 'Ligue 1', 'color': const Color(0xFF1A237E), 'flag': '🇫🇷'},
    {'name': 'English 2nd Division', 'color': const Color(0xFFB71C1C), 'flag': '🏴󠁧󠁢󠁥󠁮󠁧󠁿'},
    {'name': 'Italian League', 'color': const Color(0xFF1565C0), 'flag': '🇮🇹'},
    {'name': 'Trendyol Süper Lig', 'color': Colors.white, 'flag': '🇹🇷', 'textColor': Colors.black},
    {'name': 'Spanish League', 'color': const Color(0xFF1B3B5A), 'flag': '🇪🇸'},
    {'name': 'Italian 2nd Division', 'color': const Color(0xFF880E4F), 'flag': '🇮🇹'},
    {'name': 'Web Developers', 'color': const Color(0xFF424242), 'flag': '💻'},
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  Widget _buildTab(String title, bool isActive) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRegion = title;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue[700] : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isActive ? null : Border.all(color: Colors.grey.shade300),
          boxShadow: isActive ? [BoxShadow(color: Colors.blue.withValues(alpha: 0.3), blurRadius: 5)] : [],
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5), // Background bersih tanpa watermark
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER ---
            const SizedBox(height: 15),
            const Text(
              'Select League',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF000033)),
            ),
            const SizedBox(height: 4),
            const Text(
              'Select a league to play in.',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 15),

            // --- TABS ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTab('Europe', selectedRegion == 'Europe'),
                _buildTab('South America', selectedRegion == 'South America'),
                _buildTab('Asia-Oceania', selectedRegion == 'Asia-Oceania'),
              ],
            ),
            const SizedBox(height: 20),

            // --- GRID LIGA ---
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 kolom ke samping
                    childAspectRatio: 3.5, // Rasio persegi panjang
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: leagues.length,
                  itemBuilder: (context, index) {
                    final league = leagues[index];
                    Color textColor = league['textColor'] ?? Colors.white;

                    return GestureDetector(
                      onTap: () {
  if (league['name'] == 'Web Developers') {
    // Jika yang diklik Web Developers, arahkan ke halaman profil web Anda
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AboutMeScreen(), // Ganti dengan nama class Web Profil Anda
      ),
    );
  } else {
    // Jika yang diklik liga lain, arahkan ke daftar klub seperti biasa
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LeagueClubsScreen(
          username: widget.username,
          leagueName: league['name'], 
        ),
      ),
    );
  }
},
                      child: Container(
                        decoration: BoxDecoration(
                          color: league['color'],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: league['color'] == Colors.white ? Colors.grey.shade300 : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))
                          ],
                        ),
                        child: Row(
                          children: [
                            // Ikon Bendera
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(league['flag'], style: const TextStyle(fontSize: 16)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Nama Liga
                            Expanded(
                              child: Text(
                                league['name'],
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}