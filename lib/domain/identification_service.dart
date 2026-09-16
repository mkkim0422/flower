// 식별 파이프라인 (HANDOFF 5-2 + Override O1)
// 순서 고정: 온디바이스 TFLite → (실패·모델 없음·저신뢰) → PlantNet API Fallback

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

/// 1순위 확률이 이 값 이상이면 확정 (CAM-03)
const double kConfidentThreshold = 0.80;

/// 미만일 때 보여줄 후보 수
const int kMaxCandidates = 5;

/// PlantNet 무료 한도 500회/일 → 480회에서 호출 중단
const int kPlantNetDailyCap = 480;

/// 기본 모델 에셋 경로. 파일이 생기면 pubspec assets에 추가.
const String kOnDeviceModelAsset = 'assets/models/plant_classifier.tflite';

enum IdentificationSource { onDevice, plantNet }

enum UnavailableReason {
  /// 온디바이스 모델 파일 없음 / 엔진 미연동
  modelMissing,

  /// PlantNet 일 한도 도달
  dailyLimit,

  /// 네트워크 오류
  network,

  /// API 키 없음·인증 실패·서버 오류
  apiError,

  /// 결과 없음 (식물이 아니거나 인식 불가)
  noResult,
}

class IdentificationCandidate {
  const IdentificationCandidate({
    required this.scientificName,
    required this.score,
    this.commonNames = const [],
    this.imageUrl,
    this.speciesId,
    this.koName,
  });

  final String scientificName;

  /// 0.0 ~ 1.0
  final double score;
  final List<String> commonNames;
  final String? imageUrl;

  /// species DB 매칭 결과 (없으면 null → 학명만 표시)
  final int? speciesId;
  final String? koName;

  int get percent => (score * 100).round();

  IdentificationCandidate copyWith({int? speciesId, String? koName}) =>
      IdentificationCandidate(
        scientificName: scientificName,
        score: score,
        commonNames: commonNames,
        imageUrl: imageUrl,
        speciesId: speciesId ?? this.speciesId,
        koName: koName ?? this.koName,
      );

  Map<String, dynamic> toJson() => {
    'scientific_name': scientificName,
    'score': score,
    'common_names': commonNames,
    'image_url': imageUrl,
    'species_id': speciesId,
  };
}

sealed class IdentificationOutcome {
  const IdentificationOutcome();
}

class IdentificationSuccess extends IdentificationOutcome {
  IdentificationSuccess({
    required List<IdentificationCandidate> candidates,
    required this.source,
  }) : candidates =
           (List.of(candidates)..sort((a, b) => b.score.compareTo(a.score)))
               .take(kMaxCandidates)
               .toList();

  final List<IdentificationCandidate> candidates;
  final IdentificationSource source;

  IdentificationCandidate get top => candidates.first;
  bool get isConfident =>
      candidates.isNotEmpty && candidates.first.score >= kConfidentThreshold;

  IdentificationSuccess withCandidates(List<IdentificationCandidate> c) =>
      IdentificationSuccess(candidates: c, source: source);
}

class IdentificationUnavailable extends IdentificationOutcome {
  const IdentificationUnavailable(this.reason, {this.detail});

  final UnavailableReason reason;
  final String? detail;
}

/// 식별기 공통 인터페이스. 입력은 1024px 리사이즈·EXIF 제거된 JPEG.
abstract class Identifier {
  Future<IdentificationOutcome> identify(Uint8List jpegBytes);
}

/// 에셋 존재 확인 (테스트에서 교체)
typedef AssetProbe = Future<bool> Function(String asset);

Future<bool> rootBundleAssetExists(String asset) async {
  try {
    await rootBundle.load(asset);
    return true;
  } catch (_) {
    return false;
  }
}

/// 온디바이스 식별기 (Override O1).
/// 현재 .tflite 모델이 없으므로 **더미**: 에셋 유무만 확인하고 항상 [UnavailableReason.modelMissing]을 돌려준다.
/// 모델과 `tflite_flutter`가 준비되면 [_infer]만 구현하면 파이프라인은 그대로 동작한다.
class OnDeviceIdentifier implements Identifier {
  OnDeviceIdentifier({this.modelAsset = kOnDeviceModelAsset, AssetProbe? probe})
    : _probe = probe ?? rootBundleAssetExists;

  final String modelAsset;
  final AssetProbe _probe;
  bool? _modelPresent;

  Future<bool> get modelPresent async =>
      _modelPresent ??= await _probe(modelAsset);

  @override
  Future<IdentificationOutcome> identify(Uint8List jpegBytes) async {
    try {
      if (!await modelPresent) {
        return const IdentificationUnavailable(
          UnavailableReason.modelMissing,
          detail: '온디바이스 모델 파일 없음',
        );
      }
      return await _infer(jpegBytes);
    } catch (e) {
      debugPrint('on-device inference failed: $e');
      return IdentificationUnavailable(
        UnavailableReason.modelMissing,
        detail: '$e',
      );
    }
  }

  /// TODO(M2 후속): tflite_flutter Interpreter 로드 → 전처리 → 추론 → 라벨 매핑.
  /// 지금은 모델이 있어도 엔진이 없으므로 modelMissing 으로 우회한다.
  Future<IdentificationOutcome> _infer(Uint8List jpegBytes) async {
    return const IdentificationUnavailable(
      UnavailableReason.modelMissing,
      detail: '추론 엔진 미연동',
    );
  }
}

/// TFLite → PlantNet 순서의 파이프라인
class IdentificationPipeline {
  const IdentificationPipeline({required this.onDevice, required this.remote});

  final Identifier onDevice;
  final Identifier remote;

  Future<IdentificationOutcome> run(Uint8List jpegBytes) async {
    final local = await onDevice.identify(jpegBytes);
    if (local is IdentificationSuccess && local.isConfident) return local;

    final fallback = await remote.identify(jpegBytes);
    if (fallback is IdentificationSuccess) return fallback;

    // 원격도 실패: 로컬 저신뢰 후보라도 있으면 보여준다
    if (local is IdentificationSuccess) return local;
    return fallback;
  }
}

/// 학명 정규화: 저자명·품종명 제거, 소문자, "Genus species" 두 단어
String normalizeScientificName(String name) {
  var n = name.trim();
  n = n.replaceAll(RegExp(r"'[^']*'"), ''); // 품종
  n = n.replaceAll(RegExp(r'\s+'), ' ').trim();
  final parts = n.split(' ');
  final kept = <String>[];
  for (final p in parts) {
    if (kept.isEmpty) {
      kept.add(p.replaceAll('×', '').trim());
      continue;
    }
    if (p == '×' || p == 'x') continue; // 하이브리드 기호
    if (kept.length == 1) {
      // 종소명: 소문자 시작 (저자명은 대문자 시작)
      if (RegExp(r'^[a-z\-]+$').hasMatch(p)) kept.add(p);
      break;
    }
  }
  return kept.where((s) => s.isNotEmpty).join(' ').toLowerCase();
}
