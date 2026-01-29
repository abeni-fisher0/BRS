import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../map/models/station_model.dart';
import '../../../routes/app_routes.dart';

class ScanQrScreen extends StatefulWidget {
  final StationModel startStation;
  final StationModel endStation;
  final String userId; // pass logged-in user id

  const ScanQrScreen({
    super.key,
    required this.startStation,
    required this.endStation,
    required this.userId,
  });

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  String? scannedDockId;
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Dock QR")),
      body: Column(
        children: [
          // 📷 CAMERA (smaller)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            child: MobileScanner(
              onDetect: (barcodeCapture) {
                final barcode = barcodeCapture.barcodes.first;
                if (barcode.rawValue != null && scannedDockId == null) {
                  setState(() {
                    scannedDockId = barcode.rawValue!;
                  });
                }
              },
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ride Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  _infoRow("Start Station", widget.startStation.name),
                  _infoRow("End Station", widget.endStation.name),
                  _infoRow(
                    "Dock ID",
                    scannedDockId ?? "Scan the dock QR",
                    highlight: scannedDockId != null,
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: scannedDockId != null && !isProcessing
                          ? () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.payment,
                                arguments: {
                                  "userId": widget.userId,
                                  "dockId": scannedDockId!,
                                  "startStation": widget.startStation,
                                  "endStation": widget.endStation,
                                },
                              );
                            }
                          : null,
                      child: const Text("Continue to Payment"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: highlight ? Colors.green : Colors.black87,
                fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
