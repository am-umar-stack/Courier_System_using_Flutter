import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/constants/app_constants.dart';

class LocationService {
  final FirebaseFirestore _firestore;
  StreamSubscription<Position>? _positionSubscription;

  LocationService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<bool> checkPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<Position?> getCurrentPosition() async {
    bool hasPermission = await checkPermissions();
    if (!hasPermission) {
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }

  void startTracking({
    required String deliveryId,
    required String riderId,
  }) {
    _positionSubscription?.cancel();

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 50,
    );

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      _updateDeliveryLocation(deliveryId, position);
    });
  }

  void stopTracking() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  Future<void> _updateDeliveryLocation(String deliveryId, Position position) async {
    try {
      await _firestore
          .collection(AppConstants.deliveriesCollection)
          .doc(deliveryId)
          .update({
        'riderLocation': {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'timestamp': Timestamp.fromDate(DateTime.now()),
        },
      });
    } catch (e) {
      // Silently fail - location updates are non-critical
    }
  }

  Stream<Map<String, dynamic>?> watchRiderLocation(String deliveryId) {
    return _firestore
        .collection(AppConstants.deliveriesCollection)
        .doc(deliveryId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        return null;
      }

      Map<String, dynamic>? data = snapshot.data();
      if (data == null || !data.containsKey('riderLocation')) {
        return null;
      }

      Map<String, dynamic> location = data['riderLocation'] as Map<String, dynamic>;
      return {
        'latitude': (location['latitude'] ?? 0.0).toDouble(),
        'longitude': (location['longitude'] ?? 0.0).toDouble(),
      };
    });
  }

  void dispose() {
    stopTracking();
  }
}
