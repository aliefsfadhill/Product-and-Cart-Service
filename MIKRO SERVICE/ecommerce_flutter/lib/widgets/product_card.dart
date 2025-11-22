import 'package:flutter/material.dart';
import '../model/products.dart';
import '../screens/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Kita bungkus pakai Card tipis biar tetep ada batasnya, tapi rapi kayak list
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12), // Jarak antar item
      elevation: 2, // Bayangan tipis biar manis
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Sudut agak bulat
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10), // Biar efek kliknya ngikutin bentuk card
        onTap: () {
          // Navigasi ke halaman detail saat diklik
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(productId: product.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // 1. Bagian Gambar (Icon Placeholder) di Kiri
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.indigo[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.indigo[400],
                  size: 30,
                ),
              ),
              
              SizedBox(width: 16), // Spasi antar gambar dan teks

              // 2. Bagian Teks (Nama & Harga) di Tengah
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Rp ${product.price}.000',
                      style: TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // 3. Bagian Tombol Beli di Kanan
              Container(
                decoration: BoxDecoration(
                  color: Colors.indigo[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: Icon(Icons.add_shopping_cart),
                  color: Colors.indigo,
                  iconSize: 20,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.name} masuk keranjang!'),
                        duration: Duration(seconds: 1),
                        backgroundColor: Colors.green[600],
                        behavior: SnackBarBehavior.floating, // SnackBar ngambang
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}