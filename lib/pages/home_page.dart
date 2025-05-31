import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_coder/pages/atto.dart';
import 'package:qr_coder/pages/generate_qr_code.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isScanning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Coder'), actions: [
        IconButton(
          icon: Icon(Icons.qr_code_2_rounded),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GenerateQrCode(),
            ),
          ),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        child: const Text(
          'A',
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Atto(),
          ),
        ),
      ),
      body: !isScanning
          ? Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isScanning = true;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Scan QR Code',
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                ),
              ),
            )
          : AlertDialog(
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      isScanning = false;
                    });
                  },
                  child: const Text('Stop Scanning'),
                ),
              ],
              title: const Text('Scanning...'),
              content: SizedBox(
                height: 300,
                width: 300,
                child: MobileScanner(
                  controller: MobileScannerController(
                    detectionSpeed: DetectionSpeed.noDuplicates,
                    returnImage: true,
                  ),
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    final Uint8List? image = capture.image;
                    for (var barcode in barcodes) {
                      print('Barcode found! ${barcode.rawValue}');
                    }
                    if (image != null) {
                      setState(
                        () {
                          isScanning = false;
                        },
                      );
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Close'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Clipboard.setData(
                                      ClipboardData(
                                          text: barcodes.first.rawValue ?? " "),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Copied to clipboard'),
                                      ),
                                    );
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Copy result',
                                  ),
                                ),
                              ],
                              title: Text(
                                  barcodes.first.rawValue ?? "No data found!"),
                              content: Image(
                                image: MemoryImage(image),
                              ),
                            );
                          });
                    }
                  },
                ),
              ),
            ),
    );
  }
}
