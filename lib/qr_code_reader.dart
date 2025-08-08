import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scanner_codes/scanner_overlay_painter.dart';

class QRCodeReader extends StatefulWidget {
  const QRCodeReader({super.key});

  @override
  State<StatefulWidget> createState() => _QRCodeReaderState();
}

class _QRCodeReaderState extends State<QRCodeReader>{
  late List<Barcode> barcodes;

  final MobileScannerController _scannerController = MobileScannerController(
    facing: CameraFacing.back,
    torchEnabled: false,
    formats: [BarcodeFormat.qrCode],
    autoZoom: true,
  );

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  // @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final titleFontSize = screenSize.width < 400 ? 18.0 : 22.0;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Colors.green.shade800,
              Colors.grey.shade300,
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
            "Read QR code",
            style: TextStyle(
              color: Colors.white.withAlpha(192),
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 4,
              child: LayoutBuilder(builder: (context, constraints) {
                final Size layoutSize = constraints.biggest;
                final double scanWindowWidth = 300.0;
                final double scanWindowHeight = 300.0;
                final Rect scanWindow = Rect.fromCenter(
                  center: layoutSize.center(Offset.zero),
                  width: scanWindowWidth,
                  height: scanWindowHeight,
                );
                return Stack(
                  children: [
                    MobileScanner(
                      controller: _scannerController,
                      onDetect: _handleBarcode,
                      scanWindow: scanWindow,
                    ),
                    CustomPaint(
                      painter: ScannerOverlayPainter(
                        scanWindow: scanWindow,
                        borderColor: Colors.white, // Example: Green border
                        borderWidth: 2.0,         // Example: Thicker border
                        borderRadius: 16.0,        // Example: Slightly rounded corners
                        // overlayColor: Colors.black.withOpacity(0.6), // Optional: adjust dimming
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 8,
                      right: 8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          flashButton(),
                          cameraButton(),
                        ],
                      ),)
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget flashButton() {
    return Transform.scale(
      scale: 2.0,
      child: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.transparent,
        onPressed: () => _scannerController.toggleTorch(),
        child:
          ValueListenableBuilder(valueListenable: _scannerController,
          builder: (context, state, child) {
            if (!state.isInitialized) {
              return const Icon(Icons.no_flash, color: Colors.grey);
            }
            switch (state.torchState) {
              case TorchState.auto:
              case TorchState.off:
                return const Icon(Icons.flash_off, color: Colors.grey);
              case TorchState.on:
                return const Icon(Icons.flash_on, color: Colors.yellow);
              case TorchState.unavailable:
                return const Icon(Icons.no_flash, color: Colors.grey);
            }
          },
        ),
      )
    );
  }

  Widget cameraButton() {
    return Transform.scale(
      scale: 1.5,
      child: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.transparent,
        onPressed: () => _scannerController.switchCamera(),
        child: ValueListenableBuilder(valueListenable: _scannerController,
          builder: (context, state, child) {
            if (!state.isInitialized || !state.isRunning) {
              return const SizedBox.shrink();
            }
            switch (state.cameraDirection) {
              case CameraFacing.front:
                return const Icon(Icons.camera_front_rounded, color: Colors.white,);
              case CameraFacing.back:
                return const Icon(Icons.camera_rear_rounded, color: Colors.white,);
              case CameraFacing.external:
                return const Icon(Icons.usb_rounded, color: Colors.white,);
              case CameraFacing.unknown:
                return Icon(Icons.error_rounded, color: Colors.white,);
            }
          },
        )
      )
    );
  }

  void _handleBarcode(BarcodeCapture captures) {
    if (mounted) {
      setState(() {
        barcodes = captures.barcodes;
      });
    }
    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      showDialog(
        context: context, // Use the context of _QRCodeReaderState
        builder: (BuildContext dialogContext) { // It's good practice to use a different name for the dialog's context
          return AlertDialog(
            title: const Text('QR Code Scanned'),
            content: Text('Data: ${barcodes.first.rawValue}'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Dismiss the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }
}