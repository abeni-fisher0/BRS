import '../../../core/services/api_service.dart';

class DockService {
  static Future<void> unlockDock({
    required String dockId,
    required String userId,
  }) async {
    await ApiService.post(
      "/stations/unlock-dock",
      {
        "dockId": dockId,
        "userId": userId,
      },
    );
  }
}
