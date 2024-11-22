import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_hub/features/cart/data/model/in_cart_model.dart';

abstract class CartService {
  Stream<List<InCartModel>> getCartStream();
  Future<Either<String, String>> removeItem(String productId);
  Future<Either<String, String>> updateQuantity(String itemid, int quantity);
}

class CartServiceImpl extends CartService {
  final String? user = FirebaseAuth.instance.currentUser?.uid;

  @override
  Stream<List<InCartModel>> getCartStream() {
    if (user == null) {
      return Stream.error('User not authenticated');
    }

    return FirebaseFirestore.instance
        .collection('carts')
        .doc(user)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        final List<dynamic> items = snapshot.data()?['items'] ?? [];

        return items.map((item) {
          return InCartModel.fromMap(item);
        }).toList();
      } else {
        return [];
      }
    });
  }

  @override
  Future<Either<String, String>> removeItem(String productId) async {
    try {
      if (user == null) {
        return const Left('User not authenticated');
      }

      final cartDoc = FirebaseFirestore.instance.collection('carts').doc(user);
      final snapshot = await cartDoc.get();

      if (snapshot.exists) {
        final List<dynamic> items = snapshot.data()?['items'] ?? [];
        items.removeWhere((item) => item['name'] == productId);

        await cartDoc.update({'items': items});

        return const Right('Cart removed');
      } else {
        return const Left('Cart not found');
      }
    } catch (e) {
      return Left('Unable to remove item: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, String>> updateQuantity(
      String name, int quantity) async {
    final cartDoc = FirebaseFirestore.instance.collection('carts').doc(user);
    final snapshot = await cartDoc.get();

    try {
      if (!snapshot.exists) {
        return const Left('Cart not found');
      }

      final List<dynamic> items = snapshot.data()?['items'] ?? [];

      // Find the index of the item to update
      final int itemIndex = items.indexWhere((item) => item['name'] == name);

      if (itemIndex == -1) {
        return const Left('Item not found in cart');
      }

      // Update the quantity of the specific item
      items[itemIndex]['quantity'] = quantity.toString();
      items[itemIndex]['current_price'] =
          (double.parse(items[itemIndex]['original_price']) *
                  int.parse(items[itemIndex]['quantity']))
              .toString();

      // Update the entire 'items' array in Firestore
      await cartDoc.update({'items': items});

      return const Right('Quantity updated successfully');
    } catch (e) {
      return Left('Unable to update quantity: ${e.toString()}');
    }
  }
}
