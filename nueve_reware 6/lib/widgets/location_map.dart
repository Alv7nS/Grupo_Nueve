import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../theme/app_colors.dart';

/// Mapa (OpenStreetMap) com um marcador no local indicado.
/// Requer ligação à internet para carregar os mosaicos do mapa.
class LocationMap extends StatelessWidget {
  final double lat;
  final double lng;
  final String label;
  final double height;

  const LocationMap({
    super.key,
    required this.lat,
    required this.lng,
    required this.label,
    this.height = 240,
  });

  @override
  Widget build(BuildContext context) {
    final point = LatLng(lat, lng);

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: height,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: point,
            initialZoom: 15.5,
            minZoom: 5,
            maxZoom: 18,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'pt.iade.nueve_reware',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: point,
                  width: 48,
                  height: 48,
                  child: Tooltip(
                    message: label,
                    child: const Icon(
                      Icons.location_on,
                      size: 48,
                      color: AppColors.terracotta,
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: const EdgeInsets.all(6),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                color: const Color(0xCCFFFFFF),
                child: const Text(
                  '© OpenStreetMap contributors',
                  style: TextStyle(fontSize: 10, color: AppColors.text),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
