import 'package:flutter/material.dart';
import '../../map/models/station_model.dart';
import '../services/dock_service.dart';

class PaymentScreen extends StatefulWidget {
  final String userId;
  final String dockId;
  final StationModel startStation;
  final StationModel endStation;

  const PaymentScreen({
    super.key,
    required this.userId,
    required this.dockId,
    required this.startStation,
    required this.endStation,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isUnlocking = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Confirm Payment")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ride Summary",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _infoRow("Start Station", widget.startStation.name),
            _infoRow("End Station", widget.endStation.name),
            _infoRow("Dock ID", widget.dockId),

            const Divider(height: 32),

            const Text("Amount to Pay", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            const Text(
              "20 Birr",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: isUnlocking
                    ? null
                    : () async {
                        setState(() => isUnlocking = true);

                        try {
                          await DockService.unlockDock(
                            dockId: widget.dockId,
                            userId: widget.userId,
                          );

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Bike unlocked successfully!"),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Unlock failed: $e"),
                              ),
                            );
                          }
                        } finally {
                          setState(() => isUnlocking = false);
                        }
                      },
                child: isUnlocking
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "UNLOCK BIKE",
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
