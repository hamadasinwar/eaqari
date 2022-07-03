import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final image = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Hero(
            tag: "preview",
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Image.network(
                image,
                height: size.height,
                width: size.width,
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 0,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
