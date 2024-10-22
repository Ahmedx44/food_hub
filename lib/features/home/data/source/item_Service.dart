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
      double totalPrice = 0.0;

      if (cartDoc.exists) {
        cartItems =
            List<Map<String, dynamic>>.from(cartDoc.data()?['items'] ?? []);
      }

      final itemIndex =
          cartItems.indexWhere((item) => item['name'] == cartModel.name);

      if (itemIndex >= 0) {
        int currentQuantity = int.parse(cartItems[itemIndex]['quantity']);
        double currentPrice =
            double.parse(cartItems[itemIndex]['current_price']);

        currentQuantity += int.parse(cartModel.quantity.toString());

        cartItems[itemIndex]['quantity'] = currentQuantity.toString();
        cartItems[itemIndex]['current_price'] =
            (cartModel.price * currentQuantity).toString();
      } else {
        cartItems.add({
          'name': cartModel.name,
          'image': cartModel.imageUrl,
          'quantity': cartModel.quantity.toString(),
          'original_price': cartModel.price.toString(),
          'current_price': cartModel.price.toString(),
          'item_left': cartModel.itemLeft
        });
      }

      totalPrice = cartItems.fold(0.0, (sum, item) {
        return sum +
            (double.parse(item['current_price']) * int.parse(item['quantity']));
      });

      await cartDocRef.set({
        'items': cartItems,
        'total_price': totalPrice.toStringAsFixed(2),
        'updatedAt': Timestamp.now(),
      });

      return const Right('Your item has been successfully added to cart');
    } catch (e) {
      return Left(e.toString());
    }
  }
}
