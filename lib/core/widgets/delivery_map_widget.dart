import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';
import '../../features/delivery/domain/entities/location_value.dart';

class DeliveryMapWidget extends StatefulWidget {
  final LocationValue pickupLocation;
  final LocationValue dropoffLocation;
  final LocationValue? riderLocation;

  const DeliveryMapWidget({
    super.key,
    required this.pickupLocation,
    required this.dropoffLocation,
    this.riderLocation,
  });

  @override
  State<DeliveryMapWidget> createState() => _DeliveryMapWidgetState();
}

class _DeliveryMapWidgetState extends State<DeliveryMapWidget> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _buildMarkers();
  }

  @override
  void didUpdateWidget(DeliveryMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.riderLocation != oldWidget.riderLocation) {
      _buildMarkers();
    }
  }

  void _buildMarkers() {
    Set<Marker> markers = {};

    markers.add(Marker(
      markerId: const MarkerId('pickup'),
      position: LatLng(widget.pickupLocation.latitude, widget.pickupLocation.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      infoWindow: InfoWindow(title: 'Pickup: ${widget.pickupLocation.address}'),
    ));

    markers.add(Marker(
      markerId: const MarkerId('dropoff'),
      position: LatLng(widget.dropoffLocation.latitude, widget.dropoffLocation.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(title: 'Drop-off: ${widget.dropoffLocation.address}'),
    ));

    if (widget.riderLocation != null) {
      markers.add(Marker(
        markerId: const MarkerId('rider'),
        position: LatLng(widget.riderLocation!.latitude, widget.riderLocation!.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: const InfoWindow(title: 'Rider'),
      ));
    }

    setState(() {
      _markers = markers;
    });
  }

  void _fitBounds() {
    if (_mapController == null) return;

    double minLat = widget.pickupLocation.latitude;
    double maxLat = widget.pickupLocation.latitude;
    double minLng = widget.pickupLocation.longitude;
    double maxLng = widget.pickupLocation.longitude;

    if (widget.dropoffLocation.latitude < minLat) minLat = widget.dropoffLocation.latitude;
    if (widget.dropoffLocation.latitude > maxLat) maxLat = widget.dropoffLocation.latitude;
    if (widget.dropoffLocation.longitude < minLng) minLng = widget.dropoffLocation.longitude;
    if (widget.dropoffLocation.longitude > maxLng) maxLng = widget.dropoffLocation.longitude;

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.pickupLocation.latitude, widget.pickupLocation.longitude),
              zoom: 12,
            ),
            markers: _markers,
            onMapCreated: (controller) {
              _mapController = controller;
              _fitBounds();
            },
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),
          Positioned(
            top: AppDimensions.spacing12,
            right: AppDimensions.spacing12,
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.spacing8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LegendItem(color: AppColors.primary, label: 'Pickup'),
                  const SizedBox(height: AppDimensions.spacing4),
                  _LegendItem(color: AppColors.secondary, label: 'Drop-off'),
                  if (widget.riderLocation != null) ...[
                    const SizedBox(height: AppDimensions.spacing4),
                    _LegendItem(color: AppColors.tertiary, label: 'Rider'),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppDimensions.spacing4),
        Text(label, style: theme.textTheme.labelSmall),
      ],
    );
  }
}
