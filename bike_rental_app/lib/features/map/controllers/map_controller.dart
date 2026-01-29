import 'package:flutter/material.dart';
import '../models/station_model.dart';
import '../services/station_service.dart';

class MapController extends ChangeNotifier {
  List<StationModel> stations = []; // All stations fetched from backend
  List<StationModel> filteredStations = [];

  StationModel? startStation;
  StationModel? endStation;

  bool isLoading = false;

  // Load stations from backend (all stations initially)
  Future<void> loadStations() async {
    isLoading = true;
    notifyListeners();

    stations = await StationService.getStations();
    filteredStations = stations;

    isLoading = false;
    notifyListeners();
  }

  // Fetch stations from backend based on search query
  Future<void> searchStations(String query) async {
    isLoading = true;
    notifyListeners();

    filteredStations = await StationService.getStations(search: query);

    isLoading = false;
    notifyListeners();
  }

  void selectStartStation(StationModel station) {
    startStation = station;
    notifyListeners();
  }

  void selectEndStation(StationModel station) {
    endStation = station;
    notifyListeners();
  }

  bool get canProceed => startStation != null && endStation != null;
}
