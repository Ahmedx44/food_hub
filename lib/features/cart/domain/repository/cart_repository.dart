import 'package:dartz/dartz.dart';
import 'package:food_hub/features/home/domain/entity/cart_entity.dart';

abstract class CartRepository {
  Future<Either<String, List<CartItem>>> getcart();
}
