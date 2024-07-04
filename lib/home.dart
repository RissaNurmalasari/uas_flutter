import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toko_buku/Akun.dart';
import 'package:toko_buku/pesanan.dart';
import 'package:toko_buku/chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ProductItem> products = [];
  String baseUrl = "http://127.0.0.1:8000";

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/api/buku'));

    if (response.statusCode == 200) {
      print(response.body);
      final List<dynamic> productData = json.decode(response.body);
      setState(() {
        products = productData.map((data) {
          return ProductItem(
            id: data['id'],
            name: data['name'],
            price: data['price'],
            imageUrl: data['image_url'],
            discount: data['discount'] ?? '',
            description: data['description'],
          );
        }).toList();
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> tambahKeranjang(String itemId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId =
        prefs.getString('user_id') ?? '636db03a-33a1-4a64-97ea-5713eac1b88e';
    print(userId);
    print(itemId);
    final response = await http.post(
        Uri.parse('$baseUrl/api/pemesanan?user_id=$userId&book_id=$itemId'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        _showSuccessSnackbar();
        fetchProducts();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal Menambahkan barang'),
        ),
      );
    }
  }

  void _showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Berhasil Menambahkan Pesanan'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Books Store'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Add search functionality
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(),
                    ),
                  );
                },
              ),
              Positioned(
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: const Text(
                    '5',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductItemWidget(
            product: product,
            onAddToCart: () {
              tambahKeranjang(product.id); // Use the correct product identifier
            },
          );
        },
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
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PesananScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AkunScreen()),
            );
          }
        },
      ),
    );
  }
}

class ProductItem {
  final String id;
  final String name;
  final String price;
  final String imageUrl;
  final String discount;
  final String description;

  ProductItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.discount,
    required this.description,
  });
}

class ProductItemWidget extends StatelessWidget {
  final ProductItem product;
  final VoidCallback onAddToCart;

  const ProductItemWidget({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(
                id: product.id,
                name: product.name,
                price: product.price,
                imageUrl: product.imageUrl,
                discount: product.discount,
                description: product.description,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.imageUrl, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4.0),
                  if (product.discount.isNotEmpty)
                    Text(
                      product.discount,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                      ),
                    ),
                  const SizedBox(height: 4.0),
                  Text(
                    product.price,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: onAddToCart,
                child: const Text('+ Keranjang'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailsScreen extends StatelessWidget {
  final String id;
  final String name;
  final String price;
  final String imageUrl;
  final String discount;
  final String description;

  const ProductDetailsScreen({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.discount,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(imageUrl, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  if (discount.isNotEmpty)
                    Text(
                      discount,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                  const SizedBox(height: 8.0),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Deskripsi Produk',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Add logic to add the product to cart
                      },
                      child: const Text('+ Keranjang'),
                    ),
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
