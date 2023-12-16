import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Firestore_Datasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> CreateUser(String email) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set({"id": _auth.currentUser!.uid, "email": email});
      return true;
    } catch (e) {
      print(e);
      return true;
    }
  }

  Future<void> addWatchlist(List<int> index) async {
    try {
      DocumentReference userDocRef = _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('watchlist')
          .doc(_auth.currentUser!.uid);

      // Update the watchlist field in Firestore
      await userDocRef.set({
        'id': _auth.currentUser!.uid,
        'watchlist': index,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> removeFromWatchlist(int index) async {
    try {
      // Get the current watchlist from Firestore
      DocumentReference userDocRef = _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('watchlist')
          .doc(_auth.currentUser!.uid);

      DocumentSnapshot userDoc = await userDocRef.get();

      // Check if the document exists
      if (userDoc.exists) {
        // Get the current watchlist array
        List<int> currentWatchlist =
            List<int>.from(userDoc.get('watchlist') as List<dynamic>? ?? []);

        // Remove the dismissed item from the watchlist
        currentWatchlist.remove(index);

        // Update the watchlist field in Firestore
        await userDocRef.update({
          'watchlist': currentWatchlist,
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Stream<List<String>> get cartItemsStream {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('notes')
        .doc(_auth.currentUser!.uid)
        .snapshots()
        .map((snapshot) {
      // Get the cart items from the snapshot
      List<String> cartItems =
          List<String>.from(snapshot.get('cart') as List<dynamic>? ?? []);
      return cartItems;
    });
  }

  Future<bool> AddCart(List<String> newCart) async {
    try {
      // Get the current cart from Firestore
      DocumentReference userDocRef = _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(_auth.currentUser!.uid);

      DocumentSnapshot userDoc = await userDocRef.get();

      // Check if the document exists
      if (userDoc.exists) {
        // Get the current cart array
        List<String> currentCart =
            List<String>.from(userDoc.get('cart') as List<dynamic>? ?? []);

        // Use a set to ensure unique items
        Set<String> uniqueItems = {...currentCart, ...newCart};

        // Convert back to list
        List<String> updatedCart = uniqueItems.toList();

        // Update the cart field in Firestore
        await userDocRef.update({
          'cart': updatedCart,
        });

        return true;
      } else {
        // If the document does not exist, create a new one
        await userDocRef.set({
          'id': _auth.currentUser!.uid,
          'cart': newCart,
        });

        return true;
      }
    } catch (e) {
      print(e);
      return false; // Return false if there's an error
    }
  }

  Future<bool> deleteCart(List<String> cart) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(_auth.currentUser!.uid)
          .update({
        'id': _auth.currentUser!.uid,
        'cart': cart,
      });
      return true;
    } catch (e) {
      print(e);
      return true;
    }
  }

  Future<List<int>> getWatchlistItems() async {
    try {
      // Get the current cart from Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('watchlist')
          .doc(_auth.currentUser!.uid)
          .get();

      // Check if the document exists
      if (userDoc.exists) {
        // Get the data as a Map<String, dynamic>
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        // Access the 'cart' field and cast it to List<String>
        List<int> currentWatchlist =
            List<int>.from(userData['watchlist'] as List<dynamic>);

        return currentWatchlist;
      } else {
        print('User document does not exist');
        return []; // Return an empty list if the document does not exist
      }
    } catch (e) {
      print(e);
      return []; // Return an empty list if there's an error
    }
  }

  Future<List<String>> getCartItems() async {
    try {
      // Get the current cart from Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(_auth.currentUser!.uid)
          .get();

      // Check if the document exists
      if (userDoc.exists) {
        // Get the data as a Map<String, dynamic>
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        // Access the 'cart' field and cast it to List<String>
        List<String> currentCart =
            List<String>.from(userData['cart'] as List<dynamic>);

        return currentCart;
      } else {
        print('User document does not exist');
        return []; // Return an empty list if the document does not exist
      }
    } catch (e) {
      print(e);
      return []; // Return an empty list if there's an error
    }
  }
}

//   Future<bool> delet_note(String uuid) async {
//     try {
//       await _firestore
//           .collection('users')
//           .doc(_auth.currentUser!.uid)
//           .collection('notes')
//           .doc(uuid)
//           .delete();
//       return true;
//     } catch (e) {
//       print(e);
//       return true;
//     }
//   }
// }

  // Future<bool> AddNote(String subtitle, String title, int image) async {
  //   try {
  //     // var uuid = Uuid().v4();
  //     DateTime data = new DateTime.now();
  //     await _firestore
  //         .collection('users')
  //         .doc(_auth.currentUser!.uid)
  //         .collection('notes')
  //         .doc(_auth.currentUser!.uid)
  //         .set({
  //       'id': _auth.currentUser!.uid,
  //       'subtitle': subtitle,
  //       'isDon': false,
  //       // 'image': image,
  //       'time': '${data.hour}:${data.minute}',
  //       'title': title,
  //     });
  //     return true;
  //   } catch (e) {
  //     print(e);
  //     return true;
  //   }
  // }

  // List getNotes(AsyncSnapshot snapshot) {
  //   try {
  //     final notesList = snapshot.data!.docs.map((doc) {
  //       final data = doc.data() as Map<String, dynamic>;
  //       return Note(
  //         data['id'],
  //         data['subtitle'],
  //         data['time'],
  //         data['image'],
  //         data['title'],
  //         data['isDon'],
  //       );
  //     }).toList();
  //     return notesList;
  //   } catch (e) {
  //     print(e);
  //     return [];
  //   }
  // }

  // Stream<QuerySnapshot> stream(bool isDone) {
  //   return _firestore
  //       .collection('users')
  //       .doc(_auth.currentUser!.uid)
  //       .collection('notes')
  //       // .where('isDon', isEqualTo: isDone)
  //       .snapshots();
  // }

  // Future<bool> isdone(String uuid, bool isDon) async {
  //   try {
  //     await _firestore
  //         .collection('users')
  //         .doc(_auth.currentUser!.uid)
  //         .collection('notes')
  //         .doc(uuid)
  //         .update({'isDon': isDon});
  //     return true;
  //   } catch (e) {
  //     print(e);
  //     return true;
  //   }
  // }

  // Future<bool> Update_Note(
  //     String uuid, int image, String title, String subtitle) async {
  //   try {
  //     DateTime data = new DateTime.now();
  //     await _firestore
  //         .collection('users')
  //         .doc(_auth.currentUser!.uid)
  //         .collection('notes')
  //         .doc(uuid)
  //         .update({
  //       'time': '${data.hour}:${data.minute}',
  //       'subtitle': subtitle,
  //       'title': title,
  //       'image': image,
  //     });
  //     return true;
  //   } catch (e) {
  //     print(e);
  //     return true;
  //   }
  // }

  
