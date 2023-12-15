import 'package:bisa/firestore_dataUser.dart';
import 'package:flutter/material.dart';
// import 'package:projecttest/firestore_dataUser.dart';

class CartScreen extends StatefulWidget {
  // final List<String> cartItems;

  CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<String> cartItems = []; // Initialize an empty list

  @override
  void initState() {
    super.initState();
    // Fetch cart items from Firestore when the screen is initialized
    Firestore_Datasource().getCartItems().then((items) {
      setState(() {
        cartItems = items;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Keranjang'),
            const Spacer(),
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    // Return the result to the previous screen
                    Navigator.pop(context);
                  },
                ),
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      cartItems.length.toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 8, 32, 73),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(cartItems[index]),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  cartItems.removeAt(index);
                  Firestore_Datasource().deleteCart(cartItems);
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Clear all items from the cartItems list
          setState(() {
            cartItems.clear();
            Firestore_Datasource().deleteCart(cartItems);
          });

          // Return the result to the previous screen
          Navigator.pop(context);
        },
        child: const Icon(Icons.delete),
      ),
    );
  }
}
