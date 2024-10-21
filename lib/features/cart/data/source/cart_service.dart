import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_hub/features/home/data/model/cart_model.dart';

abstract class CartService {
  Stream<List<CartModel>> getCartStream();
  Future<Either<String, List<CartModel>>> removeItem(String productId);
  Future<Either<String, String>> updateQuantity(String itemid, int quantity);
}

class CartServiceImpl extends CartService {
  final String? user = FirebaseAuth.instance.currentUser?.uid;

  @override
  Stream<List<CartModel>> getCartStream() {
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

        // Map the items to a list of CartModel
        return items.map((item) {
          return CartModel(
            category: item['category'] ?? '',
            description: item['description'] ?? '',
            imageUrl: item['image'] ?? '',
            itemLeft: item['item_left'] ?? '',
            rating: item['rating'] ?? '',
            id: item['id'] ?? '',
            name: item['name'] ?? 'Unnamed Item',
            quantity: (item['quantity'] ?? '0').toString(),
            price: (item['price'] ?? '0.0'),
          );
        }).toList();
      } else {
        return [];
      }
    });
  }

  @override
  Future<Either<String, List<CartModel>>> removeItem(String productId) async {
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

        return Right(items.map((item) {
          return CartModel(
            category: item['category'] ?? '',
            description: item['description'] ?? '',
            imageUrl: item['image'] ?? '',
            itemLeft: item['itemLeft'] ?? '',
            rating: item['rating'] ?? '',
            id: item['id'] ?? '',
            name: item['name'] ?? 'Unnamed Item',
            quantity: (item['quantity'] ?? '0').toString(),
            price: (item['price'] ?? '0.0'),
          );
        }).toList());
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
      final List<dynamic> items = snapshot.data()?['items'] ?? [];
      items.removeWhere((item) => item['name'] == name);
      await cartDoc.update({'quantity': quantity});
      return Right('increased');
    } catch (e) {
      return Left('Something failed');
    }
  }
}
