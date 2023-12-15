// watchlist.dart
import '../dummy_data.dart';

class WatchList {
  static List<int> watchedIndexes = [];

  static void toggleWatch(int index) {
    if (watchedIndexes.contains(index)) {
      watchedIndexes.remove(index);
    } else {
      watchedIndexes.add(index);
    }
  }

  static List<Data> getWatchedRecipes() {
    return watchedIndexes.map((index) => dataMasak[index]).toList();
  }
}
