import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/map_controller.dart';
import '../models/station_model.dart';
import '../../ride/screens/scan_qr_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final fm.MapController _mapController = fm.MapController();

  final TextEditingController _startCtrl = TextEditingController();
  final TextEditingController _endCtrl = TextEditingController();

  bool selectingStart = true;
  String? userId;

  @override
void initState() {
  super.initState();
  context.read<MapController>().loadStations();
  _loadUserId(); 
}

Future<void> _loadUserId() async {
  final prefs = await SharedPreferences.getInstance();
  userId = prefs.getString('userId');
}


  void _selectStation(StationModel station, MapController map) {
    if (selectingStart) {
      map.selectStartStation(station);
      _startCtrl.text = station.name;
      selectingStart = false;
    } else {
      map.selectEndStation(station);
      _endCtrl.text = station.name;
    }

    map.filteredStations = [];
    map.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    final map = context.watch<MapController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Select Stations")),
      body: Column(
        children: [
          // 🚏 START & END SEARCH FIELDS
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _searchField(
                  label: "Start Station",
                  controller: _startCtrl,
                  map: map,
                  isStart: true,
                ),
                const SizedBox(height: 10),
                _searchField(
                  label: "End Station",
                  controller: _endCtrl,
                  map: map,
                  isStart: false,
                ),
              ],
            ),
          ),

          // 🔽 SEARCH DROPDOWN RESULTS
          if (map.filteredStations.isNotEmpty)
            Container(
              height: 120,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 4),
                ],
              ),
              child: ListView.builder(
                itemCount: map.filteredStations.length,
                itemBuilder: (_, i) {
                  final s = map.filteredStations[i];
                  return ListTile(
                    title: Text(s.name),
                    subtitle: Text("Bikes: ${s.availableBikes}"),
                    onTap: () => _selectStation(s, map),
                  );
                },
              ),
            ),

          // 🗺 MAP
          Expanded(
            child: fm.FlutterMap(
              mapController: _mapController,
              options: fm.MapOptions(
                initialCenter: const LatLng(9.03, 38.74),
                initialZoom: 13,
              ),
              children: [
                fm.TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                ),

                // 📍 STATION MARKERS (ALL STATIONS)
                fm.MarkerLayer(
                  markers: map.stations.map((s) {
                    final isStart = map.startStation?.id == s.id;
                    final isEnd = map.endStation?.id == s.id;

                    return fm.Marker(
                      point: LatLng(s.latitude, s.longitude),
                      width: 40,
                      height: 40,
                      child: GestureDetector(
                        onTap: () => _selectStation(s, map),
                        child: Icon(
                          Icons.location_on,
                          size: 40,
                          color: isStart
                              ? Colors.green
                              : isEnd
                                  ? Colors.blue
                                  : Colors.red,
                        ),
                      ),
                    );
                  }).toList(),
                ),

                // 🧭 ROUTE LINE
                if (map.startStation != null && map.endStation != null)
                  fm.PolylineLayer(
                    polylines: [
                      fm.Polyline(
                        color: Colors.blue,
                        strokeWidth: 4,
                        points: [
                          LatLng(map.startStation!.latitude,
                              map.startStation!.longitude),
                          LatLng(map.endStation!.latitude,
                              map.endStation!.longitude),
                        ],
                      )
                    ],
                  ),
              ],
            ),
          ),

          // 📋 ALL STATIONS PICKER
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: map.stations.length,
              itemBuilder: (_, i) {
                final s = map.stations[i];
                return GestureDetector(
                  onTap: () => _selectStation(s, map),
                  child: Container(
                    width: 150,
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 4)
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(s.name, textAlign: TextAlign.center),
                        Text("Bikes: ${s.availableBikes}")
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // ▶ NEXT
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: map.canProceed
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ScanQrScreen(
                            userId: userId!,
                            startStation: map.startStation!,
                            endStation: map.endStation!,
                          ),
                        ),
                      );
                    }
                  : null,
              child: const Text("Next"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchField({
    required String label,
    required TextEditingController controller,
    required MapController map,
    required bool isStart,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onTap: () => selectingStart = isStart,
      onChanged: (value) {
        if (value.isNotEmpty) {
          map.searchStations(value); // 🔥 BACKEND SEARCH
        } else {
          map.filteredStations = [];
          map.notifyListeners();
        }
      },
    );
  }
}
