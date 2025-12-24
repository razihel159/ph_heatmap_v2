import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class TappablePolygon {
  final String id;
  final String areaName;
  final int userCount;
  final List<LatLng> points;
  final List<List<LatLng>> multiPoints;
  final Color color;

  TappablePolygon({
    required this.id,
    required this.areaName,
    required this.userCount,
    required this.points,
    required this.multiPoints,
    required this.color,
  });
}