import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<CartItem> _cartItems = [];
  int _grandTotal = 0;
  String baseUrl = "http://127.0.0.1:8000";
  @override
  void initState() {
    super.initState();
    _getData();
    // Panggil fungsi untuk mengambil data saat inisialisasi state
  }

  int _parsePrice(String priceString) {
    try {
      return int.parse(priceString);
    } catch (e) {
      print('Error parsing price: $e');
      return 0; // default value or handle error as needed
    }
  }

  void _removeItem(CartItem item) {
    setState(() {
      _cartItems.remove(item);
    });
  }

  Future<void> _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId =
        prefs.getString('user_id') ?? '636db03a-33a1-4a64-97ea-5713eac1b88e';

    try {
      // Kirim permintaan HTTP ke server
      final response = await http.get(
        Uri.parse('$baseUrl/api/pemesanangetone?user_id=$userId'),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        setState(() {
          _grandTotal = responseBody['grandTotal'] ?? 0;
        });
        print("Grand Total: ${responseBody['grandTotal']}");
        if (responseBody.containsKey('pemesanan')) {
          List<dynamic> pemesananData = responseBody['pemesanan'];

          setState(() {
            _cartItems = pemesananData
                .map((item) => CartItem(
                      id: item['id'] ?? '',
                      name: item['book_name'] ?? '',
                      price: item['price'] ?? '',
                      originalPrice: item['price'] ?? '',
                    ))
                .toList();
          });
        }
      } else {
        // Gagal karena status code lain (misalnya, 401 Unauthorized)
        print('Gagal mengambil data pemesanan');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Berhasil Menghapus Pesanan'),
      ),
    );
  }

  void _deleteItem(String itemId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/pemesanandelete?id=$itemId'),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        _cartItems.removeWhere((item) => item.id == itemId);
        _getData();
        _showSuccessSnackbar();
      });

      print('Item dengan ID $itemId berhasil dihapus');
    } else {
      // Gagal menghapus item
      print('Gagal menghapus item dengan ID $itemId');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Keranjang'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                final item = _cartItems[index];
                return CartItemWidget(
                  item: item,
                  onRemoveItem: (String itemId) {
                    _deleteItem(itemId);
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Harga',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Rp $_grandTotal',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Add logic to perform checkout
                  },
                  child: const Text('Checkout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CartItem {
  final String id;
  final String name;
  final String price;
  final String originalPrice;
  // final String imageUrl;
  // int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.originalPrice,
    // required this.imageUrl,
    // this.quantity = 1,
  });
}

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final Function(String)
      onRemoveItem; // Perubahan ini untuk menerima String itemId
  const CartItemWidget({
    Key? key,
    required this.item,
    required this.onRemoveItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text(
                        item.price,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (item.originalPrice.isNotEmpty)
                        Text(
                          ' (${item.originalPrice})',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => onRemoveItem(
                            item.id), // Panggil onRemoveItem dengan itemId
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
