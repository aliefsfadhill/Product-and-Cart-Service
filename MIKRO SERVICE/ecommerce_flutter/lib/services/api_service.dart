import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/products.dart';
import '../model/cart_item.dart'; // Pastikan file model ini ada
import '../utils/constants.dart';   // Pastikan file constants sudah update URL

class ApiService {
  
  // ==========================================
  // BAGIAN PRODUK (Port 3000)
  // ==========================================

  // Ambil semua produk
  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$productBaseUrl/products'));
      
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Product.fromJson(data)).toList();
      } else {
        throw Exception('Gagal load produk: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error Produk: $e');
    }
  }

  // Ambil detail satu produk
  Future<Product> fetchProductById(int id) async {
    try {
      final response = await http.get(Uri.parse('$productBaseUrl/products/$id'));
      
      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Gagal load detail: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error Detail: $e');
    }
  }

  // ==========================================
  // BAGIAN KERANJANG (Port 8000)
  // ==========================================

  // 1. Ambil Data Keranjang
  Future<Map<String, dynamic>> fetchCart() async {
    try {
      final response = await http.get(Uri.parse('$cartBaseUrl/carts'));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        
        // Ambil list itemnya
        List<dynamic> itemsJson = jsonResponse['items'];
        List<CartItem> items = itemsJson.map((data) => CartItem.fromJson(data)).toList();
        
        // Return Map biar dapet items & total harga
        return {
          'items': items,
          'total': jsonResponse['total'],
        };
      } else {
        throw Exception('Gagal load keranjang: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error Cart: $e');
    }
  }

  // 2. Update Quantity Item (PUT) - BARU NIH!
  Future<void> updateCartItem(int id, int quantity) async {
    try {
      final response = await http.put(
        Uri.parse('$cartBaseUrl/carts/$id'),
        // Kirim data quantity baru sebagai body
        body: {'quantity': quantity.toString()}, 
      );

      if (response.statusCode != 200) {
        throw Exception('Gagal update cart: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error Update Cart: $e');
    }
  }

  // 3. Hapus Item (DELETE) - BARU NIH!
  Future<void> deleteCartItem(int id) async {
    try {
      final response = await http.delete(Uri.parse('$cartBaseUrl/carts/$id'));

      if (response.statusCode != 200) {
        throw Exception('Gagal hapus item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error Delete Cart: $e');
    }
  }
}