import 'package:dartz/dartz.dart';
import 'package:food_hub/features/home/domain/repository/location_repository.dart';
import 'package:food_hub/service_locator.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';

class LocationRepositoyImpl extends LocationRepository {
  @override
  Future<Either<String, Position>> getlocation() async {
    return await sl<LocationRepository>().getlocation();
  }
}
