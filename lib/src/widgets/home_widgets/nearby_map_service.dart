import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:external_app_launcher/external_app_launcher.dart';

String lat = "";
String long = "";

LocationPermission? locationPermission;

_getLatLong() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  long = position.longitude.toString();
  lat = position.latitude.toString();
}

_getCurrentLocation() async {
  locationPermission = await Geolocator.checkPermission();

  if (locationPermission == LocationPermission.denied) {
    locationPermission = await Geolocator.requestPermission();
    if (locationPermission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: "Location permission permanently denied!");
    }
  }
  Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          forceAndroidLocationManager: true)
      .catchError((e) {
    Fluttertoast.showToast(msg: "Something went wrong!");
    return e;
  });
}

// function to create nearby service button
Widget createNearbyWidget(String path, String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 2.5, right: 2.5),
    child: SizedBox(
      width: 60,
      child: Column(
        children: [
          Card(
            color: const Color(0xffddd6f3),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SizedBox(
              height: 50,
              width: 50,
              child: Center(
                child: Image.asset(
                  path,
                  fit: BoxFit.cover,
                  height: 40,
                ),
              ),
            ),
          ),
          Text(
            text,
            style: const TextStyle(
                fontFamily: 'PTSans-Regular',
                fontSize: 11,
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          )
        ],
      ),
    ),
  );
}

class NearbyMapService extends StatefulWidget {
  const NearbyMapService({super.key});
  static Future<void> openMap(String location) async {
    _getLatLong();
    _getCurrentLocation();
    String googleUrl =
        "https://www.google.com/maps/search/?api=1&query=$location/$lat%2C$long";
    final Uri url = Uri.parse(googleUrl);
    try {
      await launchUrl(url);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Something went wrong! call emergency number");
    }
  }

  @override
  State<NearbyMapService> createState() => _NearbyMapServiceState();
}

class _NearbyMapServiceState extends State<NearbyMapService> {
  @override
  void initState() {
    super.initState();
    _getLatLong();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      width: MediaQuery.of(context).size.width,
      child: const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NearbyPoliceStation(onMapFunction: NearbyMapService.openMap),
            NearbyHospital(onMapFunction: NearbyMapService.openMap),
            NearbyPharmacy(onMapFunction: NearbyMapService.openMap),
            NearbyBusStation(onMapFunction: NearbyMapService.openMap),
          ],
        ),
      ),
    );
  }
}

class NearbyPoliceStation extends StatelessWidget {
  final Function? onMapFunction;
  const NearbyPoliceStation({Key? key, this.onMapFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          await LaunchApp.openApp(
              androidPackageName: 'com.google.android.apps.maps',
              openStore: true);
        },
        child: createNearbyWidget(
            "assets/images/nearby_service/police_station.png",
            "Police Stations"));
  }
}

class NearbyHospital extends StatelessWidget {
  final Function? onMapFunction;
  const NearbyHospital({Key? key, this.onMapFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          await LaunchApp.openApp(
              androidPackageName: 'com.google.android.apps.maps',
              openStore: true
          );
        },
        child: createNearbyWidget(
            "assets/images/nearby_service/hospital.png", "Hospitals"));
  }
}

class NearbyPharmacy extends StatelessWidget {
  final Function? onMapFunction;
  const NearbyPharmacy({Key? key, this.onMapFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          await LaunchApp.openApp(
              androidPackageName: 'com.google.android.apps.maps',
              openStore: true
          );
        },
        child: createNearbyWidget(
            "assets/images/nearby_service/pharmacy.png", "Pharmacy"));
  }
}

class NearbyBusStation extends StatelessWidget {
  final Function? onMapFunction;
  const NearbyBusStation({Key? key, this.onMapFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          await LaunchApp.openApp(
              androidPackageName: 'com.google.android.apps.maps',
              openStore: true
          );
        },
        child: createNearbyWidget(
            "assets/images/nearby_service/bus_station.png", "Bus Stations"));
  }
}
