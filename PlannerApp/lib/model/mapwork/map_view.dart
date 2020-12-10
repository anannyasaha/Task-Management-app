import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';

import 'location.dart';

class MapView extends StatefulWidget {
  MapView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  var _geolocator = Geolocator();

  MapController _mapController = MapController();

  List<Location> _locations;
  LatLng _centre;
  double _zoom;

  @override
  void initState() {
    super.initState();

    _locations = [];
    _zoom = 15.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.zoom_in),
              onPressed: () {
                _geolocator
                    .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
                    .then((Position userLocation) {
                  _geolocator
                      .placemarkFromCoordinates(
                          userLocation.latitude, userLocation.longitude)
                      .then((List<Placemark> places) {
                    setState(() {
                      _zoom = _zoom + 1.0;

                      LatLng _centre =
                          LatLng(userLocation.latitude, userLocation.longitude);
                      _mapController.move(_centre, _zoom);
                    });
                  });
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.zoom_out),
              onPressed: () {
                _geolocator
                    .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
                    .then((Position userLocation) {
                  _geolocator
                      .placemarkFromCoordinates(
                          userLocation.latitude, userLocation.longitude)
                      .then((List<Placemark> places) {
                    setState(() {
                      _zoom = _zoom - 1.0;

                      LatLng _centre =
                          LatLng(userLocation.latitude, userLocation.longitude);
                      _mapController.move(_centre, _zoom);
                    });
                  });
                });
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _geolocator
                .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
                .then((Position userLocation) {
              _geolocator
                  .placemarkFromCoordinates(
                      userLocation.latitude, userLocation.longitude)
                  .then((List<Placemark> places) {
                setState(() {
                  String name = '';
                  String address = '';

                  if (places.length > 0) {
                    name = places[0].name;
                    address =
                        '${places[0].subThoroughfare} ${places[0].thoroughfare}';
                  }

                  _zoom = 15.0;

                  LatLng _centre =
                      LatLng(userLocation.latitude, userLocation.longitude);
                  _mapController.move(_centre, _zoom);

                  Location newLocation =
                      Location(latlng: _centre, name: name, address: address);
                  _locations.add(newLocation);
                });
              });
            });
          },
          tooltip: 'Add Location',
          child: Icon(Icons.add),
        ),
        body: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: _centre != null ? _centre : LatLng(43.9458, 78.8960),
            minZoom: 1.0,
            maxZoom: 50.0,
            zoom: _zoom,
          ),
          layers: [
            TileLayerOptions(
              //NOTE:
              //if the current api link doesn't switch to the commented out one

              // urlTemplate:
              // 'https://api.mapbox.com/styles/v1/rfortier/cjzcobx1x2csf1cmppuyzj5ys/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicmZvcnRpZXIiLCJhIjoiY2p6Y282cWV4MDg0ZDNibG9zdWZ6M3YzciJ9.p1ePjCH-zs0RdBbLx40pgQ',

              // additionalOptions: {
              //     'accessToken': 'pk.eyJ1IjoicmZvcnRpZXIiLCJhIjoiY2p6Y282cWV4MDg0ZDNibG9zdWZ6M3YzciJ9.p1ePjCH-zs0RdBbLx40pgQ',
              //     'id': 'mapbox.mapbox-streets-v8'
              // }
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayerOptions(
                markers: _locations
                    .map(
                      (location) => Marker(
                        width: 45.0,
                        height: 45.0,
                        point: location.latlng,
                        anchorPos: AnchorPos.align(AnchorAlign.center),
                        builder: (context) => IconButton(
                          icon: Icon(Icons.brightness_1),
                          color: Colors.blue,
                          iconSize: 25.0,
                          onPressed: () {
                            print(
                                'Location info: ${location.name}, ${location.address},');
                          },
                        ),
                      ),
                    )
                    .toList()),
            PolylineLayerOptions(
              polylines: [
                Polyline(
                  points:
                      _locations.map((location) => location.latlng).toList(),
                  strokeWidth: 4.0,
                  color: Colors.blue,
                ),
              ],
            ),
          ],
        ));
  }
}
