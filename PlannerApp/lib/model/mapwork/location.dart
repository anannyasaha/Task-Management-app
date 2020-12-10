import 'package:latlong/latlong.dart';

class Location {
  LatLng latlng;
  String name;
  String address;

  Location({this.latlng, this.name, this.address});

  String toString() {
    return 'Location(latlng: $latlng, name: $name, address: $address)';
  }
}
