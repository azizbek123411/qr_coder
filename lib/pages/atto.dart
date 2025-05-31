import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Atto extends StatefulWidget {
  const Atto({super.key});

  @override
  State<Atto> createState() => _AttoState();
}

class _AttoState extends State<Atto> {
  bool isScanning = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ATTO",
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
                      'ATTO to\'lovi',
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
                                  onPressed: ()async {
                                    
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.transparent,
                                            content: Lottie.asset(
                                              'assets/loading.json',
                                              height: 200,
                                              width: 200,
                                              fit: BoxFit.cover,
                                              repeat: false,
                                            ),
                                          );
                                        }).then((value)=>Navigator.pop(context));
                                    //  Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'To\'lash',
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
