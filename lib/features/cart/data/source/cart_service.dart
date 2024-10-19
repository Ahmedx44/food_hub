import 'package:dartz/dartz.dart';
import 'package:food_hub/features/home/domain/entity/cart_entity.dart';
import 'package:hive/hive.dart';

abstract class CartService {
  Future<Either<String, List<CartItem>>> getcart();
}

class CartServiceImpl extends CartService {
  @override
  Future<Either<String, List<CartItem>>> getcart() async {
    final box = Hive.box<CartItem>('cart_item');

    try {
      final list = box.values.toList();
      print('helooooooooooooooooooooooooooooo');
      print(list);
      return Right(list);
    } catch (e) {
      return const Left('Cant retrive cart');
    }
  }
}
