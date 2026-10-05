import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'detail_klub.dart';
import 'league_selection_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Web Profil',
      home: const LoginScreen(),
    );
  }
}
class AboutMeScreen extends StatefulWidget {
  const AboutMeScreen({super.key});

  @override
  State<AboutMeScreen> createState() => _AboutMeScreenState();
}

class _AboutMeScreenState extends State<AboutMeScreen> {
  bool _tampilkanPesan = false;

  // 1. DATA UNTUK LISTVIEW BUILDER
  final List<String> daftarKeahlian = [
    'Flutter & Dart Development',
    'Manajemen Database (MySQL)',
    'Algoritma & Pemecahan Masalah',
    'Git & GitHub Version Control',
    'Arsitektur Sistem Operasi',
    'Dasar Keamanan Siber',
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 800; // Deteksi perangkat HP

    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87), 
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
      ),
      backgroundColor: Colors.lightBlue[100], 
      body: Center(
        child: Container(
          margin: EdgeInsets.all(isMobile ? 12 : 40), // Margin lebih kecil di HP agar tidak makan tempat
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20), 
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))
            ],
          ),
          clipBehavior: Clip.antiAlias, 
          child: Flex(
            direction: Axis.horizontal, // <-- KUNCI UTAMA: Selalu menyamping (landscape) baik di HP maupun Desktop!
            children: [
              // SISI KIRI: Area Teks & Keahlian
              Expanded(
                flex: 3, // Porsi lebih luas untuk teks
                child: SingleChildScrollView( // Agar bisa di-scroll ke bawah jika teksnya panjang di HP
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16.0 : 50.0, 
                    vertical: isMobile ? 20.0 : 40.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Muhamad Zubair',
                        style: TextStyle(
                          fontSize: isMobile ? 22 : 32, // Ukuran font menyesuaikan otomatis
                          fontWeight: FontWeight.w900,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 15),
                      
                      Wrap(
                        spacing: 8, 
                        runSpacing: 8, 
                        children: [
                          _buildBubble('Nama : Zubair', Colors.blue[50]!, Colors.blue[800]!),
                          _buildBubble('05 Juli 2007', Colors.blue[50]!, Colors.blue[800]!),
                          _buildBubble('Umur : 19 tahun', Colors.blue[50]!, Colors.blue[800]!),
                        ],
                      ),
                      
                      const SizedBox(height: 15),
                      
                      // Bubble Cerita
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.grey[100], 
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[300]!), 
                        ),
                        child: const Text(
                          'Di luar rutinitas akademik, saya aktif membangun channel YouTube "JO" dan konsisten menjaga kebugaran fisik melalui olahraga lari. Saya selalu antusias memecahkan tantangan teknis melalui barisan kode.',
                          style: TextStyle(
                            fontSize: 13, 
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                            color: Colors.black87, 
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),
                      
                      const Text(
                        'Keahlian IT & Tools:',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),

                      // 2. IMPLEMENTASI LISTVIEW.BUILDER YANG AMAN DI DALAM COLUMN
                      SizedBox(
                        height: isMobile ? 150 : 200, // Batasi tinggi list agar tidak overflow
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: daftarKeahlian.length, 
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.white,
                              elevation: 0,
                              margin: const EdgeInsets.only(bottom: 6),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                dense: true,
                                leading: const Icon(Icons.code, color: Colors.blueAccent, size: 18),
                                title: Text(
                                  daftarKeahlian[index], 
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Tombol Rahasia
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _tampilkanPesan = !_tampilkanPesan;
                          });
                        },
                        icon: Icon(
                          _tampilkanPesan ? Icons.visibility_off : Icons.favorite, 
                          color: Colors.pink, 
                          size: 16,
                        ),
                        label: Text(
                          _tampilkanPesan ? 'Sembunyikan' : 'Pesan Rahasia',
                          style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200], 
                          elevation: 0,
                        ),
                      ),

                      if (_tampilkanPesan) const SizedBox(height: 8),

                      // Bubble Pesan Rahasia
                      if (_tampilkanPesan)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100], 
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey[300]!), 
                          ),
                          child: const Text(
                            '"gapapa gabisa ketemu setiap hari denganmu, asalkan namaku tetap menjadi yang utama di hatimu."\n\n- from zubair to alfarela.',
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87, 
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              
              // SISI KANAN: Area Foto
              Expanded(
                flex: 1, // Kembalikan ke 1 agar porsi Desktop & HP tetap stabil
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image.asset(
                    'assets/profil.jpeg',
                    fit: BoxFit.cover, 
                    // INI KUNCINYA: Jika HP geser ke kiri, jika Desktop biarkan normal di tengah!
                    alignment: isMobile ? Alignment.centerLeft : Alignment.center, 
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBubble(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoginMode = true; 

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Database memori yang sekarang tidak statis
  Map<String, String> _userDatabase = {
    'admin': '12345' // Akun bawaan
  };

  // 1. Fungsi yang dipanggil PERTAMA KALI saat halaman dibuka
  @override
  void initState() {
    super.initState();
    _loadDatabase(); // Memuat data akun yang tersimpan di browser
  }

  // 2. Fungsi untuk mengambil data dari Local Storage Browser
  Future<void> _loadDatabase() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dbString = prefs.getString('user_db');
    
    if (dbString != null) {
      setState(() {
        // Mengubah teks JSON kembali menjadi bentuk Map
        _userDatabase = Map<String, String>.from(json.decode(dbString));
      });
    }
  }

  // 3. Fungsi untuk menyimpan data ke Local Storage Browser
  Future<void> _saveDatabase() async {
    final prefs = await SharedPreferences.getInstance();
    // Mengubah bentuk Map menjadi teks JSON agar bisa disimpan
    await prefs.setString('user_db', json.encode(_userDatabase));
  }

  void _submitAction() {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username dan Password tidak boleh kosong!'), backgroundColor: Colors.red),
      );
      return;
    }

    if (_isLoginMode) {
      // --- PROSES LOGIN ---
      if (_userDatabase.containsKey(username) && _userDatabase[username] == password) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Berhasil!'), backgroundColor: Colors.green),
        );
       Navigator.pushReplacement(
              context,
              MaterialPageRoute(
               builder: (context) => LeagueSelectionScreen(username: username),
              ), 
            );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username atau password salah!'), backgroundColor: Colors.red),
        );
      }
    } else {
      // --- PROSES CREATE ACCOUNT ---
      if (_userDatabase.containsKey(username)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username sudah terdaftar! Pilih yang lain.'), backgroundColor: Colors.red),
        );
      } else {
        setState(() {
          _userDatabase[username] = password;
          _isLoginMode = true; 
          _usernameController.clear(); 
          _passwordController.clear();
        });
        
        _saveDatabase(); // <-- FUNGSI SAKTI PENYELAMAT DATA DIPANGGIL DI SINI!

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Akun berhasil dibuat! Silakan login.'), backgroundColor: Colors.green),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.account_circle, size: 80, color: Colors.blue[800]),
                      const SizedBox(height: 20),
                      Text(
                        _isLoginMode ? 'Selamat Datang!' : 'Buat Akun Baru',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                      labelText: 'Username',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _submitAction,
                      child: Text(
                        _isLoginMode ? 'LOGIN' : 'DAFTAR',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLoginMode = !_isLoginMode;
                        _usernameController.clear();
                        _passwordController.clear();
                      });
                    },
                    child: Text(
                      _isLoginMode 
                          ? 'Belum punya akun? Buat Akun' 
                          : 'Sudah punya akun? Login di sini',
                      style: TextStyle(color: const Color.fromARGB(255, 184, 207, 233)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class UserListScreen extends StatelessWidget {
  UserListScreen({super.key});

  // Data orang-orang yang akan masuk ke dalam List
  final List<Map<String, String>> users = [
    {'name': 'Muhamad Zubair', 'email': 'zubair sukses amin', 'id': 'ID: 1'},
    {'name': 'Club-club Bola', 'email': 'club@bola.com', 'id': 'ID: 2'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('List View', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 159, 228, 255), // Tema oranye
      ),
      // INI ADALAH LISTVIEW.BUILDER YANG ANDA MINTA
      body: ListView.builder(
        itemCount: users.length, 
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Avatar Kiri
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: index == 0 
                        ? Image.asset('assets/profil.jpeg', width: 60, height: 60, fit: BoxFit.cover) 
                        : index == 1 
                            ? Image.asset('assets/Screenshot 2026-09-14 224337.png', width: 60, height: 60, fit: BoxFit.cover)
                            : Container(
                                width: 60, 
                                height: 60, 
                                color: Colors.cyan[200],
                                child: const Icon(Icons.person, color: Colors.white),
                              ),
                  ), // ClipRRect
                  const SizedBox(width: 16),
                  
                  // Teks Tengah
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(users[index]['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text(users[index]['email']!, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                        Text(users[index]['id']!, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                      ],
                    ),
                  ),
                  
                  // Tombol Kanan (View Profile)
                  ElevatedButton(
  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 154, 243, 239)),
  onPressed: () {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AboutMeScreen()),
      );
    } else if (index == 1) {
     Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LeagueSelectionScreen(
            username: 'Visitor',
          ),
        ),
      );
      }
    }, // <--- INI YANG HILANG (Kurung tutup untuk fungsi onPressed)
    child: const Text('View Profile', style: TextStyle(color: Colors.white)),
  ), // ElevatedButton
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
// ==========================================
// HALAMAN INFORMASI KLUB BOLA
// ==========================================
class FootballClubScreen extends StatelessWidget {
  final String username; // Variabel penangkap nama dari halaman login
  
