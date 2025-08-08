import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scanner_codes/qr_input_text_types.dart';

class QRCodeGenerator extends StatefulWidget {
  const QRCodeGenerator({super.key});

  @override
  State<StatefulWidget> createState() => _QRCodeGeneratorState();
}

class _QRCodeGeneratorState extends State<QRCodeGenerator> {
  TextEditingController _controller = TextEditingController();
  QRInputTextType? _selectedInputTextType = QRInputTextType.singleLineText;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = screenWidth < 400 ? 18.0 : 22.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('QR code generator',
          style: TextStyle(
            color: Colors.white.withAlpha(192),
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: TextField(
              controller: _controller,
              minLines: 1,
              maxLines: null,
              maxLength: 4296,  // limit encoded text into QE code
              keyboardType: _selectedInputTextType!.typeValue,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Enter your text'),
              onSubmitted: (String value) {
                setState(() {
                  _controller.text = value;
                });
              },
            ),
          ),
          DropdownButton(
              items: QRInputTextType.values.map((QRInputTextType type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.typeName),
                );
                }).toList(),
              value: _selectedInputTextType,
              onChanged: (QRInputTextType? newType){
                setState(() {
                  if (newType != null) {
                    _selectedInputTextType = newType;
                  }
                });
              }
          ),
          ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) {
                      return QRImage(_controller);
                    }),
                  ),
                );
              },
              child: const Text('Generate QR code')),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class QRImage extends StatelessWidget {
  const QRImage(this._controller, {super.key});
  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR code image'),
        centerTitle: true,
      ),
      body: Center(
        child: QrImageView(
          data: _controller.text,
          size: 280,
          embeddedImageStyle: QrEmbeddedImageStyle(
            size: const Size(100, 100,),
          ),
        ),
      ),
    );
  }



}