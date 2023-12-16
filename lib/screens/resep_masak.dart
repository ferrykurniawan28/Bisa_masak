import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bisa/dummy_data.dart';
import 'package:bisa/firestore_dataUser.dart';
import '../widgets/keranjang_bahan.dart';

final db = FirebaseFirestore.instance;

class ResepMasakanScreen extends StatefulWidget {
  final int index;

  const ResepMasakanScreen({Key? key, required this.index}) : super(key: key);

  @override
  _ResepMasakanScreenState createState() => _ResepMasakanScreenState();
}

class _ResepMasakanScreenState extends State<ResepMasakanScreen> {
  List<String> selectedItems = [];
  Map<String, dynamic>? data;
  List<dynamic>? resep;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Resep Masakan'),
            const Spacer(),
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartScreen(),
                      ),
                    );

                    if (result != null) {}
                  },
                ),
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      selectedItems.length.toString(),
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
      backgroundColor: Colors.white,
      body: FutureBuilder<DocumentSnapshot>(
        future:
            db.collection('dataMasak').doc(dataMasak[widget.index].nama).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            ));
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Text('Document does not exist');
          } else {
            // Document exists in the database
            data = snapshot.data!.data() as Map<String, dynamic>;

            // Extract data
            resep = List<String>.from(data!['resep'] ?? []);
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: resep?.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text(resep?[index]),
                            trailing: const Icon(Icons.add),
                            onTap: () {
                              setState(() {
                                // Use a Set for selectedItems
                                selectedItems.add(resep?[index]);
                                Firestore_Datasource()
                                    .AddCart(selectedItems.toList());
                              });
                            },
                          ),
                          const Divider(
                            color: Colors.grey,
                            height: 1.0,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartScreen(),
                      ),
                    );
                    if (result != null) {
                      // Handle the result if needed
                    }
                  },
                  child: const Text('Lanjut'),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
