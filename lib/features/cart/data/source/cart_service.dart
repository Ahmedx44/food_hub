import 'package:dartz/dartz.dart';
import 'package:food_hub/features/home/domain/entity/cart_entity.dart';
import 'package:hive/hive.dart';

abstract class CartService {
  Future<Either<String, List<CartItem>>> getCart();
  Future<Either<String, List<CartItem>>> removeItem(String name);
}

class CartServiceImpl extends CartService {
  @override
  Future<Either<String, List<CartItem>>> getCart() async {
    final box = Hive.box<CartItem>('cart_item');
    try {
      final list = box.values.toList(); // Retrieve all cart items
      return Right(list); // Return list of items
    } catch (e) {
      return const Left('Unable to retrieve cart items');
    }
  }

  @override
  Future<Either<String, List<CartItem>>> removeItem(String name) async {
    final box = Hive.box<CartItem>('cart_item');
    try {
      // Find the item by name and remove it
      final itemToRemove = box.values.firstWhere(
        (item) => item.name == name,
      );

      if (itemToRemove != null) {
        itemToRemove.delete();
        return Right(box.values.toList());
      } else {
        return const Left('Item not found');
      }
    } catch (e) {
      return const Left('Unable to remove item');
    }
  }
}
