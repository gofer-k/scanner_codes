import 'package:flutter/material.dart';

class ScannerOverlayPainter extends CustomPainter {
  final Rect scanWindow;
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;

  ScannerOverlayPainter({
    required this.scanWindow,
    this.borderRadius = 12.0, // Default border radius
    this.borderColor = Colors.white, // Default border color
    this.borderWidth = 3.0,      // Default border width
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 0.5), // Default overlay color (semi-transparent black)
  });

  @override
  void paint(Canvas canvas, Size size) {
    // --- Paint for the area OUTSIDE the scan window ---
    final Paint backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    // --- Paint for the scan window BORDER ---
    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final RRect scanWindowRRect = RRect.fromRectAndRadius(
      scanWindow,
      Radius.circular(borderRadius),
    );

    // Create a path that is the difference between the full screen and the scan window
    final Path backgroundPath = Path.combine(
      PathOperation.difference,
      Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)), // Full area
      Path()..addRRect(scanWindowRRect), // The "cutout" area
    );

    // Draw the dimmed background
    canvas.drawPath(backgroundPath, backgroundPaint);

    // Draw the border around the scan window
    canvas.drawRRect(scanWindowRRect, borderPaint);

    // --- Optional: Add Corner Accents ---
    final Paint cornerPaint = Paint()
      ..color = Colors.white // Or a theme color
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth + 2; // Slightly thicker
    const double cornerLength = 20;

    // Top-left
    canvas.drawLine(
        Offset(scanWindow.left, scanWindow.top + cornerLength),
        scanWindow.topLeft,
        cornerPaint);
    canvas.drawLine(
        Offset(scanWindow.left + cornerLength, scanWindow.top),
        scanWindow.topLeft,
        cornerPaint);

    // Top-right
    canvas.drawLine(
        Offset(scanWindow.right, scanWindow.top + cornerLength),
        scanWindow.topRight,
        cornerPaint);
    canvas.drawLine(
        Offset(scanWindow.right - cornerLength, scanWindow.top),
        scanWindow.topRight,
        cornerPaint);

    // Bottom-left
    canvas.drawLine(
        Offset(scanWindow.left, scanWindow.bottom - cornerLength),
        scanWindow.bottomLeft,
        cornerPaint);
    canvas.drawLine(
        Offset(scanWindow.left + cornerLength, scanWindow.bottom),
        scanWindow.bottomLeft,
        cornerPaint);

    // Bottom-right
    canvas.drawLine(
        Offset(scanWindow.right, scanWindow.bottom - cornerLength),
        scanWindow.bottomRight,
        cornerPaint);
    canvas.drawLine(
        Offset(scanWindow.right - cornerLength, scanWindow.bottom),
        scanWindow.bottomRight,
        cornerPaint);
  }

  @override
  bool shouldRepaint(covariant ScannerOverlayPainter oldDelegate) {
    return oldDelegate.scanWindow != scanWindow ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.overlayColor != overlayColor;
  }
}
