import 'package:dartz/dartz.dart';
import 'package:food_hub/features/home/data/source/location_service.dart';
import 'package:food_hub/service_locator.dart';
import 'package:geolocator/geolocator.dart';

class GetLocationUsecase {
  Future<Either<String, Position>> call() async {
    return sl<LocationService>().getLocation();
  }
}
