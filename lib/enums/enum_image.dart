import 'package:flutter_image_precache_test/generated/assets.dart';

enum EnumImage {
  lightSizeImage(ko: "작은 사이즈 이미지", assetPath: Assets.assetsQuestion),
  bigSizeImage(ko: "큰 이미지 사이즈", assetPath: Assets.assetsImage);

  final String ko;
  final String assetPath;

  const EnumImage({
    required this.ko,
    required this.assetPath,
  });
}
