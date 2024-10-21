import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_hub/features/home/data/model/cart_model.dart';

abstract class ItemService {
  Future<Either<String, Stream<QuerySnapshot<Map<String, dynamic>>>>>
      getPopularItems();
  Future<Either<String, String>> addtocart(CartModel cartModel);
}

class ItemServiceImpl extends ItemService {
  final _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<Either<String, Stream<QuerySnapshot<Map<String, dynamic>>>>>
      getPopularItems() async {
    try {
      final result = _firebaseFirestore
          .collection('foods')
          .where('rating', isGreaterThan: 4.6)
          .snapshots();

      return Right(result);
    } catch (error) {
      return Left(error.toString());
    }
  }

  @override
  Future<Either<String, String>> addtocart(CartModel cartModel) async {
    try {
      // Get the current user ID
      final userId = FirebaseAuth.instance.currentUser!.uid;

      // Reference to the user's cart document
      final cartDocRef = _firebaseFirestore.collection('carts').doc(userId);

      // Get the existing cart items (if any)
      final cartDoc = await cartDocRef.get();

      List<Map<String, dynamic>> cartItems = [];

      if (cartDoc.exists) {
        // If the cart exists, retrieve the existing cart items
        cartItems =
            List<Map<String, dynamic>>.from(cartDoc.data()?['items'] ?? []);
      }

      // Check if the item is already in the cart
      final itemIndex =
          cartItems.indexWhere((item) => item['productId'] == cartModel.id);

      if (itemIndex >= 0) {
        // If the item already exists, update the quantity
        cartItems[itemIndex]['quantity'] += cartModel.quantity;
      } else {
        // If the item doesn't exist, add it to the cart
        cartItems.add({
          'name': cartModel.name,
          'image': cartModel.imageUrl,
          'quantity': cartModel.quantity,
          'price': cartModel.price,
          'item_left': cartModel.itemLeft
        });
      }

      // Update the cart document with the modified cart items array
      await cartDocRef.set({
        'items': cartItems,
        'updatedAt':
            Timestamp.now(), // You can store additional fields like updatedAt
      });

      return const Right('Your item has been successfully added to cart');
    } catch (e) {
      return Left(e.toString());
    }
  }
}
