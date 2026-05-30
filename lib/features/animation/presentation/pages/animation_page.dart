import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimationPage extends StatefulWidget {
  const AnimationPage({super.key});

  @override
  State<AnimationPage> createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage> with TickerProviderStateMixin {
  
  late AnimationController _spinController;
  late AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this, 
      duration: const Duration(seconds: 2), 
    );
    _spinController.repeat();

    _lottieController = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    _spinController.dispose();
    _lottieController.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Advanced Animations')),
      body: Center(
        child: SingleChildScrollView( 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Explicit Animation (Putaran Tanpa Henti):", 
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              
              AnimatedBuilder(
                animation: _spinController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _spinController.value * 6.2831853,
                    child: child, 
                  );
                },
                child: const Icon(Icons.star, size: 100, color: Colors.orange),
              ),
              
              const SizedBox(height: 40),
              const Divider(),
              const SizedBox(height: 40),

              // --- TUGAS MANDIRI ---
              const Text("Lottie Animation (Desain After Effects):", 
                  style: TextStyle(fontWeight: FontWeight.bold)),
              
              // TUGAS 2: Interactive Scrubbing (Geser jari)
              GestureDetector(
                onPanUpdate: (details) {
                  // details.delta.dx adalah jarak pergeseran jari ke kiri/kanan.
                  // Kita bagi 200 agar perubahannya halus (nilai value Lottie hanya 0.0 sampai 1.0).
                  setState(() {
                    _lottieController.value += details.delta.dx / 200;
                  });
                },
                child: Lottie.network(
                  'https://assets2.lottiefiles.com/packages/lf20_jbrw3hcz.json',
                  controller: _lottieController,
                  width: 200,
                  height: 200,
                  onLoaded: (composition) {
                    _lottieController.duration = composition.duration;
                  },
                ),
              ),
              const Text("(Sentuh & Geser ceklis di atas ke Kiri/Kanan) 👆", 
                style: TextStyle(color: Colors.grey, fontSize: 13, fontStyle: FontStyle.italic)),
              
              const SizedBox(height: 30),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                    onPressed: () {
                      _lottieController.reset(); 
                      _lottieController.forward(); 
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text("Play"),
                  ),
                  const SizedBox(width: 15),

                  // TUGAS 1: Tombol Reverse Waktu
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                    onPressed: () {
                      // Ini akan memutar animasi MUNDUR dari posisinya saat ini
                      _lottieController.reverse();
                    },
                    icon: const Icon(Icons.fast_rewind),
                    label: const Text("Reverse"),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}