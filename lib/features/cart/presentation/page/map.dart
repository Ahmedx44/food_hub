import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MyMapp extends StatefulWidget {
  final Position position;
  const MyMapp({super.key, required this.position});

  @override
  State<MyMapp> createState() => _MyMappState();
}

class _MyMappState extends State<MyMapp> {
  late LatLng _currentLocation; // Track the current marker location

  @override
  void initState() {
    super.initState();
    // Set initial marker location to the user's current position
    _currentLocation =
        LatLng(widget.position.latitude, widget.position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mark Your Delivery Location',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _currentLocation,
          initialZoom: 15.0,
          onTap: (tapPosition, point) {
            // Allow the user to change the marker position by tapping the map
            setState(() {
              _currentLocation = point;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point:
                    LatLng(widget.position.latitude, widget.position.longitude),
                width: 80,
                height: 80,
                child: Icon(Icons.place),
              ),
            ],
          ),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () =>
                    launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}