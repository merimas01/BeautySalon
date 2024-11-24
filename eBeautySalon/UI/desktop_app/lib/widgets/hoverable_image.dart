import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../models/usluga.dart';

class HoverableImage extends StatefulWidget {
  final Uint8List? imageBytes;
  final VoidCallback? onTap;
  Usluga? usluga;

  HoverableImage({Key? key, this.imageBytes, this.onTap, this.usluga})
      : super(key: key);

  @override
  _HoverableImageState createState() => _HoverableImageState();
}

class _HoverableImageState extends State<HoverableImage> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Image widget
            widget.imageBytes != null
                ? ColorFiltered(
                    colorFilter: _isHovered ? _normalFilter() : _darkerFilter(),
                    child: Image.memory(
                      widget.imageBytes!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  )
                : const Center(
                    child: Text(
                      "Nema slike",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),

            // Show text and button only when hovered
            if (_isHovered)
              Positioned(
                bottom: 20,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Text that appears on hover

                    // Container(height: 400, child: Image.memory(
                    //   widget.imageBytes!,
                    // ),color: Colors.blue,),
                    Text(
                      "Usluga: ${widget.usluga?.naziv}",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    // Button that appears on hover
                    ElevatedButton(
                      onPressed: widget.onTap,
                      child: Text("Detalji"),
                    ),
                  ],
                ),
              ),
          ],
        ),
      
      ),
    );
  }

  /// Brightness filter for hover
  ColorFilter _darkerFilter() {
    return ColorFilter.matrix(<double>[
      0.8, 0, 0, 0, 10, // Red (slightly less pink)
      0, 0.7, 0, 0, -20, // Green (muted for grey)
      0, 0, 0.8, 0, 10, // Blue (less enhanced for a softer pink)
      0, 0, 0, 1, 0, // Alpha
    ]);
  }

  /// Normal filter (no brightness change)
  ColorFilter _normalFilter() {
    return ColorFilter.matrix(<double>[
      1, 0, 0, 0, 0, // Red
      0, 1, 0, 0, 0, // Green
      0, 0, 1, 0, 0, // Blue
      0, 0, 0, 1, 0, // Alpha
    ]);
  }
}
