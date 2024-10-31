import 'package:flutter/material.dart';

class Onboarding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/kopi.png',
                width: 250,
              ),
              SizedBox(height: 20),
              Text(
                ' Kopi Lokal,\nCita Rasa Global',
                textAlign: TextAlign.center, 
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Kopi berkualitas dari biji terbaik nusantara\ndengan menghadirkan rasa yang\nmendunia di setiap tegukan.',
                textAlign: TextAlign.center, // Rata tengah
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(155, 196, 218, 210), 
                  padding: EdgeInsets.symmetric(horizontal: 120, vertical: 20), 
                  elevation: 0, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7), 
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/login'); // Aksi saat tombol ditekan
                },
                child: Text(
                  'Masuk', // Teks tombol
                  style: TextStyle(
                    color: Color(0xFF057350), // Warna teks
                    fontSize: 16, // Ukuran teks
                    fontWeight: FontWeight.bold, // Membuat teks tebal
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

