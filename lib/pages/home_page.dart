import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_coder/pages/atto.dart';
import 'package:qr_coder/pages/generate_qr_code.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

      body:MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
returnImage: true,
        ),
        onDetect: (capture){
          final List<Barcode> barcodes=capture.barcodes;
          final Uint8List? image=capture.image;
          for(var barcode in barcodes){
            print('Barcode found! ${barcode.rawValue}');
          }
          if(image != null){
            showDialog(context: context, builder: (context){
              return AlertDialog(
                title: Text(barcodes.first.rawValue??"No data found!"),
                content: Image(image: MemoryImage(image)),
              );
            });
          }
        },
      )
    );
  }
}
