class StationModel {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final int capacity;
  final int availableBikes;

  StationModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.capacity,
    required this.availableBikes,
  });

  factory StationModel.fromJson(Map<String, dynamic> json) {
    final docks = json["docks"] as List<dynamic>;

    final available = docks.where((d) => d["bikeId"] != null).length;

    return StationModel(
      id: json["_id"],
      name: json["name"],
      latitude: (json["lat"] as num).toDouble(),
      longitude: (json["lng"] as num).toDouble(),
      capacity: json["capacity"],
      availableBikes: available,
    );
  }
}
