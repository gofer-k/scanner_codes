import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BarCodeReader extends StatefulWidget {
  const BarCodeReader({super.key});

  @override
  State<StatefulWidget> createState() => _BarCodeReaderState();
}

class _BarCodeReaderState extends State<BarCodeReader>  with WidgetsBindingObserver {
  String _scanBarcode = 'Unknown';

  @override
  void initState() {
    super.initState();
    // Start listening to lifecycle changes.
    WidgetsBinding.instance.addObserver(this);

    // Start listening to the barcode events.
    // _subscription = controller.barcodes.listen(_handleBarcode);
    //
    // // Finally, start the scanner itself.
    // unawaited(controller.start());
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
            "Read (UPC) bar code",
            style: TextStyle(
              color: Colors.white.withAlpha(192),
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ElevatedButton(
                //     onPressed: () => scanBarcodeNormal(),
                //     child: Text('Start barcode scan')),
                // ElevatedButton(
                //     onPressed: () => startBarcodeScanStream(),
                //     child: Text('Start barcode scan stream')),
                Text('Scan result : $_scanBarcode\n',
                    style: TextStyle(fontSize: titleFontSize))
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the controller is not ready, do not try to start or stop it.
    // // Permission dialogs can trigger lifecycle changes before the controller is ready.
    // if (!controller.value.hasCameraPermission) {
    //   return;
    // }
    //
    // switch (state) {
    //   case AppLifecycleState.detached:
    //   case AppLifecycleState.hidden:
    //   case AppLifecycleState.paused:
    //     return;
    //   case AppLifecycleState.resumed:
    //   // Restart the scanner when the app is resumed.
    //   // Don't forget to resume listening to the barcode events.
    //     _subscription = controller.barcodes.listen(_handleBarcode);
    //
    //     unawaited(controller.start());
    //   case AppLifecycleState.inactive:
    //   // Stop the scanner when the app is paused.
    //   // Also stop the barcode events subscription.
    //     unawaited(_subscription?.cancel());
    //     _subscription = null;
    //     unawaited(controller.stop());
    // }
  }
}

