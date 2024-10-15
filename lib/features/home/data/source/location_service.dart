import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';

abstract class LocationService {
  Future<Either<String, Position>> getLocation();
}

class LocationServiceImpl extends LocationService {
  @override
  Future<Either<String, Position>> getLocation() async {
    try {
      // Test if location services are enabled.
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const Left('Location services are disabled.');
      }

      // Check for permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return const Left('Location permissions are denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return const Left('Location permissions are permanently denied.');
      }

      // Get the current location
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
        ),
      );

      // Return the Position object directly
      return Right(position);
    } catch (e) {
      // Handle any other errors
      return Left('Failed to get location: ${e.toString()}');
    }
  }
}
