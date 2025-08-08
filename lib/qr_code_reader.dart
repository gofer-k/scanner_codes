import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QRCodeReader extends StatefulWidget {
  const QRCodeReader({super.key});

  @override
  State<StatefulWidget> createState() => _QRCodeReaderState();
}

class _QRCodeReaderState extends State<QRCodeReader>{
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? barcode;
  QRViewController? _controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller!.pauseCamera();
    }
    _controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    final screenSize = MediaQuery.of(context).size;
    var scanArea = (screenSize.width < 400 ||
        screenSize.height < 400)
        ? 200.0
        : 300.0;
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
              child: Stack(
                children: [
                  QRView(
                    key: _qrKey,
                    overlay: QrScannerOverlayShape(
                      borderColor: Colors.white,
                      borderRadius: 10,
                      borderLength: 30,
                      borderWidth: 10,
                      cutOutSize: scanArea,
                    ),
                    onQRViewCreated: _onQRViewCreated,
                    onPermissionSet: (ctrl, permitted) => _onPermissionSet(context, ctrl, permitted),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 8,
                    right: 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        flashButton(),
                        cameraButton(),
                      ],
                    )),
                ],
              )
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child:
                  (barcode != null)
                    ? Text(
                      'Bar code type: ${barcode?.format}, data: ${barcode?.code}',
                      style: TextStyle(fontSize: 20),
                      maxLines: null,)
                    : const Text('Unknown  QR code',style: TextStyle(fontSize: 20, color: Colors.redAccent),),
              ),
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
        onPressed: () async {
          await _controller?.toggleFlash();
          setState(() {});
        },
        child: FutureBuilder(
          future: _controller?.getFlashStatus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(color: Colors.blueAccent);
            } else if (snapshot.hasError) {
              return Icon(Icons.error_rounded, color: Colors.white);
            }
            else {
              bool isFlashOn = snapshot.data ?? false;
              return Icon(
                isFlashOn ? Icons.flashlight_off_rounded : Icons.flashlight_on_rounded,
                color: Colors.white
              );
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
        onPressed: () async {
          await _controller?.flipCamera();
          setState(() {});
        },
        child: FutureBuilder(
          future: _controller?.getCameraInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(color: Colors.blueAccent);
            } else if (snapshot.hasError) {
              return Icon(Icons.error_rounded, color: Colors.white,);
            }
            else if (snapshot.hasData) {
              final cameraFacing = snapshot.data;
              if (cameraFacing == CameraFacing.front) {
                return const Icon(Icons.camera_front_rounded, color: Colors.white,);
              } else {
                return const Icon(Icons.camera_rear_rounded, color: Colors.white,);
              }
            }
            else {
              return const Icon(Icons.camera_alt_rounded, color: Colors.white,);
            }
          },
        )
      )
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController controller, bool permitted) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $permitted');
    if (!permitted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }
  
  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
      controller.scannedDataStream.listen((scanData) {
        barcode = scanData;
      });
    });
  }
}