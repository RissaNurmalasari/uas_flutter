import 'package:flutter/material.dart';
import 'package:toko_buku/main.dart';
import 'package:toko_buku/login.dart';
import 'package:toko_buku/home.dart';
import 'package:toko_buku/chart.dart';
import 'package:toko_buku/Akun.dart';

class PesananScreen extends StatelessWidget {
  const PesananScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Riwayat Pesanan'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: ListView(
        children: [
          PesananCard(
            date: '02 Jul 2024 - 18:18 WIB',
            status: 'Dikirim',
            productName: 'Lelaki Harimau ',
            productCode: '0-240702-AGJPJZM',
            productCount: '3 Produk',
            buttonAction: () {
              // Implement action for Konfirmasi Pesanan button
            },
            buttonLabel: 'Konfirmasi Pesanan',
          ),
          PesananCard(
            date: '02 Jul 2024 - 17:45 WIB',
            status: 'Dikirim',
            productName: 'Cantik Itu Luka',
            productCode: '0-240702-AGCNYNC',
            productCount: '1 Produk',
            buttonAction: () {
              // Implement action for Batal button
            },
            buttonLabel: 'Batal',
          ),
          PesananCard(
            date: '02 Jul 2024 - 17:17 WIB',
            status: 'Dikirim',
            productName: 'Dear Allah',
            productCode: '0-240702-AGJNLKX',
            productCount: '3 Produk',
            buttonAction: () {},
            buttonLabel: '',
          ),
        ],
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
          }
        },
      ),
    );
  }
}

class PesananCard extends StatelessWidget {
  final String date;
  final String status;
  final String productName;
  final String productCode;
  final String productCount;
  final String buttonLabel;
  final VoidCallback? buttonAction;

  const PesananCard({
    Key? key,
    required this.date,
    required this.status,
    required this.productName,
    required this.productCode,
    required this.productCount,
    required this.buttonLabel,
    this.buttonAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.delivery_dining),
                const SizedBox(width: 8.0),
                Text(date),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              'Dikirim ke Alamat • 1 Pengiriman',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(productCode),
            const SizedBox(height: 8.0),
            Text(
              '$productName',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text('$productCount'),
            const SizedBox(height: 16.0),
            if (buttonLabel.isNotEmpty)
              Center(
                child: ElevatedButton(
                  onPressed: buttonAction,
                  child: Text(buttonLabel),
                ),
              ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status: $status',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}