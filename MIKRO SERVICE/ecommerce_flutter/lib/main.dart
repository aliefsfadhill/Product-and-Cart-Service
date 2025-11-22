import 'package:flutter/material.dart';
import 'screens/product_list_screen.dart'; // Import halaman daftar produk

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Produk', // Judul app-nya
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Color(0xFFF4F6F8), // Latar belakang netral
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      
      // INI YANG PENTING:
      // Kita set halaman utamanya ke ProductListScreen,
      // BUKAN ke 'MyHomePage' (template demo)
      home: ProductListScreen(), 
      
      debugShowCheckedModeBanner: false,
    );
  }
}