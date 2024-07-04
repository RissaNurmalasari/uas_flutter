import 'package:flutter/material.dart';
import 'package:toko_buku/chart.dart';
import 'package:toko_buku/home.dart';
import 'package:toko_buku/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rissa Ns',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Login(),
    );
  }
}
