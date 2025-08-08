import 'package:flutter/material.dart';

class BarCodeGenerator extends StatefulWidget {
  const BarCodeGenerator({super.key});

  @override
  State<StatefulWidget> createState() => _BarCodeGeneratorState();
}

class _BarCodeGeneratorState extends State<BarCodeGenerator> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = screenWidth < 400 ? 18.0 : 22.0;

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
            "Bar code generator",
            style: TextStyle(
              color: Colors.white.withAlpha(192),
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Center(
          child: Column(
           children: [
             Text("bar code text")
           ], 
          ),
        ),
      ),
    );     
  }
}