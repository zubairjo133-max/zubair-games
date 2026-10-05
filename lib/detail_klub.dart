import 'package:flutter/material.dart';
import 'formation_screen.dart'; // Menghubungkan ke file formasi

class DetailKlubScreen extends StatefulWidget {
  final Map<String, dynamic> clubData;
  final String imagePath;

  const DetailKlubScreen({
    super.key,
    required this.clubData,
    required this.imagePath,
  });

  @override
  State<DetailKlubScreen> createState() => _DetailKlubScreenState();
}

class _DetailKlubScreenState extends State<DetailKlubScreen> {
  // Variabel untuk dropdown formasi (menggantikan tiket)
  String selectedFormation = '3-1';
  final List<String> formationOptions = ['3-1', '2-1-1', '1-1-2', '1-2-1', '1-3'];

  @override
  Widget build(BuildContext context) {
    String deskripsi = widget.clubData['description'] ?? 'Deskripsi tidak tersedia.';

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.clubData['name']} - Info Umum', style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 219, 234, 233),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Logo Klub
              Image.asset(
                widget.imagePath,
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              Text(
                widget.clubData['name'] ?? 'Nama Klub',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // Layout Kiri (Deskripsi & Tombol) dan Kanan (Fun Fact)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- SISI KIRI ---
                  Flexible(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          deskripsi,
                          style: const TextStyle(fontSize: 16, height: 1.5),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 30),
                        
                        // DROPDOWN FORMASI
                        const Text(
                          'Pilih Formasi Tim:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<String>(
                            value: selectedFormation,
                            isExpanded: true,
                            underline: const SizedBox(),
                            items: formationOptions.map((String option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(option),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedFormation = newValue!;
                              });
                            },
                          ),
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // TOMBOL MAINKAN DI STADION
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FormationScreen(
          clubData: widget.clubData,
          imagePath: widget.imagePath,
        ),
                                ),
                              );
                            },
                            child: const Text(
                              'MAINKAN KLUB INI DI STADION',
                              style: TextStyle(
                                fontSize: 18, 
                                fontWeight: FontWeight.bold, 
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 30),
                  
                  // --- SISI KANAN: KOTAK WIKIPEDIA / FUN FACT ---
                  Flexible(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              'Fun Fact',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Divider(height: 20),
                          
                          // Baris Julukan
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Expanded(flex: 1, child: Text('Julukan', style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(flex: 2, child: Text(widget.clubData['julukan'] ?? '-')),
                            ],
                          ),
                          const SizedBox(height: 10),
                          
                          // Baris Stadion
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Expanded(flex: 1, child: Text('Stadion', style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(flex: 2, child: Text(widget.clubData['stadion'] ?? '-')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}