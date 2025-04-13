import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';
import 'main.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LBSPage extends StatefulWidget {
  const LBSPage({super.key});

  @override
  State<LBSPage> createState() => _LBSPageState();
}

class _LBSPageState extends State<LBSPage> {
  String _locationMessage = "Getting location...";
  String _address = "Address not available";
  bool _isLoading = false;
  double? _latitude;
  double? _longitude;
  List<Position> _locationHistory = [];
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _isTracking = false;

  // Added for OpenStreetMap
  MapController _mapController = MapController();
  List<Marker> _markers = [];
  LatLng _currentPosition = LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  // Add a method to update map markers
  void _updateMapMarkers(Position position) {
    final latLng = LatLng(position.latitude, position.longitude);

    setState(() {
      // Update current position marker
      _currentPosition = latLng;

      // Update the markers list
      _markers = [
        ..._locationHistory
            .map(
              (pos) => Marker(
                width: 40.0,
                height: 40.0,
                point: LatLng(pos.latitude, pos.longitude),
                child: Icon(Icons.location_on, color: Colors.red, size: 30),
              ),
            )
            .toList(),
        // Add current location marker with different color
        Marker(
          width: 40.0,
          height: 40.0,
          point: latLng,
          child: Icon(Icons.my_location, color: Colors.blue, size: 30),
        ),
      ];
    });

    // Move map to current location
    _mapController.move(latLng, 15);
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationMessage =
            "Location services are disabled. Please enable the services";
      });
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationMessage = "Location permissions are denied";
        });
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationMessage =
            "Location permissions are permanently denied, we cannot request permissions.";
      });
      return false;
    }

    return true;
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);

    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _locationMessage =
            "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
        _isLoading = false;

        // Update the current position for the map
        _currentPosition = LatLng(position.latitude, position.longitude);
      });

      // Update map markers
      _updateMapMarkers(position);
      _getAddressFromLatLng(position);
    } catch (e) {
      setState(() {
        _locationMessage = "Error getting location: $e";
        _isLoading = false;
      });
    }
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _address =
              '${place.street}, ${place.subLocality}, '
              '${place.locality}, ${place.postalCode}, '
              '${place.country}';
        });
      }
    } catch (e) {
      setState(() {
        _address = "Error getting address: $e";
      });
    }
  }

  void _toggleTracking() {
    if (_isTracking) {
      _stopTracking();
    } else {
      _startTracking();
    }
  }

  void _startTracking() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    setState(() {
      _isTracking = true;
      _locationHistory.clear();
      _markers = []; // Clear existing markers when starting new tracking
    });

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _locationMessage =
            "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
        _locationHistory.insert(0, position);
      });

      // Update map with new position
      _updateMapMarkers(position);
      _getAddressFromLatLng(position);
    });
  }

  void _stopTracking() {
    _positionStreamSubscription?.cancel();
    setState(() {
      _isTracking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location Tracker')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor,
              Color(0xFF102E40), // Slightly lighter deep blue-teal
              AppTheme.scaffoldBackgroundColor,
            ],
            stops: [0.0, 0.5, 1.0], // Smooth transition points
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 5,
                color: AppTheme.cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Current Location',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.refresh),
                            label: const Text('Refresh'),
                            onPressed: _getCurrentLocation,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.secondaryColor,
                              foregroundColor: AppTheme.scaffoldBackgroundColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow(
                                Icons.location_on,
                                AppTheme.secondaryColor,
                                _locationMessage,
                              ),
                              const SizedBox(height: 10),
                              _buildInfoRow(
                                Icons.home,
                                AppTheme.primaryLightColor,
                                _address,
                              ),
                            ],
                          ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Add OpenStreetMap Card
              Expanded(
                flex: 2,
                child: Card(
                  elevation: 5,
                  color: AppTheme.cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child:
                        (_latitude == null || _longitude == null)
                            ? const Center(
                              child: Text(
                                'Waiting for location...',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                            : FlutterMap(
                              mapController: _mapController,
                              options: MapOptions(
                                center: _currentPosition,
                                zoom: 15,
                                interactiveFlags: InteractiveFlag.all,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key=bDmTXFtHAVG0ucnGY9NC2sfCfAAafYtC',
                                  userAgentPackageName: 'com.example.app',
                                ),
                                MarkerLayer(markers: _markers),
                              ],
                            ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(_isTracking ? Icons.stop : Icons.play_arrow),
                      label: Text(
                        _isTracking ? 'Stop Tracking' : 'Start Tracking',
                      ),
                      onPressed: _toggleTracking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isTracking
                                ? const Color(0xFFCF6679)
                                : const Color(0xFF66BB6A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Card(
                  elevation: 5,
                  color: AppTheme.cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Location History',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child:
                              _locationHistory.isEmpty
                                  ? const Center(
                                    child: Text(
                                      'No location history yet',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  )
                                  : ListView.builder(
                                    itemCount: _locationHistory.length,
                                    itemBuilder: (context, index) {
                                      final position = _locationHistory[index];
                                      return Card(
                                        color: AppTheme.surfaceColor,
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 4,
                                        ),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor:
                                                AppTheme.secondaryColor,
                                            child: Text(
                                              '${index + 1}',
                                              style: const TextStyle(
                                                color: Color(0xFF0C2126),
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            'Lat: ${position.latitude.toStringAsFixed(6)}, '
                                            'Lng: ${position.longitude.toStringAsFixed(6)}',
                                            style: const TextStyle(
                                              fontFamily: 'monospace',
                                              color: Colors.white,
                                            ),
                                          ),
                                          subtitle: Text(
                                            'Altitude: ${position.altitude.toStringAsFixed(2)}m, '
                                            'Speed: ${position.speed.toStringAsFixed(2)} m/s',
                                            style: TextStyle(
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, Color color, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
