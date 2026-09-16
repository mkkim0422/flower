// 식별용 이미지 전처리 (HANDOFF 5-2 ①): 1024px 리사이즈 + EXIF 제거 + 회전 보정
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

const int kIdentifyMaxSide = 1024;
const int kJpegQuality = 85;

/// 별도 isolate에서 실행 (compute)
Uint8List _prepare(Uint8List raw) {
  final decoded = img.decodeImage(raw);
  if (decoded == null) {
    throw const FormatException('이미지를 읽을 수 없어요');
  }
  var image = img.bakeOrientation(decoded); // EXIF 회전 적용
  final longest = image.width > image.height ? image.width : image.height;
  if (longest > kIdentifyMaxSide) {
    image = image.width >= image.height
        ? img.copyResize(
            image,
            width: kIdentifyMaxSide,
            interpolation: img.Interpolation.average,
          )
        : img.copyResize(
            image,
            height: kIdentifyMaxSide,
            interpolation: img.Interpolation.average,
          );
  }
  image.exif = img.ExifData(); // 위치 등 메타데이터 제거
  return Uint8List.fromList(img.encodeJpg(image, quality: kJpegQuality));
}

Future<Uint8List> prepareForIdentification(Uint8List raw) =>
    compute(_prepare, raw);

/// 앱 내부 저장소 photos/ 에 저장 → 경로 반환. 식물 대표 사진·식별 로그에서 공유.
Future<String> savePhotoLocally(Uint8List jpeg, {String? name}) async {
  final dir = await getApplicationDocumentsDirectory();
  final photos = Directory('${dir.path}${Platform.pathSeparator}photos');
  if (!await photos.exists()) await photos.create(recursive: true);
  final file = File(
    '${photos.path}${Platform.pathSeparator}${name ?? DateTime.now().millisecondsSinceEpoch}.jpg',
  );
  await file.writeAsBytes(jpeg, flush: true);
  return file.path;
}
