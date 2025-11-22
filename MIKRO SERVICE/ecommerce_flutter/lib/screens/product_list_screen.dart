import 'package:flutter/material.dart';
import '../model/products.dart';
import '../services/api_service.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart'; // PENTING: Import halaman Cart biar bisa navigasi

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> futureProducts;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // Ambil data produk pas halaman dibuka
    futureProducts = apiService.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Produk'),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black87,
        
        // --- FITUR BARU: Tombol Cart di Pojok Kanan ---
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  // Pindah ke halaman Cart saat diklik
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartScreen()),
                  );
                },
              ),
              // (Optional) Titik merah indikator biar kece
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 8,
                    minHeight: 8,
                  ),
                ),
              )
            ],
          ),
          SizedBox(width: 8), // Spasi dikit dari pinggir kanan
        ],
        // ----------------------------------------------
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Gagal: ${snapshot.error}', textAlign: TextAlign.center),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final products = snapshot.data!;
            
            // Pakai ListView biar rapi ke bawah (bukan Grid lagi)
            return ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: products.length,
              itemBuilder: (context, index) {
                // Panggil widget ProductCard yang udah kita jadiin list tile
                return ProductCard(product: products[index]);
              },
            );
          } else {
            return Center(child: Text('Tidak ada produk.'));
          }
        },
      ),
    );
  }
}