import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GpsCaptureWidget extends StatefulWidget {
  const GpsCaptureWidget({
    super.key,
    required this.value,
    required this.onChanged,
    this.geofenceLat,
    this.geofenceLon,
    this.geofenceRadiusKm = 5.0,
  });

  /// Stored as {lat, lon, accuracy} — null if not yet captured.
  final Map<String, dynamic>? value;
  final ValueChanged<Map<String, dynamic>?> onChanged;

  /// Optional geofence center. If provided, a warning is shown when the
  /// captured point is outside [geofenceRadiusKm].
  final double? geofenceLat;
  final double? geofenceLon;
  final double geofenceRadiusKm;

  @override
  State<GpsCaptureWidget> createState() => _GpsCaptureWidgetState();
}

enum _GpsState { idle, requesting, locating, captured, error }

class _GpsCaptureWidgetState extends State<GpsCaptureWidget> {
  _GpsState _state = _GpsState.idle;
  String? _errorMsg;
  bool _geofenceViolation = false;

  @override
  void initState() {
    super.initState();
    if (widget.value != null) {
      _state = _GpsState.captured;
      _checkGeofence(widget.value!['lat'] as double, widget.value!['lon'] as double);
    }
  }

  Future<void> _capture() async {
    setState(() {
      _state = _GpsState.requesting;
      _errorMsg = null;
    });

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() {
        _state = _GpsState.error;
        _errorMsg = permission == LocationPermission.deniedForever
            ? 'Location permission permanently denied. Enable in device settings.'
            : 'Location permission denied.';
      });
      return;
    }

    setState(() => _state = _GpsState.locating);

    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 30),
        ),
      );
      final answer = {
        'lat': pos.latitude,
        'lon': pos.longitude,
        'accuracy': pos.accuracy,
      };
      _checkGeofence(pos.latitude, pos.longitude);
      setState(() => _state = _GpsState.captured);
      widget.onChanged(answer);
    } catch (e) {
      setState(() {
        _state = _GpsState.error;
        _errorMsg = 'Could not get location. Try again.';
      });
    }
  }

  void _clear() {
    setState(() {
      _state = _GpsState.idle;
      _geofenceViolation = false;
    });
    widget.onChanged(null);
  }

  void _checkGeofence(double lat, double lon) {
    if (widget.geofenceLat == null || widget.geofenceLon == null) return;
    final dist = _haversineKm(
        lat, lon, widget.geofenceLat!, widget.geofenceLon!);
    setState(() => _geofenceViolation = dist > widget.geofenceRadiusKm);
  }

  double _haversineKm(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0;
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);
    return r * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  double _deg2rad(double deg) => deg * pi / 180;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_state == _GpsState.captured && widget.value != null) ...[
          _CapturedTile(value: widget.value!, onRetake: _capture, onClear: _clear),
          if (_geofenceViolation)
            _GeofenceWarning(radiusKm: widget.geofenceRadiusKm),
        ] else ...[
          ElevatedButton.icon(
            onPressed: (_state == _GpsState.requesting || _state == _GpsState.locating)
                ? null
                : _capture,
            icon: _state == _GpsState.locating
                ? const SizedBox(
                    width: 16, height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.my_location, size: 18),
            label: Text(_state == _GpsState.requesting
                ? 'Requesting permission…'
                : _state == _GpsState.locating
                    ? 'Locating…'
                    : 'Capture GPS'),
          ),
        ],
        if (_state == _GpsState.error && _errorMsg != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(_errorMsg!,
                style: const TextStyle(color: Colors.red, fontSize: 12)),
          ),
      ],
    );
  }
}

class _CapturedTile extends StatelessWidget {
  const _CapturedTile({
    required this.value,
    required this.onRetake,
    required this.onClear,
  });

  final Map<String, dynamic> value;
  final VoidCallback onRetake;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final lat = (value['lat'] as double).toStringAsFixed(6);
    final lon = (value['lon'] as double).toStringAsFixed(6);
    final acc = (value['accuracy'] as double).toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        border: Border.all(color: Colors.green.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$lat, $lon  (±${acc}m)',
              style: const TextStyle(fontSize: 13, fontFamily: 'monospace'),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, size: 18),
            tooltip: 'Retake',
            onPressed: onRetake,
            visualDensity: VisualDensity.compact,
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            tooltip: 'Clear',
            onPressed: onClear,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

class _GeofenceWarning extends StatelessWidget {
  const _GeofenceWarning({required this.radiusKm});
  final double radiusKm;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        border: Border.all(color: Colors.orange.shade400),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber, color: Colors.orange, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Warning: location is more than ${radiusKm.toStringAsFixed(0)} km '
              'from the assigned census unit.',
              style: const TextStyle(fontSize: 12, color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }
}
