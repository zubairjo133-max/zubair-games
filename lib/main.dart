import 'package:flutter/material.dart';

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
  // Saklar untuk tombol rahasia
  bool _tampilkanPesan = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100], 
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(40), 
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20), 
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))
            ],
          ),
          clipBehavior: Clip.antiAlias, 
          child: Row(
            children: [
              // SISI KIRI: Area Profil
              Expanded(
                flex: 2, 
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Muhamad Zubair',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // Kumpulan Bubble Info Singkat
                      Wrap(
                        spacing: 12, 
                        runSpacing: 12, 
                        children: [
                          _buildBubble('Nama : Zubair', Colors.blue[50]!, Colors.blue[800]!),
                          _buildBubble('05 Juli 2007', Colors.blue[50]!, Colors.blue[800]!),
                          _buildBubble('Umur : 19 tahun', Colors.blue[50]!, Colors.blue[800]!),
                        ],
                      ),
                      
                      const Spacer(),
                      
                      // Bubble Cerita (Sekarang Putih Keabu-abuan)
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.grey[100], // Background putih keabu-abuan
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[300]!), // Garis tepi abu-abu
                        ),
                        child: const Text(
                          'Sebagai mahasiswa IT, saya memiliki ketertarikan mendalam dalam mengeksplorasi algoritma, arsitektur sistem operasi, dan dunia keamanan siber.\n\nDi luar rutinitas akademik, saya aktif membangun channel YouTube "JO" dan konsisten menjaga kebugaran fisik melalui rutinitas olahraga lari. Saya selalu antusias memecahkan berbagai tantangan teknis melalui barisan kode.',
                          style: TextStyle(
                            fontSize: 16, 
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                            color: Colors.black87, // Teks diubah gelap agar terbaca
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

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
                          size: 18,
                        ),
                        label: Text(
                          _tampilkanPesan ? 'Sembunyikan' : 'Pesan Rahasia',
                          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200], 
                          elevation: 0,
                        ),
                      ),

                      if (_tampilkanPesan) const SizedBox(height: 10),

                      // Bubble Pesan Rahasia (Senada dengan Bubble Cerita)
                      if (_tampilkanPesan)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100], // Background putih keabu-abuan
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey[300]!), 
                          ),
                          child: const Text(
                            '"gapapa gabisa ketemu setiap hari denganmu, asalkan namaku tetap menjadi yang utama di hatimu."\n\n- from zubair to alfarela.',
                            style: TextStyle(
                              fontSize: 14,
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
                flex: 1, 
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image.asset(
                    'assets/profil.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Alat pembuat bubble kecil
  Widget _buildBubble(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
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
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Membuat latar belakang gradasi warna biru
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4FC3F7), // Biru muda di atas
              Color(0xFF0288D1), // Biru gelap di bawah
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 380,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8), // Ujung kotak melengkung halus
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 10))
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Judul LOGIN
                  const Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 4, // Jarak antar huruf diperlebar
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Garis tipis di bawah judul
                  Container(
                    height: 2,
                    width: 50,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(height: 40),

                  // Kolom input Username dengan garis bawah saja
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 239, 241, 245)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Kolom input Password dengan garis bawah saja
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Teks Forgot password di kanan
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(color: Colors.blue[300], fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Tombol bentuk oval dengan gradasi
                  Container(
                    width: 180,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4FC3F7), Color(0xFF0288D1)],
                      ),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 2))
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent, // Transparan agar gradasi wadah terlihat
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        String username = _usernameController.text;
                        String password = _passwordController.text;

                        if (username == 'zubairganteng' && password == '12345678') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const AboutMeScreen()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Username atau Password salah!'),
                              backgroundColor: Color.fromARGB(255, 115, 109, 226),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Teks registrasi di paling bawah
                  Text(
                    "untuk user dan pwnya tanya zubair",
                    style: TextStyle(color: Colors.blue[300], fontSize: 12),
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