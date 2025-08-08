import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarCodeReader extends StatefulWidget {
  const BarCodeReader({super.key});

  @override
  State<StatefulWidget> createState() => _BarCodeReaderState();
}

class _BarCodeReaderState extends State<BarCodeReader>  with WidgetsBindingObserver {
  Barcode? _barCode;
  bool _isBarCodeScanned = false;
  final _initialValue = "No display value";

  late String _scannedValue = _initialValue;

  @override
  Widget build(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
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
            "Read (UPC) bar code",
            style: TextStyle(
              color: Colors.white.withAlpha(192),
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          final Size layoutSize = constraints.biggest;
          final double scanWindowWidth = layoutSize.width;  // / 3;
          final double scanWindowHeight = layoutSize.height;  // / 2;
          final Rect scanWindow = Rect.fromCenter(
            center: layoutSize.center(Offset.zero),
            width: scanWindowWidth,
            height: scanWindowHeight,
          );
          return Stack(
            children: [
              MobileScanner(
                onDetect: _handleBarcode,
                scanWindow: scanWindow,

              ),
              Positioned.fill(
                // left: scanWindow.left,
                // top: scanWindow.top,
                // width: scanWindow.width,
                // height: scanWindow.height,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _isBarCodeScanned ? Colors.green : Colors.red,
                      width: 4
                    ),
                  )
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  margin: const EdgeInsets.only(bottom: 20),
                  height: 150,
                  color: const Color.fromRGBO(0, 0, 0, 0.4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(child:
                        Center(
                          child: _barcodePreview(_barCode)
                        )
                      )
                    ]
                  )
                ),
              )
            ],
          );
        })
      )
    );
  }

  Widget _barcodePreview(Barcode? value) {
    _scannedValue = (value == null ? _initialValue : value.displayValue)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _scannedValue,
          overflow: TextOverflow.fade,
          style: const TextStyle(color: Colors.white),
        ),
        if (value?.calendarEvent != null)
          Text(
            "Event date: ${value?.calendarEvent.toString()}",
            overflow: TextOverflow.fade,
            style: const TextStyle(color: Colors.white),
          ),
        if (value?.contactInfo != null)
          Text(
            "Info: ${value?.contactInfo.toString()}",
            overflow: TextOverflow.fade,
            style: const TextStyle(color: Colors.white),
          ),
        if (value?.driverLicense != null)
          Text(
            "Driving license: ${value?.driverLicense.toString()}",
            overflow: TextOverflow.fade,
            style: const TextStyle(color: Colors.white),
          ),
        if (value?.email != null)
          Text(
            "Email: ${value?.email.toString()}",
            overflow: TextOverflow.fade,
            style: const TextStyle(color: Colors.white),
          ),
        if (value?.phone != null)
          Text(
            "Phone: ${value?.phone.toString()}",
            overflow: TextOverflow.fade,
            style: const TextStyle(color: Colors.white),
          ),
        if (value?.url != null)
          Text(
            "Url: ${value?.url.toString()}",
            overflow: TextOverflow.fade,
            style: const TextStyle(color: Colors.white),
          ),
        if (value?.geoPoint != null)
          Text(
            "Location: ${value?.geoPoint.toString()}",
            overflow: TextOverflow.fade,
            style: const TextStyle(color: Colors.white),
          ),
        if (value?.wifi != null)
          Text(
            "Wifi: ${value?.wifi.toString()}",
            overflow: TextOverflow.fade,
            style: const TextStyle(color: Colors.white),
          ),
      ],
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        _barCode = barcodes.barcodes.firstOrNull;
        _isBarCodeScanned = _barCode != null;
      });
    }
    if (_isBarCodeScanned) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _isBarCodeScanned = false;
          });
        }
      });
    }
  }
}