  const FootballClubScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    // DATA KLUB BOLA: Silakan ganti nama dan infonya sesuai keinginan Anda!
    final List<Map<String, String>> clubs = [
      {
        'name': 'Real Madrid',
        'stadium': 'Santiago Bernabéu',
        'info': 'Real Madrid Club de Fútbol, sering disebut sebagai Los Blancos, adalah klub sepak bola profesional yang berbasis di Madrid, Spanyol.Klub ini memantapkan dirinya sebagai kekuatan utama dalam sepak bola Spanyol dan Eropa selama tahun 1950. Di dalam negeri, Klub ini juga merupakan salah satu klub terbaik abad ke-20 menurut FIFA. Klub ini menjuarai Liga Champions 3 musim berturut-turut dibawah kepelatihan Zinedine Zidane dan dengan mesin golnya yaitu pemain terbaik dunia Cristiano Ronaldo. Dalam kompetisi domestik, klub ini telah meraih 36 gelar La Liga (rekor), 20 gelar Piala Raja Spanyol, 13 Piala Super Spanyol, 1 Copa Eva Duarte, 1 Copa de la Liga,[6]. Di kompetisi tingkat Eropa dan Dunia, klub ini telah meraih 15 gelar Piala Champions Eropa/Liga Champions UEFA (rekor), 2 Piala UEFA/Liga Eropa UEFA, 6 Piala Super UEFA, dan 9 kejuaraan dunia antar klub (3 Piala Interkontinental , 5 Piala Dunia Antarklub FIFA dan 1 Piala Ibero-American).'
      },
      {
        'name': 'Manchester United',
        'stadium': 'Old Trafford',
        'info': 'Manchester United, dijuluki "The Red Devils", adalah salah satu klub paling ikonik di Liga Premier Inggris.Klub ini memiliki sejarah panjang dan prestasi yang mengesankan, termasuk banyak gelar liga dan piala domestik serta kesuksesan di kompetisi Eropa. Dikenal dengan basis penggemar global yang besar, Manchester United telah menjadi simbol sepak bola Inggris di seluruh dunia.'
      },
      {
        'name': 'Barcelona',
        'stadium': 'Camp Nou',
        'info': 'Futbol Club Barcelona, atau disingkat Barça, adalah simbol dari budaya Katalan dengan moto "Més que un club".Klub ini terkenal dengan filosofi permainan menyerang dan pengembangan pemain muda melalui akademi La Masia. Barcelona telah meraih banyak gelar domestik dan internasional, termasuk Liga Champions UEFA, dan dikenal karena rivalitas sengitnya dengan Real Madrid dalam El Clásico.'
      },
      {
        'name': 'Bayern Munchen',
        'stadium': 'Allianz Arena',
        'info': 'Fußball-Club Bayern München adalah raksasa sepak bola dari Bavaria, Jerman. Klub berjuluk "Die Bayern" ini sangat dominan.Klub ini telah meraih banyak gelar Bundesliga, DFB-Pokal, dan Liga Champions UEFA. Bayern Munchen dikenal dengan gaya permainan yang kuat dan disiplin, serta memiliki basis penggemar yang besar di seluruh dunia.'
      },
      {
        'name': 'Atletico Madrid',
        'stadium': 'Wanda Metropolitano',
        'info': 'Club Atlético de Madrid, atau Atletico Madrid, adalah klub sepak bola yang dikenal dengan semangat juang tingginya.Klub ini telah meraih kesuksesan di La Liga dan kompetisi Eropa, termasuk Liga Europa UEFA. Atletico Madrid dikenal dengan pertahanan yang solid dan gaya permainan yang disiplin, serta memiliki basis penggemar yang setia di Spanyol dan internasional.'
      },
      {
        'name': 'Arsenal',
        'stadium': 'Emirates Stadium',
        'info': 'Arsenal Football Club adalah klub sepak bola Inggris yang berbasis di London. Klub ini dikenal dengan gaya bermain indahnya.Klub ini telah meraih banyak gelar Liga Premier dan Piala FA. Arsenal memiliki basis penggemar yang besar dan setia, serta dikenal dengan akademi pemain muda yang sukses menghasilkan talenta berbakat.'
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi Klub Bola', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 219, 234, 233),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.account_circle, size: 30),
          tooltip: 'Menu Profil',
          offset: const Offset(0, 50),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              enabled: false,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.person, size: 40, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      username.toUpperCase(), 
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
                    ),
                    const Text('Pengguna Aktif', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem<String>(
              value: 'about',
              child: ListTile(
                leading: Icon(Icons.info_outline, color: Colors.blue),
                title: Text('Tentang Developer'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem<String>(
              value: 'logout',
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
          onSelected: (String value) {
            if (value == 'about') {
              // Jika Anda belum membuat AboutMeScreen, pastikan class-nya sudah ada
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutMeScreen()),
              );
            } else if (value == 'logout') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            }
          },
        ),
        const SizedBox(width: 10),
      ],
      ),
      body: ListView.builder(
        itemCount: clubs.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
             
  onTap: () {
  String pathGambar = '';
  if (index == 0) {
    pathGambar = 'assets/real_madrid.png';
  } else if (index == 1) {
    pathGambar = 'assets/manchester_united.png';
  } else if (index == 2) {
    pathGambar = 'assets/Barcelona.png';
  } else if (index == 3) {
    pathGambar = 'assets/bayern_munchen.png';
  } else if (index == 4) {
    pathGambar = 'assets/atletico_madrid.png';
  }

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DetailKlubScreen(
        clubData: clubs[index],
        imagePath: pathGambar,
      ),
    ),
  );
},
              contentPadding: const EdgeInsets.all(16),
              leading: index == 0
    ? Image.asset('assets/real_madrid.png', width: 45, height: 45, fit: BoxFit.contain)
    : index == 1
        ? Image.asset('assets/manchester_united.png', width: 45, height: 45, fit: BoxFit.contain)
        : index == 2
            ? Image.asset('assets/Barcelona.png', width: 45, height: 45, fit: BoxFit.contain)
            : index == 3
                ? Image.asset('assets/bayern_munchen.png', width: 45, height: 45, fit: BoxFit.contain)
                : index == 4
                    ? Image.asset('assets/atletico_madrid.png', width: 45, height: 45, fit: BoxFit.contain)
                    : const Icon(Icons.sports_soccer, color: Color.fromARGB(255, 149, 204, 255), size: 40),
              title: Text(clubs[index]['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const SizedBox(height: 8),
    Text(
      'Stadion: ${clubs[index]['stadium']}', 
      style: const TextStyle(color: Colors.blueGrey),
    ),
  ],
),
            ),
          );
        },
      ),
    );
  }
}