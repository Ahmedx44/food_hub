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
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final cartDocRef = _firebaseFirestore.collection('carts').doc(userId);

      final cartDoc = await cartDocRef.get();

      List<Map<String, dynamic>> cartItems = [];

      if (cartDoc.exists) {
        cartItems =
            List<Map<String, dynamic>>.from(cartDoc.data()?['items'] ?? []);
      }

      // Find the index of the item in the cart using the 'name'
      final itemIndex =
          cartItems.indexWhere((item) => item['name'] == cartModel.name);

      if (itemIndex >= 0) {
        // If the item exists, update only this specific item's quantity and price
        int currentQuantity = int.parse(
            cartItems[itemIndex]['quantity']); // Current quantity of the item
        double currentPrice = double.parse(
            cartItems[itemIndex]['price']); // Current price of the item

        // Increment quantity by 1 (or any other logic)
        currentQuantity += int.parse(cartModel.quantity.toString());

        // Update the price based on the new quantity
        cartItems[itemIndex]['quantity'] = currentQuantity.toString();
        cartItems[itemIndex]['price'] =
            (currentPrice * currentQuantity).toString();
      } else {
        // If the item is not in the cart, add it as a new item
        cartItems.add({
          'name': cartModel.name,
          'image': cartModel.imageUrl,
          'quantity': cartModel.quantity.toString(),
          'price': cartModel.price.toString(),
          'item_left': cartModel.itemLeft
        });
      }

      // Update the cart document with the modified cart items array
      await cartDocRef.set({
        'items': cartItems,
        'updatedAt': Timestamp.now(), // Update timestamp
      });

      return const Right('Your item has been successfully added to cart');
    } catch (e) {
      return Left(e.toString());
    }
  }
}
