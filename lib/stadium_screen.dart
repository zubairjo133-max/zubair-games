import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';

class StadiumScreen extends StatefulWidget {
  final String clubName;
  const StadiumScreen({super.key, required this.clubName});

  @override
  State<StadiumScreen> createState() => _StadiumScreenState();
}

class _StadiumScreenState extends State<StadiumScreen> {
  // Ukuran Layar
  double screenW = 800;
  double screenH = 400;
  bool isInit = false;

  // Skor Pertandingan
  int scoreRed = 0;
  int scoreBlue = 0;

  // Posisi & Kecepatan Bola
  double ballX = 0, ballY = 0, ballVx = 0, ballVy = 0;

  // Tim (Format: [X, Y])
  List<List<double>> redTeam = List.generate(4, (_) => [0.0, 0.0]);
  List<List<double>> blueTeam = List.generate(4, (_) => [0.0, 0.0]);

  // Status Analog
  Offset joystickOffset = Offset.zero;
  final double joystickMaxRadius = 40.0;
  Timer? gameLoop;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    // GAME LOOP (60 FPS)
    gameLoop = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!isInit) return;
      updateGamePhysics();
    });
  }

  void resetPositions() {
    ballX = screenW / 2;
    ballY = screenH / 2;
    ballVx = 0;
    ballVy = 0;

    // Formasi Tim Merah (Kiri)
    redTeam[0] = [screenW * 0.3, screenH * 0.5]; // Anda (Kapten)
    redTeam[1] = [screenW * 0.2, screenH * 0.2]; // Bek Atas
    redTeam[2] = [screenW * 0.2, screenH * 0.8]; // Bek Bawah
    redTeam[3] = [40, screenH / 2]; // KIPER MERAH (Di depan gawang kiri)

    // Formasi Tim Biru (Kanan)
    blueTeam[0] = [screenW * 0.7, screenH * 0.5]; // Striker Musuh
    blueTeam[1] = [screenW * 0.8, screenH * 0.2]; // Bek Atas Musuh
    blueTeam[2] = [screenW * 0.8, screenH * 0.8]; // Bek Bawah Musuh
    blueTeam[3] = [screenW - 40, screenH / 2]; // KIPER BIRU (Di depan gawang kanan)
  }

  // FUNGSI TENDANG (SHOOT)
  void shootBall() {
    double dx = ballX - redTeam[0][0];
    double dy = ballY - redTeam[0][1];
    double dist = sqrt(dx * dx + dy * dy);
    
    // Bisa menendang keras jika jarak dengan bola dekat
    if (dist < 40) {
      double targetX = screenW; // Target gawang kanan
      double targetY = screenH / 2;
      double shootDx = targetX - ballX;
      double shootDy = targetY - ballY;
      double shootDist = sqrt(shootDx * shootDx + shootDy * shootDy);
      
      ballVx = (shootDx / shootDist) * 12.0; // Kecepatan roket
      ballVy = (shootDy / shootDist) * 12.0;
    }
  }

  void updateGamePhysics() {
    setState(() {
      // 1. GERAKAN PEMAIN ANDA (Gabungan Analog & Keyboard WASD)
      double moveX = joystickOffset.dx * 0.15;
      double moveY = joystickOffset.dy * 0.15;
      double kbSpeed = 4.0; // Kecepatan saat pakai keyboard

      // Deteksi tombol keyboard yang sedang ditekan
      final pressedKeys = HardwareKeyboard.instance.logicalKeysPressed;
      if (pressedKeys.contains(LogicalKeyboardKey.keyW)) moveY -= kbSpeed; // W = Atas
      if (pressedKeys.contains(LogicalKeyboardKey.keyS)) moveY += kbSpeed; // S = Bawah
      if (pressedKeys.contains(LogicalKeyboardKey.keyA)) moveX -= kbSpeed; // A = Kiri
      if (pressedKeys.contains(LogicalKeyboardKey.keyD)) moveX += kbSpeed; // D = Kanan
      
      if (pressedKeys.contains(LogicalKeyboardKey.space)) shootBall();

      // Terapkan pergerakan ke bidak Anda (Pemain Merah 0)
      redTeam[0][0] += moveX;
      redTeam[0][1] += moveY;

      // Batas Atas & Bawah Gawang untuk pergerakan Kiper
      double goalTop = screenH / 2 - 60;
      double goalBottom = screenH / 2 + 60;

     // 2. KECERDASAN BUATAN (AI) DENGAN SISTEM KIPER & BEK
      for (int i = 0; i < 4; i++) {
        // --- AI TIM BIRU (Musuh) ---
        if (i == 3) {
          // KIPER BIRU: Tetap di garis gawang kanan
          blueTeam[3][0] = screenW - 40; 
          double targetY = ballY.clamp(goalTop, goalBottom);
          blueTeam[3][1] += (targetY - blueTeam[3][1]) * 0.1; 
        } else {
          double bDx = ballX - blueTeam[i][0];
          double bDy = ballY - blueTeam[i][1];
          double bDist = sqrt(bDx * bDx + bDy * bDy);
          
          if (i == 0) {
            // STRIKER BIRU (B1): Agresif, selalu mengejar bola di mana pun berada
            if (bDist > 0) {
              blueTeam[i][0] += (bDx / bDist) * 1.0;
              blueTeam[i][1] += (bDy / bDist) * 1.0;
            }
          } else if (i == 1 || i == 2) {
            // BEK BIRU (B2 & B3): Disiplin, hanya mengejar jika bola masuk area mereka (jarak < 150)
            if (bDist < 150) {
              blueTeam[i][0] += (bDx / bDist) * 1.0;
              blueTeam[i][1] += (bDy / bDist) * 1.0;
            }
          }
        }

        // --- AI TIM MERAH (Rekan) ---
        if (i == 3) {
          // KIPER MERAH: Tetap di garis gawang kiri
          redTeam[3][0] = 40;
          double targetY = ballY.clamp(goalTop, goalBottom);
          redTeam[3][1] += (targetY - redTeam[3][1]) * 0.1;
        } else if (i > 0) {
          // REKAN MERAH BIASA (R2 & R3): Mengejar bola jika bola mendekat
          double rDx = ballX - redTeam[i][0];
          double rDy = ballY - redTeam[i][1];
          double rDist = sqrt(rDx * rDx + rDy * rDy);
          if (rDist < 150) {
            redTeam[i][0] += (rDx / rDist) * 0.8;
            redTeam[i][1] += (rDy / rDist) * 0.8;
          }
        }
      }

      // 3. LOGIKA BENTURAN (MENGGIRING & MENYAPU BOLA)
     // 3. LOGIKA BENTURAN (MENGGIRING & MENYAPU BOLA)
      void checkHit(List<double> player, bool isRed, bool isUser, bool isGK) {
        double dx = ballX - player[0];
        double dy = ballY - player[1];
        double dist = sqrt(dx * dx + dy * dy);
        
        if (dist < 22) { // Radius Pemain + Bola
          if (isUser) {
            // Anda menggiring dengan bebas
            ballVx += (dx / dist) * 2.0;
            ballVy += (dy / dist) * 2.0;
          } else if (isGK && !isRed) {
            // KIPER BIRU: Menyapu bola jauh-jauh dari gawangnya (Clearance)
            ballVx = -8.0; 
            ballVy = (dy / dist) * 4.0;
          } else {
            // BOT BIASA & KIPER MERAH: Hanya menahan / menendang pelan
            if (isRed) {
              ballVx += 1.5; 
              ballVy += (dy / dist) * 0.5;
            } else {
              ballVx -= 1.5; 
              ballVy += (dy / dist) * 0.5;
            }
          }
        }
      }

      for (int i = 0; i < 4; i++) {
        checkHit(redTeam[i], true, i == 0, i == 3);
        checkHit(blueTeam[i], false, false, i == 3);
      }

      // 4. FISIKA BOLA (Meluncur & Gesekan)
      ballX += ballVx;
      ballY += ballVy;
      ballVx *= 0.94;
      ballVy *= 0.94;

      // 5. BATAS LAPANGAN & GOL
      double margin = 15;

      // Atas Bawah
      if (ballY < margin) { ballY = margin; ballVy *= -0.8; }
      if (ballY > screenH - margin) { ballY = screenH - margin; ballVy *= -0.8; }

      // Kiri (Gol Biru)
      if (ballX < margin) {
        if (ballY > goalTop && ballY < goalBottom) {
          scoreBlue++; resetPositions();
        } else {
          ballX = margin; ballVx *= -0.8;
        }
      }
      // Kanan (Gol Merah)
      if (ballX > screenW - margin) {
        if (ballY > goalTop && ballY < goalBottom) {
          scoreRed++; resetPositions();
        } else {
          ballX = screenW - margin; ballVx *= -0.8;
        }
      }

      // Cegah pemain keluar lapangan
      for(int i=0; i<4; i++) {
         redTeam[i][0] = redTeam[i][0].clamp(0, screenW);
         redTeam[i][1] = redTeam[i][1].clamp(0, screenH);
         blueTeam[i][0] = blueTeam[i][0].clamp(0, screenW);
         blueTeam[i][1] = blueTeam[i][1].clamp(0, screenH);
      }
    });
  }

  @override
  void dispose() {
    gameLoop?.cancel();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[800],
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (!isInit) {
              screenW = constraints.maxWidth;
              screenH = constraints.maxHeight;
              resetPositions();
              isInit = true;
            }

            return Stack(
              children: [
                // --- 1. GAMBAR LAPANGAN UTAMA ---
                Container(width: screenW, height: screenH, color: Colors.green[600]),
                Container(margin: const EdgeInsets.all(10), decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 2))),
                Align(alignment: Alignment.center, child: Container(width: 2, color: Colors.white)),
                Center(child: Container(width: 100, height: 100, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)))),
                // Area Penalti
                Positioned(left: 10, top: screenH / 2 - 80, child: Container(width: 80, height: 160, decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 2)))),
                Positioned(right: 10, top: screenH / 2 - 80, child: Container(width: 80, height: 160, decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 2)))),

                // --- 2. BOLA ---
                Positioned(
                  left: ballX - 7, top: ballY - 7,
                  child: Container(width: 14, height: 14, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                ),

                // --- 3. BOT BIRU (Musuh) ---
                for (int i = 0; i < 4; i++)
                  Positioned(
                    left: blueTeam[i][0] - 15, top: blueTeam[i][1] - 15,
                    child: CircleAvatar(
                      backgroundColor: i == 3 ? Colors.cyan[700] : Colors.blue[700], // Kiper biru warnanya beda sedikit
                      radius: 15, 
                      child: Text(i == 3 ? 'GK' : 'B${i+1}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))
                    ),
                  ),

                // --- 4. PEMAIN MERAH ---
                for (int i = 0; i < 4; i++)
                  Positioned(
                    left: redTeam[i][0] - 15, top: redTeam[i][1] - 15,
                    child: CircleAvatar(
                      backgroundColor: i == 0 ? Colors.redAccent : (i == 3 ? Colors.orange[800] : Colors.red[800]), // Kiper merah warnanya oranye gelap
                      radius: i == 0 ? 17 : 15,
                      child: Text(i == 0 ? 'YOU' : (i == 3 ? 'GK' : 'R${i+1}'), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),

                // --- 5. PAPAN SKOR ---
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(20)),
                      child: Text('MERAH $scoreRed - $scoreBlue BIRU', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),

                // --- 6. TOMBOL KEMBALI ---
                Positioned(
                  top: 10, left: 10,
                  child: IconButton(icon: const Icon(Icons.exit_to_app, color: Colors.white, size: 30), onPressed: () => Navigator.pop(context)),
                ),

                // --- 7. ANALOG JOYSTICK ---
                Positioned(
                  bottom: 20, left: 20,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        Offset newOffset = joystickOffset + details.delta;
                        if (newOffset.distance > joystickMaxRadius) {
                          joystickOffset = Offset.fromDirection(newOffset.direction, joystickMaxRadius);
                        } else {
                          joystickOffset = newOffset;
                        }
                      });
                    },
                    onPanEnd: (details) { setState(() { joystickOffset = Offset.zero; }); },
                    child: Container(
                      width: 120, height: 120,
                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3), shape: BoxShape.circle),
                      child: Center(
                        child: Transform.translate(
                          offset: joystickOffset,
                          child: Container(width: 50, height: 50, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.8), shape: BoxShape.circle)),
                        ),
                      ),
                    ),
                  ),
                ),

                // --- 8. TOMBOL SHOOT ---
                Positioned(
                  bottom: 30, right: 30,
                  child: GestureDetector(
                    onTap: shootBall,
                    child: Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withValues(alpha: 0.8), shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 10)],
                      ),
                      child: const Center(child: Text('SHOOT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}