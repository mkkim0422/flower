import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:plant_app/data/db/app_database.dart';
import 'package:plant_app/data/remote/plantnet_client.dart';
import 'package:plant_app/data/repositories/identification_repository.dart';
import 'package:plant_app/data/repositories/species_repository.dart';
import 'package:plant_app/data/seed/species_seed.dart';
import 'package:plant_app/domain/identification_service.dart';

class _FakeIdentifier implements Identifier {
  _FakeIdentifier(this.outcome);
  final IdentificationOutcome outcome;
  int calls = 0;

  @override
  Future<IdentificationOutcome> identify(Uint8List jpegBytes) async {
    calls++;
    return outcome;
  }
}

class _FakeQuota implements DailyQuota {
  _FakeQuota(this.allow);
  final bool allow;

  @override
  Future<bool> tryConsume() async => allow;
}

IdentificationCandidate _c(String name, double score) =>
    IdentificationCandidate(scientificName: name, score: score);

const _plantNetBody = '''
{"query":{"project":"all","images":["x"],"organs":["leaf"]},
 "results":[
  {"score":0.87,"species":{"scientificNameWithoutAuthor":"Monstera deliciosa","scientificName":"Monstera deliciosa Liebm.","commonNames":["Swiss cheese plant"]},
   "images":[{"url":{"o":"https://x/o.jpg","m":"https://x/m.jpg","s":"https://x/s.jpg"}}]},
  {"score":0.06,"species":{"scientificNameWithoutAuthor":"Monstera adansonii","commonNames":[]},"images":[]},
  {"score":0.02,"species":{"scientificNameWithoutAuthor":"Rhaphidophora tetrasperma","commonNames":["Mini monstera"]}}
 ],
 "remainingIdentificationRequests":495}
''';

