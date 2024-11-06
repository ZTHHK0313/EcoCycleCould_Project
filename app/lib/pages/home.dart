import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../controller/location.dart';
import '../model/recycle_bin/location.dart';
import '../model/user_infos/user.dart';
import '../widgets/recycle_bin.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Foo"),
        actions: <IconButton>[
          // For user info page
          IconButton(onPressed: () {}, icon: const Icon(Icons.person))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {}, child: const Icon(Icons.favorite_border)),
      drawer: Drawer(
          child: ListView(children: <Widget>[
        // Dismiss drawer
        Padding(
            padding: const EdgeInsets.all(12),
            child: IconButton(
                onPressed: () {
                  Navigator.pop<void>(context);
                },
                icon: const Icon(Icons.arrow_back))),
        // Show history
        ListTile(
            leading: const Icon(FontAwesomeIcons.clock),
            title: const Text("Reward history"),
            onTap: () {}),
        // Open map
        ListTile(
            leading: const Icon(FontAwesomeIcons.locationDot),
            title: const Text("Find recycle bin"),
            onTap: () {})
      ])),
      body: FutureBuilder<void>(
          future: _checkLocationPermission(context),
          builder: (context, snapshot) => const _HomeBody()),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({super.key});

  Future<RecycleBinLocation> _obtainNearestRecycleBinLocation(User usr) async {
    Iterable<RecycleBinLocation> favRecycleBin = [];
    LatLng currentLoc = await obtainCurrentLocation();

    final nearestBin = favRecycleBin.map((e) {
      DistanceCalculator distCalc = const Distance();

      return (e, distCalc.distance(currentLoc, e.coordinate));
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

    return FutureBuilder<RecycleBinLocation>(
        future: _obtainNearestRecycleBinLocation(usrMgr.current),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              return const CircularProgressIndicator();
            case ConnectionState.done:
              if (snapshot.hasData) {
                return ListView(children: [
                  RecycleBinStatusInfo(snapshot.data!.identifier,
                      key: GlobalKey())
                ]);
              } else if (snapshot.hasError) {
                return const Center(
                    child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.all(16),
                        child: Icon(Icons.error_outline, size: 36)),
                    Text("Cannot load nearest bookmarked recycle bin.")
                  ],
                ));
              }
            default:
              break;
          }

          return const SizedBox();
        });
  }
}
