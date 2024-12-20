import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_hub/features/home/data/model/cart_model.dart';
import 'package:food_hub/features/home/data/model/favorite_model.dart';

abstract class ItemService {
  Future<Either<String, Stream<QuerySnapshot<Map<String, dynamic>>>>>
      getPopularItems();
  Future<Either<String, String>> addtocart(CartModel cartModel);
  Future<Either<String, String>> addtofavorite(FavoriteModel favoriteModel);
  Future<Either<String, Stream<DocumentSnapshot<Map<String, dynamic>>>>>
      getFavoriteItems();
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

        currentQuantity += int.parse(cartModel.quantity);
        double updatedPrice = double.parse(cartModel.price) * currentQuantity;

        cartItems[itemIndex]['quantity'] = currentQuantity.toString();
        cartItems[itemIndex]['current_price'] = updatedPrice.toStringAsFixed(2);
      } else {
        cartItems.add({
          'name': cartModel.name,
          'image': cartModel.imageUrl,
          'quantity': cartModel.quantity.toString(),
          'original_price': cartModel.price.toString(),
          'current_price': cartModel.price,
          'item_left': cartModel.itemLeft
        });
      }

      totalPrice = cartItems.fold(0.0, (sum, item) {
        final itemPrice = double.tryParse(item['current_price'] ?? '0') ?? 0.0;
        final itemQuantity = int.tryParse(item['quantity'] ?? '0') ?? 0;
        return sum + (itemPrice * itemQuantity);
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

  @override
  Future<Either<String, String>> addtofavorite(
      FavoriteModel favoriteModel) async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final favDocRef = _firebaseFirestore.collection('favorite').doc(userId);

      final favDoc = await favDocRef.get();

      List<Map<String, dynamic>> favoriteItems = [];

      if (favDoc.exists) {
        favoriteItems =
            List<Map<String, dynamic>>.from(favDoc.data()?['items'] ?? []);
      }

      final itemIndex = favoriteItems
          .indexWhere((item) => item['name'] == favoriteModel.name);

      if (itemIndex == -1) {
        favoriteItems.add({
          'name': favoriteModel.name,
          'image': favoriteModel.imageUrl,
          'price': favoriteModel.price.toString(),
          'item_left': favoriteModel.itemLeft,
        });

        await favDocRef.set({
          'items': favoriteItems,
          'updatedAt': Timestamp.now(),
        });

        return const Right('Item added to favorites successfully.');
      } else {
        return const Right('Item is already in favorites.');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Stream<DocumentSnapshot<Map<String, dynamic>>>>>
      getFavoriteItems() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final favoriteItemsStream =
          _firebaseFirestore.collection('favorite').doc(userId).snapshots();

      return Right(favoriteItemsStream);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
