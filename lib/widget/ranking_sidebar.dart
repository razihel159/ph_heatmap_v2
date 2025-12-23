import 'package:flutter/material.dart';
import '../models/tappable_polygon.dart';
import '../utils/map_helpers.dart';

class RankingSidebar extends StatelessWidget {
  final List<TappablePolygon> polygons;
  final bool isLoading;

  const RankingSidebar({
    super.key,
    required this.polygons,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 15,
      top: 15,
      bottom: 15,
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'AREAS LOADED: ${polygons.length}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: polygons.length,
                      itemBuilder: (context, index) {
                        final p = polygons[index];
                        return ListTile(
                          dense: true,
                          title: Text(
                            MapHelpers.formatAreaName(p.areaName),
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                          ),
                          trailing: Text(
                            '${p.userCount}',
                            style: TextStyle(
                              color: MapHelpers.getTextColor(p.userCount),
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}