import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_precache_test/enums/enum_image.dart';
import 'package:flutter_image_precache_test/image_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '이미지 캐싱 테스트'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  EnumImage enumImage = EnumImage.lightSizeImage;

  void changeEnumImage() {
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
