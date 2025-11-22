import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../model/cart_item.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final ApiService apiService = ApiService();
  
  // Variabel buat nampung data lokal (biar bisa diedit real-time)
  List<CartItem> localItems = [];
  num localTotal = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  // 1. Ambil data awal dari API pas halaman dibuka
  void _loadCart() async {
    try {
      final data = await apiService.fetchCart();
      setState(() {
        localItems = data['items'];
        localTotal = data['total'];
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // 2. Helper buat hitung ulang total harga manual
  void _recalculateTotal() {
    num tempTotal = 0;
    for (var item in localItems) {
      tempTotal += (item.price * item.quantity);
    }
    setState(() {
      localTotal = tempTotal;
    });
  }

  // 3. Logic Tambah/Kurang Quantity (Optimistic UI)
  void _updateQuantity(int index, int change) async {
    final item = localItems[index];
    final newQty = item.quantity + change;

    // Validasi: Gak boleh kurang dari 1
    if (newQty < 1) return;

    // UPDATE TAMPILAN DULU (Biar user ngerasa cepet)
    setState(() {
      localItems[index] = CartItem(
        id: item.id,
        name: item.name,
        price: item.price,
        quantity: newQty,
      );
      _recalculateTotal(); // Hitung total baru
    });

    // KIRIM REQUEST KE SERVER DI BACKGROUND
    try {
      await apiService.updateCartItem(item.id, newQty);
    } catch (e) {
      print("Gagal update di server: $e");
      // Kalau mau perfect, di sini harusnya ada logic balikin angkanya (rollback)
    }
  }

  // 4. Logic Hapus Item
  void _deleteItem(int index) async {
    final item = localItems[index];

    // HAPUS DARI LAYAR DULU
    setState(() {
      localItems.removeAt(index);
      _recalculateTotal();
    });

    // KIRIM REQUEST HAPUS KE SERVER
    try {
      await apiService.deleteCartItem(item.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.name} berhasil dihapus'),
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      print("Gagal hapus di server: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang Saya'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : localItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.remove_shopping_cart, size: 80, color: Colors.grey[300]),
                      SizedBox(height: 16),
                      Text('Keranjang masih kosong nih.', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // --- BAGIAN LIST ITEM ---
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(12),
                        itemCount: localItems.length,
                        itemBuilder: (context, index) {
                          final item = localItems[index];
                          
                          return Card(
                            elevation: 2,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  // Gambar Produk (Placeholder)
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: Colors.indigo[50],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(Icons.shopping_bag, color: Colors.indigo, size: 30),
                                  ),
                                  SizedBox(width: 16),
                                  
                                  // Info Produk
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item.name, 
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                          maxLines: 1, overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4),
                                        Text('Rp ${item.price}.000', style: TextStyle(color: Colors.indigo)),
                                        
                                        SizedBox(height: 12),
                                        
                                        // Kontrol Quantity (+ Angka -)
                                        Row(
                                          children: [
                                            _buildQtyBtn(Icons.remove, () => _updateQuantity(index, -1)),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 16),
                                              child: Text('${item.quantity}', 
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                            ),
                                            _buildQtyBtn(Icons.add, () => _updateQuantity(index, 1)),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),

                                  // Tombol Hapus (Sampah)
                                  IconButton(
                                    icon: Icon(Icons.delete_outline, color: Colors.red[300]),
                                    onPressed: () => _deleteItem(index),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // --- BAGIAN TOTAL & CHECKOUT ---
                    Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, -5),
                          )
                        ],
                      ),
                      child: SafeArea(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Total Pembayaran', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                                Text(
                                  'Rp $localTotal.000',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Checkout berhasil! Hore! 🎉')),
                                );
                              },
                              child: Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  // Widget kecil buat tombol +/- biar kodingan utamanya rapi
  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        padding: EdgeInsets.all(4),
        child: Icon(icon, size: 16, color: Colors.black87),
      ),
    );
  }
}