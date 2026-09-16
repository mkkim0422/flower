// PlantNet API (my-api.plantnet.org, 무료 500회/일). 키는 --dart-define=PLANTNET_API_KEY 로 주입.
// 사진은 요청 후 저장하지 않는다 (HANDOFF 3-3, 5-2).
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../domain/identification_service.dart';

const String kPlantNetApiKey = String.fromEnvironment('PLANTNET_API_KEY');
const String kPlantNetEndpoint = 'https://my-api.plantnet.org/v2/identify/all';

class PlantNetException implements Exception {
  const PlantNetException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  @override
  String toString() => 'PlantNetException($statusCode): $message';
}

class PlantNetResponse {
  const PlantNetResponse({required this.candidates, this.remaining});

  final List<IdentificationCandidate> candidates;
  final int? remaining;

  /// 응답 JSON → 후보 목록
  static PlantNetResponse parse(String body) {
    final root = jsonDecode(body) as Map<String, dynamic>;
    final results = (root['results'] as List? ?? const [])
        .cast<Map<String, dynamic>>();
    final candidates = results
        .map((r) {
          final species = (r['species'] as Map<String, dynamic>?) ?? const {};
          final images = (r['images'] as List? ?? const [])
              .cast<Map<String, dynamic>>();
          String? imageUrl;
          if (images.isNotEmpty) {
            final url = images.first['url'] as Map<String, dynamic>?;
            imageUrl = (url?['m'] ?? url?['s'] ?? url?['o']) as String?;
          }
          return IdentificationCandidate(
            scientificName:
                (species['scientificNameWithoutAuthor'] ??
                        species['scientificName'] ??
                        '')
                    as String,
            score: ((r['score'] as num?) ?? 0).toDouble(),
            commonNames: ((species['commonNames'] as List?) ?? const [])
                .cast<String>(),
            imageUrl: imageUrl,
          );
        })
        .where((c) => c.scientificName.isNotEmpty)
        .toList();
    return PlantNetResponse(
      candidates: candidates,
      remaining: root['remainingIdentificationRequests'] as int?,
    );
  }
}

/// 순수 HTTP 클라이언트
class PlantNetClient {
  PlantNetClient({http.Client? client, String? apiKey, String? endpoint})
    : _client = client ?? http.Client(),
      apiKey = apiKey ?? kPlantNetApiKey,
      endpoint = endpoint ?? kPlantNetEndpoint;

  final http.Client _client;
  final String apiKey;
  final String endpoint;

  bool get hasKey => apiKey.isNotEmpty;

  Future<PlantNetResponse> identify(
    Uint8List jpegBytes, {
    String organ = 'auto', // 잎·꽃·열매 자동 판별
  }) async {
    final uri = Uri.parse(endpoint).replace(
      queryParameters: {
        'api-key': apiKey,
        'include-related-images': 'true',
        'lang': 'en',
      },
    );
    final req = http.MultipartRequest('POST', uri)
      ..fields['organs'] = organ
      ..files.add(
        http.MultipartFile.fromBytes(
          'images',
          jpegBytes,
          filename: 'plant.jpg',
        ),
      );
    final streamed = await _client
        .send(req)
        .timeout(const Duration(seconds: 30));
    final body = await streamed.stream.bytesToString();
    if (streamed.statusCode == 200) return PlantNetResponse.parse(body);
    throw PlantNetException(streamed.statusCode, body);
  }
}

/// 일 한도 확인/차감 (구현: IdentificationRepository)
abstract class DailyQuota {
  /// 호출 가능하면 1 차감 후 true, 한도면 false
  Future<bool> tryConsume();
}

/// PlantNet Fallback 식별기: 한도 → 키 → 호출 → 파싱
class PlantNetIdentifier implements Identifier {
  const PlantNetIdentifier({required this.client, required this.quota});

  final PlantNetClient client;
  final DailyQuota quota;

  @override
  Future<IdentificationOutcome> identify(Uint8List jpegBytes) async {
    if (!client.hasKey) {
      return const IdentificationUnavailable(
        UnavailableReason.apiError,
        detail: 'PLANTNET_API_KEY 미설정',
      );
    }
    if (!await quota.tryConsume()) {
      return const IdentificationUnavailable(UnavailableReason.dailyLimit);
    }
    try {
      final res = await client.identify(jpegBytes);
      if (res.candidates.isEmpty) {
        return const IdentificationUnavailable(UnavailableReason.noResult);
      }
      return IdentificationSuccess(
        candidates: res.candidates,
        source: IdentificationSource.plantNet,
      );
    } on PlantNetException catch (e) {
      // 404: 식물을 찾지 못함 / 429: 한도 / 401·403: 키
      if (e.statusCode == 404) {
        return const IdentificationUnavailable(UnavailableReason.noResult);
      }
      if (e.statusCode == 429) {
        return const IdentificationUnavailable(UnavailableReason.dailyLimit);
      }
      debugPrint('plantnet error: $e');
      return IdentificationUnavailable(
        UnavailableReason.apiError,
        detail: '${e.statusCode}',
      );
    } catch (e) {
      debugPrint('plantnet network error: $e');
      return IdentificationUnavailable(UnavailableReason.network, detail: '$e');
    }
  }
}
