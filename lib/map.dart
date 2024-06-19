import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:wander/assistant.dart';
import 'package:wander/theme.dart';

class WanderMap extends StatelessWidget {
  const WanderMap({super.key});
  final BorderRadius borderRadius = MyTheme.windowBorderRadius;

  static const double zoomUpdate = 0.5;

  @override
  Widget build(BuildContext context) {
    final CurrentLocationLayer locLayer =
        CurrentLocationLayer(alignPositionOnUpdate: AlignOnUpdate.once);
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(51.509364, -0.128928),
        initialZoom: 9.2,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Column(
            verticalDirection: VerticalDirection.up,
            children: [
              Padding(
                  padding: MyTheme.padding,
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Assistant()));
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blue.shade200),
                      fixedSize: MaterialStateProperty.all(
                          const Size(MyTheme.buttonSize, MyTheme.buttonSize)),
                      iconSize:
                          MaterialStateProperty.all(MyTheme.buttonIconSize),
                    ),
                    icon: const Icon(Icons.help_outline),
                  )),
              const ZoomOutButton(),
              const ZoomInButton(),
              CenterButton(locLayer: locLayer),
            ],
          ),
        ),
        locLayer,
      ],
    );
  }
}

class ZoomInButton extends StatelessWidget {
  const ZoomInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: MyTheme.padding,
        child: IconButton(
          onPressed: () {
            MapController.of(context).move(
                MapController.of(context).camera.center,
                MapController.of(context).camera.zoom + WanderMap.zoomUpdate);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.orange.shade200),
            fixedSize: MaterialStateProperty.all(
                const Size(MyTheme.buttonSize, MyTheme.buttonSize)),
            iconSize: MaterialStateProperty.all(MyTheme.buttonIconSize),
          ),
          icon: const Icon(Icons.add),
        ));
  }
}

class ZoomOutButton extends StatelessWidget {
  const ZoomOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: MyTheme.padding,
        child: IconButton(
          onPressed: () {
            MapController.of(context).move(
                MapController.of(context).camera.center,
                MapController.of(context).camera.zoom - WanderMap.zoomUpdate);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.orange.shade200),
            fixedSize: MaterialStateProperty.all(
                const Size(MyTheme.buttonSize, MyTheme.buttonSize)),
            iconSize: MaterialStateProperty.all(MyTheme.buttonIconSize),
          ),
          icon: const Icon(Icons.remove),
        ));
  }
}

class CenterButton extends StatelessWidget {
  const CenterButton({super.key, required this.locLayer});
  final CurrentLocationLayer locLayer;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: MyTheme.padding,
        child: IconButton(
          onPressed: () async {
            final Position pos = (await Geolocator.getCurrentPosition());
            if (context.mounted) {
              MapController.of(context).move(
                  LatLng(pos.latitude, pos.longitude),
                  MapController.of(context).camera.zoom);
            }
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Colors.blueGrey.shade300),
            fixedSize: MaterialStateProperty.all(
                const Size(MyTheme.buttonSize, MyTheme.buttonSize)),
            iconSize: MaterialStateProperty.all(MyTheme.buttonIconSize),
          ),
          icon: const Icon(Icons.gps_fixed),
        ));
  }
}