void main() {
  final bytes = Uint8List.fromList([1, 2, 3]);

  group('IdentificationPipeline', () {
    test('온디바이스 모델 없음 → PlantNet 결과 사용', () async {
      final local = _FakeIdentifier(
        const IdentificationUnavailable(UnavailableReason.modelMissing),
      );
      final remote = _FakeIdentifier(
        IdentificationSuccess(
          candidates: [_c('Monstera deliciosa', 0.9)],
          source: IdentificationSource.plantNet,
        ),
      );
      final r = await IdentificationPipeline(
        onDevice: local,
        remote: remote,
      ).run(bytes);
      expect(r, isA<IdentificationSuccess>());
      expect(
        (r as IdentificationSuccess).source,
        IdentificationSource.plantNet,
      );
      expect(local.calls, 1);
      expect(remote.calls, 1);
    });

    test('온디바이스 ≥ 0.80 이면 PlantNet 호출 안 함', () async {
      final local = _FakeIdentifier(
        IdentificationSuccess(
          candidates: [_c('Epipremnum aureum', 0.81)],
          source: IdentificationSource.onDevice,
        ),
      );
      final remote = _FakeIdentifier(
        const IdentificationUnavailable(UnavailableReason.network),
      );
      final r = await IdentificationPipeline(
        onDevice: local,
        remote: remote,
      ).run(bytes);
      expect(
        (r as IdentificationSuccess).source,
        IdentificationSource.onDevice,
      );
      expect(remote.calls, 0);
    });

    test('온디바이스 저신뢰 + PlantNet 실패 → 로컬 후보라도 반환', () async {
      final local = _FakeIdentifier(
        IdentificationSuccess(
          candidates: [_c('A', 0.5), _c('B', 0.3)],
          source: IdentificationSource.onDevice,
        ),
      );
      final remote = _FakeIdentifier(
        const IdentificationUnavailable(UnavailableReason.dailyLimit),
      );
      final r = await IdentificationPipeline(
        onDevice: local,
        remote: remote,
      ).run(bytes);
      expect(r, isA<IdentificationSuccess>());
      expect((r as IdentificationSuccess).isConfident, isFalse);
    });

    test('둘 다 실패 → 원격 사유(한도) 반환', () async {
      final local = _FakeIdentifier(
        const IdentificationUnavailable(UnavailableReason.modelMissing),
      );
      final remote = _FakeIdentifier(
        const IdentificationUnavailable(UnavailableReason.dailyLimit),
      );
      final r = await IdentificationPipeline(
        onDevice: local,
        remote: remote,
      ).run(bytes);
      expect(
        (r as IdentificationUnavailable).reason,
        UnavailableReason.dailyLimit,
      );
    });

    test('후보는 확률 내림차순, 최대 5개', () {
      final s = IdentificationSuccess(
        candidates: [for (var i = 0; i < 8; i++) _c('S$i', i / 10)],
        source: IdentificationSource.plantNet,
      );
      expect(s.candidates.length, 5);
      expect(s.top.scientificName, 'S7');
    });
  });

  group('OnDeviceIdentifier (더미)', () {
    test('모델 에셋 없으면 modelMissing', () async {
      final id = OnDeviceIdentifier(probe: (_) async => false);
      final r = await id.identify(bytes);
      expect(
        (r as IdentificationUnavailable).reason,
        UnavailableReason.modelMissing,
      );
    });
    test('모델이 있어도 엔진 미연동이면 modelMissing (파이프라인 막히지 않음)', () async {
      final id = OnDeviceIdentifier(probe: (_) async => true);
      final r = await id.identify(bytes);
      expect(r, isA<IdentificationUnavailable>());
    });
  });

  group('PlantNet', () {
    test('응답 파싱: 학명·확률·이미지·남은 횟수', () {
      final res = PlantNetResponse.parse(_plantNetBody);
      expect(res.candidates.length, 3);
      expect(res.candidates.first.scientificName, 'Monstera deliciosa');
      expect(res.candidates.first.score, closeTo(0.87, 1e-9));
      expect(res.candidates.first.imageUrl, 'https://x/m.jpg');
      expect(res.candidates[1].imageUrl, isNull);
      expect(res.remaining, 495);
    });

    test('키 없으면 apiError, 호출 없음', () async {
      var called = false;
      final client = PlantNetClient(
        apiKey: '',
        client: MockClient((_) async {
          called = true;
          return http.Response('{}', 200);
        }),
      );
      final r = await PlantNetIdentifier(
        client: client,
        quota: _FakeQuota(true),
      ).identify(bytes);
      expect(
        (r as IdentificationUnavailable).reason,
        UnavailableReason.apiError,
      );
      expect(called, isFalse);
    });

    test('한도면 dailyLimit, 호출 없음', () async {
      final client = PlantNetClient(
        apiKey: 'k',
        client: MockClient((_) async => http.Response('{}', 200)),
      );
      final r = await PlantNetIdentifier(
        client: client,
        quota: _FakeQuota(false),
      ).identify(bytes);
      expect(
        (r as IdentificationUnavailable).reason,
        UnavailableReason.dailyLimit,
      );
    });

    test('200 → 성공, 멀티파트로 images·organs 전송', () async {
      http.BaseRequest? sent;
      final client = PlantNetClient(
        apiKey: 'k',
        client: MockClient((req) async {
          sent = req;
          return http.Response(_plantNetBody, 200);
        }),
      );
      final r = await PlantNetIdentifier(
        client: client,
        quota: _FakeQuota(true),
      ).identify(bytes);
      expect(r, isA<IdentificationSuccess>());
      expect((r as IdentificationSuccess).top.percent, 87);
      expect(sent!.url.queryParameters['api-key'], 'k');
      expect(sent!.headers['content-type'], startsWith('multipart/form-data'));
    });

    test(
      '404 → noResult, 429 → dailyLimit, 500 → apiError, 예외 → network',
      () async {
        Future<UnavailableReason> run(http.Client c) async {
          final r = await PlantNetIdentifier(
            client: PlantNetClient(apiKey: 'k', client: c),
            quota: _FakeQuota(true),
          ).identify(bytes);
          return (r as IdentificationUnavailable).reason;
        }

        expect(
          await run(MockClient((_) async => http.Response('nf', 404))),
          UnavailableReason.noResult,
        );
        expect(
          await run(MockClient((_) async => http.Response('l', 429))),
          UnavailableReason.dailyLimit,
        );
        expect(
          await run(MockClient((_) async => http.Response('e', 500))),
          UnavailableReason.apiError,
        );
        expect(
          await run(MockClient((_) async => throw Exception('offline'))),
          UnavailableReason.network,
        );
      },
    );
  });

  group('normalizeScientificName', () {
    test('저자명·품종·하이브리드 기호 제거', () {
      expect(
        normalizeScientificName('Monstera deliciosa Liebm.'),
        'monstera deliciosa',
      );
      expect(normalizeScientificName("Philodendron 'Birkin'"), 'philodendron');
      expect(
        normalizeScientificName('Pelargonium × hortorum L.H.Bailey'),
        'pelargonium hortorum',
      );
      expect(normalizeScientificName('Echeveria'), 'echeveria');
    });
  });

  group('IdentificationRepository', () {
    late AppDatabase db;
    var now = DateTime(2026, 9, 16, 10);

    setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
    tearDown(() => db.close());

    test('일 한도: cap 까지 true, 이후 false, 날짜 바뀌면 리셋', () async {
      final repo = IdentificationRepository(db, clock: () => now, cap: 2);
      expect(await repo.tryConsume(), isTrue);
      expect(await repo.tryConsume(), isTrue);
      expect(await repo.tryConsume(), isFalse);
      expect(await repo.remainingToday(), 0);
      now = DateTime(2026, 9, 17, 0, 5);
      expect(await repo.remainingToday(), 2);
      expect(await repo.tryConsume(), isTrue);
    });

    test('식별 로그 저장: 사진 경로·후보 JSON·선택 종', () async {
      final repo = IdentificationRepository(db, clock: () => now);
      await repo.logSelection(
        localPhotoPath: '/photos/a.jpg',
        candidates: [_c('Monstera deliciosa', 0.9)],
        selectedSpeciesId: null,
      );
      final rows = await db.select(db.identificationLogs).get();
      expect(rows.single.localPhotoPath, '/photos/a.jpg');
      expect(rows.single.candidatesJson, contains('Monstera deliciosa'));
      expect(rows.single.userSelectedSpeciesId, isNull);
    });

    test('SpeciesMatcher: 학명 → species_id·국내명 병기, 미등록은 그대로', () async {
      await SpeciesSeedLoader(db).seedIfEmpty(
        jsonOverride:
            '{"species":[{"scientific_name":"Monstera deliciosa","ko_names":["몬스테라"],'
            '"family":"Araceae","base_water_days":7,"light_pref":"med","toxic_pet":true,"toxic_child":true,'
            '"temp_min":12,"temp_max":30,"fert_days":30,"repot_months":18,"common_issues":[]}]}',
      );
      final matcher = SpeciesMatcher(SpeciesRepository(db));
      final out = await matcher.attach([
        _c('Monstera deliciosa Liebm.', 0.9),
        _c('Unknownus plantus', 0.1),
      ]);
      expect(out[0].koName, '몬스테라');
      expect(out[0].speciesId, isNotNull);
      expect(out[1].speciesId, isNull);
      expect(out[1].koName, isNull);
    });
  });
}
