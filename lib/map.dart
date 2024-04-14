import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:wander/theme.dart';

class WanderMap extends StatelessWidget {
  const WanderMap({super.key});
  static final MapController controller = MapController(
    initMapWithUserPosition:
        const UserTrackingOption(enableTracking: true, unFollowUser: true),
  );
  final BorderRadius borderRadius = MyTheme.windowBorderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: OSMFlutter(
          controller: controller,
          osmOption: OSMOption(
            userTrackingOption: const UserTrackingOption(
              enableTracking: true,
              unFollowUser: true,
            ),
            zoomOption: const ZoomOption(
              initZoom: 18,
              minZoomLevel: 3,
              maxZoomLevel: 19,
              stepZoom: 1.0,
            ),
            userLocationMarker: UserLocationMaker(
              personMarker: const MarkerIcon(
                icon: Icon(
                  Icons.person_pin_circle,
                  color: Colors.blue,
                  size: MyTheme.locationIconSize,
                ),
              ),
              directionArrowMarker: const MarkerIcon(
                icon: Icon(
                  Icons.double_arrow,
                  size: MyTheme.locationIconSize,
                ),
              ),
            ),
            roadConfiguration: const RoadOption(
              roadColor: Colors.yellowAccent,
            ),
            showZoomController: true,
            showDefaultInfoWindow: true,
            enableRotationByGesture: true,
          )),
    );
  }
}
