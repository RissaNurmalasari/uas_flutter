import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toko_buku/Akun.dart';
import 'package:toko_buku/pesanan.dart';
import 'package:toko_buku/chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toko_buku/product_detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ProductItem> products = [];
  String baseUrl = "https://79cb-180-249-184-200.ngrok-free.app";
  String jumlah_pemesanan = '';
  String searchQuery = '';
  List<ProductItem> searchResults = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId =
        prefs.getString('id') ?? '';

    final response =
        await http.get(Uri.parse('$baseUrl/api/buku?user_id=$userId'));
    print(response.body);
    if (response.statusCode == 200) {
      // Parse the response body as a Map<String, dynamic>
      Map<String, dynamic> responseData = json.decode(response.body);

      // Check if the "buku" key exists and is a list
      if (responseData.containsKey('buku') && responseData['buku'] is List) {
        List<dynamic> productData = responseData['buku'];
        int jumlahpesanan = responseData['jumlah_pemesanan'];
        print(jumlahpesanan);
        setState(() {
          jumlah_pemesanan = jumlahpesanan.toString();
          products = productData.map((data) {
            return ProductItem(
              id: data['id'].toString(),
              name: data['name'],
              price: data['price'].toString(),
              imageUrl: data['image_url'],
              discount: data['discount'] ?? '',
              description: data['description'],
            );
          }).toList();
        });
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> tambahKeranjang(String itemId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId =
        prefs.getString('id') ?? '';
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

  void search(String query) {
    setState(() {
      searchQuery = query;
      if (query.isNotEmpty) {
        // Filter products based on the search query
        searchResults = products
            .where((product) =>
                product.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        searchResults.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<ProductItem> displayProducts =
        searchQuery.isNotEmpty ? searchResults : products;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Books Store'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearch(products),
              );
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(),
                    ),
                  );
                  // Refresh data when returning from the cart screen
                  fetchProducts();
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
                  child: Text(
                    jumlah_pemesanan,
                    style: const TextStyle(
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
        itemCount: displayProducts.length,
        itemBuilder: (context, index) {
          final product = displayProducts[index];
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

class ProductItemWidget extends StatelessWidget {
  final ProductItem product;
  final VoidCallback onAddToCart;

  const ProductItemWidget({
    Key? key,
    required this.product,
    required this.onAddToCart,
  }) : super(key: key);

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
  final String baseUrl = "https://79cb-180-249-184-200.ngrok-free.app";

  const ProductDetailsScreen({
    Key? key,
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.discount,
    required this.description,
  }) : super(key: key);

  Future<void> tambahPesanan(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId =
        prefs.getString('id') ?? '';

    final response = await http.post(
      Uri.parse('$baseUrl/api/pemesanan?user_id=$userId&book_id=$id'),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berhasil Menambahkan Pesanan'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal Menambahkan barang'),
        ),
      );
    }
  }

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
                        tambahPesanan(context);
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

class ProductSearch extends SearchDelegate<String> {
  final List<ProductItem> products;

  ProductSearch(this.products);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<ProductItem> searchResults = products
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final product = searchResults[index];
        return ListTile(
          title: Text(product.name),
          onTap: () {
            close(context, product.name);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<ProductItem> suggestionList = query.isEmpty
        ? products
        : products
            .where((product) =>
                product.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final product = suggestionList[index];
        return ListTile(
          title: Text(product.name),
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
        );
      },
    );
  }
}
