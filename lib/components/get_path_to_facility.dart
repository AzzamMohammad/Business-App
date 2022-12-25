import 'package:location/location.dart';
import 'package:map_launcher/map_launcher.dart';

class GetPathToFacility {
  late double facilityX;
  late double facilityY;
  double? userX;
  double? userY;

  GetPathToFacility({
    required this.facilityX,
    required this.facilityY
  });


  Future<void> GetUserLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.onLocationChanged.listen((LocationData currentLocation) {
        userX = currentLocation.longitude;
        userY = currentLocation.latitude;

    });

    _locationData = await location.getLocation();


    userY = _locationData.longitude;
    userX = _locationData.latitude;
    print('x = ${userX}');
    print('y = ${userY}');
  }

  void GetPath() async {
    await GetUserLocation();
    if (await MapLauncher.isMapAvailable(MapType.google) == true) {
      await MapLauncher.showMarker(
        mapType: MapType.google,
        coords: Coords(userX!, userY!),
        title: 'facility',
        // description: description,
      );

      await MapLauncher.showMarker(
        mapType: MapType.google,
        coords: Coords(facilityX, facilityY),
        title: 'facility',
        // description: description,
      );
      print('x1 = ${facilityX}');
      print('y1 = ${facilityY}');
      await MapLauncher.showDirections(
        mapType: MapType.google, destination: Coords(userX!, userY!) ,
        origin: Coords(userX!, userY!) ,
      );
    }
  }
}