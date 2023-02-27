import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({
    Key? key,
    required this.asset,
    required this.originalBytes,
  }) : super(key: key);
  final String asset;
  final int originalBytes;

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  @override
  void initState() {
    super.initState();
    imageCache.maximumSizeBytes = 1024 * 1024 * 2000;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(AssetImage(widget.asset), context).then((_) => setState(() {}));
  }

  double convertBytesToMb(int bytes) {
    return bytes / (pow(1024, 2));
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 25);
    const title = Text('이미지 페이지');

    return Scaffold(
      appBar: AppBar(title: title),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text('Original : ${convertBytesToMb(widget.originalBytes).toStringAsFixed(3)}mb', style: textStyle),
                const SizedBox(height: 10),
                Text('Cache : ${convertBytesToMb(imageCache.currentSizeBytes).toStringAsFixed(3)}mb', style: textStyle),
              ],
            ),
          ),
          _buildImage(),
        ],
      ),
    );
  }

  Widget _buildImage() {
    final size = MediaQuery.of(context).size;

    if (imageCache.currentSizeBytes == 0) {
      return const Align(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      );
    }
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Image.asset(widget.asset),
    );
  }
}
