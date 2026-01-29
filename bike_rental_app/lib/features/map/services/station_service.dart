import '../../../core/services/api_service.dart';
import '../models/station_model.dart';

class StationService {
  static Future<List<StationModel>> getStations({String? search}) async {
    final endpoint = search != null && search.isNotEmpty
        ? "/stations?search=$search"
        : "/stations";

    final response = await ApiService.get(endpoint);

    // Ensure you get List<Map<String, dynamic>>
    return (response as List)
        .map((e) => StationModel.fromJson(e))
        .toList();
  }
}
