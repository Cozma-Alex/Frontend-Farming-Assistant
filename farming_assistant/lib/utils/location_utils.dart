import 'package:geolocator/geolocator.dart';

Future<Position> detectPosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions permanently denied');
  }

  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    serviceEnabled = await Geolocator.openLocationSettings();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }
  }

  /*Position? lastKnownPosition = await Geolocator.getLastKnownPosition();
  if (lastKnownPosition != null &&
      lastKnownPosition.timestamp
          .isAfter(DateTime.now().subtract(const Duration(minutes: 30)))) {
    return lastKnownPosition;
  }*/

  return await Geolocator.getCurrentPosition();
}