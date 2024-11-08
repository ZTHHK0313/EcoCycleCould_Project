import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../controller/transcription.dart';
import '../controller/recycle_bin.dart';
import '../controller/location.dart';
import '../model/recycle_bin/location.dart';
import '../model/user_infos/user.dart';
import '../model/recycle_bin/capacity.dart';
import '../widgets/recycle_bin.dart';
import 'bookmark.dart';
import 'history.dart';
import 'map.dart';
import 'user_info.dart';

final class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

final class _HomePageState extends State<HomePage> {
  late final AsyncMemoizer<void> _locationPermissionChecker;
  late final StreamController<LatLng> _gpsLocCtrl;

  @override
  void initState() {
    super.initState();
    _locationPermissionChecker = AsyncMemoizer();
    _gpsLocCtrl = StreamController();
    _streamCurrentLocation();
  }

  @override
  void dispose() {
    _gpsLocCtrl.close();
    super.dispose();
  }

  Future<void> _checkLocationPermission(BuildContext context) async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      if (context.mounted) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(const SnackBar(
            content: Text(
                "To show recycle bin in surrounded area, please enable location service.")));
      }
    }

    LocationPermission permission = await Geolocator.checkPermission();

    try {
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
    } catch (err) {
      // Just return default coordinate if throw during request permission.
    }
  }

  void _streamCurrentLocation() async {
    _gpsLocCtrl.add(await obtainCurrentLocation());
  }

  @override
  Widget build(BuildContext context) {
    final currentUsr = context.watch<CurrentUserManager>().current;

    return Scaffold(
      appBar: AppBar(title: FutureBuilder<int>(future: getUserTotalPts(currentUsr), builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text("Pts: ${snapshot.data}");
        }

        return const SizedBox();
      }), actions: <IconButton>[
        // For user info page
        IconButton(
            onPressed: _streamCurrentLocation, icon: const Icon(Icons.refresh))
      ]),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const BookmarkPage()));
          },
          child: const Icon(Icons.favorite_border)),
      drawer: Drawer(
          child: ListView(children: <Widget>[
        // Dismiss drawer
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: const EdgeInsets.all(12),
                child: IconButton(
                    onPressed: () {
                      Navigator.pop<void>(context);
                    },
                    icon: const Icon(Icons.arrow_back)))),
        // Show history
        ListTile(
            leading: const Icon(FontAwesomeIcons.clock),
            title: const Text("Reward history"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HistoryPage()));
            }),
        // Open map
        ListTile(
            leading: const Icon(FontAwesomeIcons.locationDot),
            title: const Text("Find recycle bin"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RecycleBinMapPage()));
            }),
        // User info
        ListTile(
            leading: const Icon(Icons.person),
            title: const Text("User information"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserInfoPage()));
            })
      ])),
      body: FutureBuilder<void>(
          future: _locationPermissionChecker
              .runOnce(() => _checkLocationPermission(context)),
          builder: (context, snapshot) => _HomeBody(_gpsLocCtrl.stream)),
    );
  }
}

class _HomeBody extends StatelessWidget {
  final Stream<LatLng> gpsLocStream;

  const _HomeBody(this.gpsLocStream, {super.key});

  Future<(RecycleBinLocation, RemainCapacity)> _obtainNearestRecycleBinLocation(
      User usr, LatLng currentLoc) async {
    final nearestBin = (await loadBookmarkedRecycleBins(usr)).map((e) {
      DistanceCalculator distCalc = const Distance();

      return (e, distCalc.distance(currentLoc, e.$1.coordinate));
    }).reduce((t1, t2) {
      var (rb1, dist1) = t1;
      var (rb2, dist2) = t2;

      return dist1 > dist2 ? t2 : t1;
    });

    return nearestBin.$1;
  }

  @override
  Widget build(BuildContext context) {
    final usrMgr = context.watch<CurrentUserManager>();

    return StreamBuilder<LatLng>(
        stream: gpsLocStream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Location service temproary unavailable.")));
              }

              return FutureBuilder<(RecycleBinLocation, RemainCapacity)>(
                  future: _obtainNearestRecycleBinLocation(
                      usrMgr.current, snapshot.data!),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        return const CircularProgressIndicator();
                      case ConnectionState.done:
                        if (snapshot.hasData) {
                          var (rbLoc, rbCap) = snapshot.data!;

                          return ListView(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              shrinkWrap: true,
                              children: <RecycleBinStatusInfo>[
                                RecycleBinStatusInfo(rbLoc, rbCap)
                              ]);
                        } else if (snapshot.hasError) {
                          if (snapshot.error is StateError) {
                            return const Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Icon(Icons.delete_forever_outlined,
                                          size: 48)),
                                  Text("Your recycle bin bookmark is empty.",
                                      style: TextStyle(fontSize: 18),
                                      textAlign: TextAlign.center)
                                ]));
                          }

                          return const Center(
                              child: Column(
                            children: [
                              Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Icon(Icons.error_outline, size: 36)),
                              Text(
                                  "Cannot load nearest bookmarked recycle bin.")
                            ],
                          ));
                        }
                      default:
                        break;
                    }

                    return const SizedBox();
                  });
            default:
              break;
          }

          return const SizedBox();
        });
  }
}
