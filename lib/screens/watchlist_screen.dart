import 'package:flutter/material.dart';
import 'package:bisa/dummy_data.dart';
import '/widgets/watchlist.dart';
import 'package:bisa/screens/menu_screen.dart';

class WatchListScreen extends StatelessWidget {
  final int index;

  WatchListScreen({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Data> watchedRecipes = WatchList.getWatchedRecipes();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
        backgroundColor: const Color.fromARGB(255, 8, 32, 73),
      ),
      body: watchedRecipes.isEmpty
          ? const Center(
              child: Text('No recipes in watchlist'),
            )
          : ListView.builder(
              itemCount: watchedRecipes.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(watchedRecipes[index].nama),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.check, color: Colors.green),
                        title: Text(watchedRecipes[index].nama),
                        onTap: () {
                          // Find the index of the recipe in the dummy data
                          int recipeIndex = dataMasak.indexWhere((data) =>
                              data.nama.toLowerCase() ==
                              watchedRecipes[index].nama.toLowerCase());

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MenuScreen(index: recipeIndex),
                            ),
                          );
                        },
                      ),
                      const Divider(
                        color: Colors.grey,
                        height: 1.0,
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
