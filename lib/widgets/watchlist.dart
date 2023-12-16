// watchlist.dart
import 'package:bisa/firestore_dataUser.dart';

import '../dummy_data.dart';

class WatchList {
  static List<int> watchedIndexes = [];

  static Future<void> toggleWatch(int index) async {
    if (watchedIndexes.contains(index)) {
      watchedIndexes.remove(index);
    } else {
      watchedIndexes.add(index);
    }
    await Firestore_Datasource().addWatchlist(watchedIndexes);
  }

  static List<Data> getWatchedRecipes() {
    return watchedIndexes.map((index) => dataMasak[index]).toList();
  }
}
