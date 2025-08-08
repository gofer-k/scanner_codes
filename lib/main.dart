import 'package:flutter/material.dart';
import 'package:scanner_codes/qr_code_generator.dart';
import 'package:scanner_codes/qr_code_reader.dart';

import 'bar_code_generator.dart';
import 'bar_code_reader.dart';

void main() {
  runApp(const ScannerCodes());
}

class ScannerCodes extends StatelessWidget {
  const ScannerCodes({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scanner codes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white),
        )
      ),
      home: const ScannerCodesHome(title: 'Scanner codes'),
    );
  }
}

class ScannerCodesHome extends StatefulWidget {
  final String title;

  const ScannerCodesHome({super.key, required this.title}  );

  @override
  State<StatefulWidget> createState() => _ScannerCodesHomeState();
}

class _ScannerCodesHomeState extends State<ScannerCodesHome>{

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Colors.blue.shade800,
              Colors.purple.shade300,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Scanner codes",
            style: TextStyle(
              color: Colors.white.withAlpha(192),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Center(
          child: IntrinsicWidth(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                displayButton(context, "Generate QR code", QRCodeGenerator()),
                displayButton(context, "Read QR code", QRCodeReader()),
                displayButton(context, "Generate bar (UPC) code", BarCodeGenerator()),
                displayButton(context, "Read bar (UPC) code", BarCodeReader()),
              ],
            )
          ),
        ),
      ),
    );
  }

  ElevatedButton displayButton<T extends StatefulWidget>(
      BuildContext context, String label, T widget) {
    return ElevatedButton(
      onPressed: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) {
              return widget;
            }),
          ),
        );
      },
      child: Text(label),
    );
  }
}
