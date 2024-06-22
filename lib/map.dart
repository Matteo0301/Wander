import 'dart:convert';
import 'dart:io';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:wander/assistant.dart';
import 'package:wander/chat.dart';
import 'package:wander/theme.dart';
import 'package:http/http.dart' as http;
import 'secrets.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

class Segment {
  final LatLng start,end;

  Segment({required this.start, required this.end});
}

class Path {
  final List<LatLng> markers;
  final List<Segment> segments;

  Path({required this.markers, required this.segments});
}

class WanderMap extends StatefulWidget {
  const WanderMap({super.key});
  final BorderRadius borderRadius = MyTheme.windowBorderRadius;

  static const double zoomUpdate = 0.5;
  

  static Future<LatLng> address2Coordinates(String address) async {
    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeFull(address)}&key=$mapsAPI';
    try {
      final response = await http.get(Uri.parse(url));
      //debugPrint(response.body);
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        if (res['status'] == 'OK') {
          var lat = res['results'][0]['geometry']['location']['lat'];
          var lng = res['results'][0]['geometry']['location']['lng'];
          debugPrint(LatLng(lat, lng).toString());
          return LatLng(lat, lng);
        } else {
          return Future.error('Unknown address');
        }
      } else {
        return Future.error('Error during the operation');
      }
    } catch (e) {
      return Future.error('Server unreachable');
    }
  }

  static Future<List<Segment>> getPath(List<LatLng> coords) async {
    if(coords.length <= 1){
      return [];
    }
    var c = coords.map((e) => "${e.latitude},${e.longitude}").toList().sublist(1).toList().reversed.toList().sublist(1);
    String waypoints = (c.isNotEmpty)?"&waypoints=optimize:true|${c.join('|')}":"";
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${coords[0].latitude},${coords[0].longitude}&destination=${coords[coords.length-1].latitude},${coords[coords.length-1].longitude}$waypoints&key=$mapsAPI';
    try {
      final response = await http.get(Uri.parse(url));
      //debugPrint(response.body);
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        //print(res);
        var legs = res["routes"][0]["legs"];
        List<Segment> path = [];
        for(int i=0;i<legs.length;i++){
          path.add(Segment(start: LatLng(legs[i]["start_location"]["lat"],
                  legs[i]["start_location"]["lng"]), 
                  end: LatLng(legs[i]["end_location"]["lat"],
                  legs[i]["end_location"]["lng"])));
        }
        return path;
      } else {
        return Future.error('Error during the operation');
      }
    } catch (e) {
      debugPrint(e.toString());
      return Future.error('Server unreachable');
    }
  }


  static Future<Path> createItinerary(List<String> places) async {
    List<LatLng> coords = [];
    for(int i=0;i<places.length;i++){
      coords.add(await address2Coordinates(places[i]));
    }
    var path = await getPath(coords);
    return Path(markers: coords, segments: path);
  }

  @override
  State<StatefulWidget> createState() => MapState();
}

class MapState extends State<WanderMap>{
  static List<String> places = [];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: WanderMap.createItinerary(places),
      builder: (context, snapshot) {
        if (!snapshot.hasData && !snapshot.hasError) {
          return const CircularProgressIndicator();
        }
        final CurrentLocationLayer locLayer =
            CurrentLocationLayer(alignPositionOnUpdate: AlignOnUpdate.once);
        List<Marker> markers = [];
        List<LatLng> line = [];
        if (!snapshot.hasError && snapshot.data != null) {
          for (var element in snapshot.data!.markers) {
            markers.add(Marker(
                point: element,
                height: 50,
                width: 50,
                child: const Icon(
                  Icons.place,
                  color: Colors.red,
                )));
          }
          if (snapshot.data!.segments.isNotEmpty) {
            line.add(snapshot.data!.segments[0].start);
            for (var element in snapshot.data!.segments) {
              line.add(element.end);
            }
          }
        }
        return FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(51.509364, -0.128928),
            initialZoom: 16,
          ),
          children: [
            TileLayer(
              //tileProvider: CancellableNetworkTileProvider(),
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Column(
                verticalDirection: VerticalDirection.down,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Padding(
                        padding: MyTheme.padding,
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ChatPage()));
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue.shade200),
                            fixedSize: MaterialStateProperty.all(const Size(
                                MyTheme.buttonSize, MyTheme.buttonSize)),
                            iconSize: MaterialStateProperty.all(
                                MyTheme.buttonIconSize),
                          ),
                          icon: const Icon(Icons.help_outline),
                        )),
                  ),
                  const ZoomInButton(),
                  const ZoomOutButton(),
                  CenterButton(locLayer: locLayer),
                  /* AudioButton(
                      color: Colors.purple,
                      afterStopped: (path) async {
                        String transcription = await widget.audioTranscribe(path);
                        var p =
                            jsonDecode(await widget.getResponse(transcription, []));
                        debugPrint(p);
                        setState(() {
                          places.add(p["places"]);
                        });
                      }) */
                  Padding(
                      padding: MyTheme.padding,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue.shade200),
                          fixedSize: MaterialStateProperty.all(const Size(
                              MyTheme.buttonSize, MyTheme.buttonSize)),
                          iconSize:
                              MaterialStateProperty.all(MyTheme.buttonIconSize),
                        ),
                        icon: const Icon(Icons.replay),
                      ))
                ],
              ),
            ),
            locLayer,
            MarkerLayer(markers: markers),
            PolylineLayer(
                polylines: [Polyline(points: line, color: Colors.orange, borderStrokeWidth: 3.0, borderColor: Colors.orange)]),
          ],
        );
      },
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
