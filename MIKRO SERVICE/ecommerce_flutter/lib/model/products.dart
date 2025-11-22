// Kelas ini merepresentasikan struktur data dari JSON produk
class Product {
  final int id;
  final String name;
  final int price;
  final String description; // Variabel di Dart pakai 'd' kecil (camelCase)

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
  });

  // Fungsi factory ini yang 'mengkonversi' JSON jadi Objek Dart
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'], // Ambil 'id' dari JSON
      name: json['name'], // Ambil 'name' dari JSON
      price: json['price'], // Ambil 'price' dari JSON
      
      // PENTING: Ambil 'Description' (D besar) dari JSON
      // dan masukkan ke variabel 'description' (d kecil)
      description: json['Description'], 
    );
  }
}