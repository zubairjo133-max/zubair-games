import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'stadium_screen.dart';

class FormationScreen extends StatefulWidget {
  final Map<String, dynamic> clubData;
  final String imagePath;

  const FormationScreen({
    super.key,
    required this.clubData,
    required this.imagePath,
  });

  @override
  State<FormationScreen> createState() => _FormationScreenState();
}

class _FormationScreenState extends State<FormationScreen> {
  // Data Pemain Utama (Starter)
  List<Map<String, String>> starters = [
    {'name': 'Courtois', 'pos': 'GK', 'rating': '99'},
    {'name': 'Militao', 'pos': 'CB', 'rating': '102'},
    {'name': 'Bellingham', 'pos': 'AMF', 'rating': '101'},
    {'name': 'Vinicius', 'pos': 'CF', 'rating': '103'},
  ];

  // Data Pemain Cadangan (Substitutes)
  List<Map<String, String>> subs = [
    {'name': 'Modric', 'pos': 'CMF', 'rating': '100'},
    {'name': 'Rodrygo', 'pos': 'RWF', 'rating': '99'},
    {'name': 'Rudiger', 'pos': 'CB', 'rating': '100'},
    {'name': 'Camavinga', 'pos': 'DMF', 'rating': '98'},
  ];

  // Variabel untuk menyimpan indeks pemain cadangan yang sedang dipilih
  int? selectedSubIndex;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  // Widget Kartu Pemain Inti (Di Lapangan)
  Widget _buildPlayerCard(int index, double top, double left) {
    final player = starters[index];
    
    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        onTap: () {
          // Jika ada pemain cadangan yang sedang dipilih, lakukan TUKAR POSISI
          if (selectedSubIndex != null) {
            setState(() {
              final temp = starters[index];
              starters[index] = subs[selectedSubIndex!];
              subs[selectedSubIndex!] = temp;
              selectedSubIndex = null; // Reset pilihan setelah menukar
            });
          }
        },
        child: Column(
          children: [
            Container(
              width: 50,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                border: Border.all(
                  // Beri efek menyala (merah) jika siap ditukar
                  color: selectedSubIndex != null ? Colors.redAccent : Colors.amber, 
                  width: selectedSubIndex != null ? 3 : 2
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 5)],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(player['pos']!, style: const TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                  Text(player['rating']!, style: const TextStyle(color: Colors.yellow, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              player['name']!,
              style: const TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold,
                shadows: [Shadow(color: Colors.black, blurRadius: 2)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Baris Pemain Cadangan
  Widget _buildSubRow(int index) {
    final player = subs[index];
    bool isSelected = selectedSubIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          // Pilih atau batalkan pilihan pemain cadangan
          selectedSubIndex = isSelected ? null : index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        padding: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          // Warna latar berubah jadi biru transparan jika dipilih
          color: isSelected ? Colors.blue.withValues(alpha: 0.5) : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          border: isSelected ? Border.all(color: Colors.blueAccent) : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(4)),
              child: Text(player['pos']!, style: const TextStyle(color: Colors.greenAccent, fontSize: 10)),
            ),
            const SizedBox(width: 10),
            Text(player['name']!, style: const TextStyle(color: Colors.white, fontSize: 12)),
            const Spacer(),
            Text(player['rating']!, style: const TextStyle(color: Colors.yellow, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String clubName = widget.clubData['name'] ?? 'Klub';
    String description = widget.clubData['description'] ?? 'Deskripsi tidak tersedia.';

    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1A),
      body: SafeArea(
        child: Row(
          children: [
            // --- PANEL KIRI ---
            Container(
              width: 80, color: const Color(0xFF131A2A),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () {
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,
                      ]);
                      Navigator.pop(context);
                    },
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: Image.asset(widget.imagePath, width: 40, height: 40),
                  ),
                  const SizedBox(height: 20),
                  const Icon(Icons.person, color: Colors.white, size: 40),
                  const Text('Manager', style: TextStyle(color: Colors.white70, fontSize: 10)),
                  const Spacer(),
                ],
              ),
            ),

            // --- PANEL TENGAH (LAPANGAN) ---
            Expanded(
              flex: 4,
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green[900],
                  border: Border.all(color: Colors.white30, width: 2),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double w = constraints.maxWidth;
                    double h = constraints.maxHeight;
                    return Stack(
                      children: [
                        Center(child: Container(width: 2, color: Colors.white30)),
                        Center(child: Container(width: 80, height: 80, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white30, width: 2)))),
                        
                        // Memanggil pemain berdasarkan Index
                        _buildPlayerCard(0, h * 0.4, w * 0.05), // Posisi GK
                        _buildPlayerCard(1, h * 0.4, w * 0.25), // Posisi CB
                        _buildPlayerCard(2, h * 0.2, w * 0.5),  // Posisi AMF
                        _buildPlayerCard(3, h * 0.6, w * 0.65), // Posisi CF
                      ],
                    );
                  },
                ),
              ),
            ),

            // --- PANEL KANAN (CADANGAN) ---
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(15),
                color: const Color(0xFF131A2A),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(clubName, style: const TextStyle(color: Colors.amber, fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text('Team Playstyle: Counter Attack', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                    const Divider(color: Colors.white24, height: 20),
                    Text(description, style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const Divider(color: Colors.white24, height: 20),

                    // DAFTAR PEMAIN CADANGAN
                    Row(
                      children: [
                        const Text('Pemain Cadangan:', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                        if (selectedSubIndex != null) 
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text('(Pilih target di lapangan)', style: TextStyle(color: Colors.redAccent, fontSize: 10)),
                          )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: subs.length,
                        itemBuilder: (context, index) {
                          return _buildSubRow(index);
                        },
                      ),
                    ),

                    SizedBox(
                      width: double.infinity, height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => StadiumScreen(clubName: clubName)));
                        },
                        child: const Text('START MATCH', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}