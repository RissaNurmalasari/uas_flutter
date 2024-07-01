import 'package:flutter/material.dart';
import 'package:toko_buku/main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Store'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddProductScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          BookItem(
            title: 'Book 1',
            author: 'Author 1',
            price: 'Rp 50.000',
          ),
          BookItem(
            title: 'Book 2',
            author: 'Author 2',
            price: 'Rp 60.000',
          ),
          BookItem(
            title: 'Book 3',
            author: 'Author 3',
            price: 'Rp 70.000',
          ),
        ],
      ),
    );
  }
}

class BookItem extends StatelessWidget {
  final String title;
  final String author;
  final String price;

  const BookItem({
    super.key,
    required this.title,
    required this.author,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(author),
        trailing: Text(price),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProductScreen(
                title: title,
                author: author,
                price: price,
              ),
            ),
          );
        },
        onLongPress: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Delete Product'),
                content: Text('Are you sure you want to delete this product?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Add logic to delete the product
                      Navigator.of(context).pop();
                    },
                    child: Text('Delete'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          CartItem(
            title: 'Book 1',
            author: 'Author 1',
            price: 'Rp 50.000',
          ),
          CartItem(
            title: 'Book 2',
            author: 'Author 2',
            price: 'Rp 60.000',
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Add logic to perform checkout
          },
          child: Text('Checkout'),
        ),
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final String title;
  final String author;
  final String price;

  const CartItem({
    super.key,
    required this.title,
    required this.author,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(author),
        trailing: Text(price),
      ),
    );
  }
}

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Author',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add logic to add the product
              },
              child: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditProductScreen extends StatelessWidget {
  final String title;
  final String author;
  final String price;

  const EditProductScreen({
    super.key,
    required this.title,
    required this.author,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: title),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Author',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: author),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: price),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add logic to edit the product
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
