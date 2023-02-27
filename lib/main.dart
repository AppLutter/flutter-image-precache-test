import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_precache_test/enums/enum_image.dart';
import 'package:flutter_image_precache_test/image_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.primaries[Random().nextInt(Colors.primaries.length - 1)],
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
              elevation: 0.0,
              foregroundColor: Colors.white,
            ),
      ),
      home: MyHomePage(
        title: '이미지 캐싱 테스트',
        refresh: refresh,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.refresh,
  });

  final String title;
  final VoidCallback refresh;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  EnumImage enumImage = EnumImage.lightSizeImage;

  void changeEnumImage() {
    widget.refresh();
    imageCache.clear();
    const values = EnumImage.values;
    final int currentIndex = values.indexWhere((e) => e.ko == enumImage.ko);

    setState(() {
      enumImage = values[(currentIndex + 1) % values.length];
    });
  }

  Future<int> getImageOriginalBytes() async {
    final asset = await rootBundle.load(enumImage.assetPath);
    return asset.lengthInBytes;
  }

  @override
  Widget build(BuildContext context) {
    const buttonHorizontalPadding = 10.0;
    const buttonVerticalPadding = 10.0;
    const buttonText = '사진 보러가기';
    const buttonRadius = 5.0;
    const buttonTextStyle = TextStyle(fontSize: 15.0, color: Colors.white);
    final BoxDecoration buttonDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(buttonRadius),
      color: Colors.deepOrange,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                changeEnumImage();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: buttonHorizontalPadding,
                  vertical: buttonVerticalPadding,
                ),
                decoration: buttonDecoration.copyWith(color: Colors.deepPurpleAccent),
                child: Text(
                  '현재 : ${enumImage.ko}',
                  style: buttonTextStyle,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () async {
                final originalBytes = await getImageOriginalBytes();

                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ImageScreen(
                        asset: enumImage.assetPath,
                        originalBytes: originalBytes,
                      ),
                    ),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: buttonHorizontalPadding,
                  vertical: buttonVerticalPadding,
                ),
                decoration: buttonDecoration,
                child: const Text(
                  buttonText,
                  style: buttonTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
