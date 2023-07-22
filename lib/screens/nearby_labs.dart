import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../apis/apis.dart';
import '../models/laboratory.dart';

class NearbyLabs extends StatefulWidget {
  const NearbyLabs({super.key});

  @override
  State<NearbyLabs> createState() => _NearbyLabsState();
}

class _NearbyLabsState extends State<NearbyLabs> {
  @override
  Widget build(BuildContext context) {
    return LabsList(latitude: 32.571144, longitude: 74.075005);
  }
}

class LabsList extends StatefulWidget {
  final double latitude;
  final double longitude;

  LabsList({required this.latitude, required this.longitude});

  @override
  _LabsListState createState() => _LabsListState();
}

class _LabsListState extends State<LabsList> {
  late List<Laboratory> labs = [];
  double latitude = 0.0; // Variable to hold latitude
  double longitude = 0.0; // Variable to hold longitude

  @override
  void initState() {
    super.initState();
    _fetchLabs();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
      _fetchLabs(); // Fetch labs after getting the location
    } catch (e) {
      print("Error while fetching location: $e");
      // Handle any errors while getting the location
    }
  }

  Future<void> _fetchLabs() async {
    final api = Api('AIzaSyDoFoXFgBBpQRyTcIOCjfkKvjEpGgTjacc');
    final labsData = await api.fetchNearbyLaboratories(latitude, longitude);
    setState(() {
      labs = labsData
          .map((lab) => Laboratory(lab['name'], lab['vicinity']))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Nearby Laboratories'),
      ),
      body: labs != null
          ? ListView.builder(
              itemCount: labs.length,
              itemBuilder: (context, index) {
                final lab = labs[index];
                return SizedBox(
                  height: 150,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      color: Colors.cyan,
                      child: Center(
                        child: ListTile(
                          title: Text(lab.name),
                          subtitle: Text(lab.vicinity),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.directions),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}