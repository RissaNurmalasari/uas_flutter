import 'package:flutter/material.dart';
import 'package:toko_buku/login.dart';

class AkunScreen extends StatelessWidget {
  const AkunScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Akun'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama Pengguna:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Rissanssss', // Replace with actual user name
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Email:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Rissa@gmail.com', // Replace with actual email
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'No. HP:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '08123456789', // Replace with actual phone number
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Alamat:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Jalan Sudirman No. 123, Jakarta', // Replace with actual address
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add logic to logout user
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                child: Text('Logout'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Akun',
          ),
        ],
        selectedItemColor: Colors.red,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/pesanan');
          }
        },
      ),
    );
  }
}
