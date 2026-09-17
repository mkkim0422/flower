// ignore_for_file: avoid_print
// 개발용: 실제 PlantNet 서버가 사진 여러 장 요청을 받는지 확인.
// lib/data/remote/plantnet_client.dart 의 요청 구성과 동일하게 만든다.
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<void> main(List<String> args) async {
  final key = Platform.environment['PLANTNET_API_KEY'] ?? '';
  final uri = Uri.parse('https://my-api.plantnet.org/v2/identify/all').replace(
    queryParameters: {'api-key': key, 'include-related-images': 'true', 'lang': 'en'},
  );
  final req = http.MultipartRequest('POST', uri);
  for (var i = 0; i < args.length; i++) {
    req.files.add(http.MultipartFile.fromBytes('images', await File(args[i]).readAsBytes(), filename: 'plant$i.jpg'));
    req.files.add(http.MultipartFile.fromString('organs', 'auto'));
  }
  final res = await http.Response.fromStream(await req.send());
  if (res.statusCode != 200) {
    print('HTTP ${res.statusCode}: ${res.body.substring(0, res.body.length.clamp(0, 300))}');
    exit(0);
  }
  final j = jsonDecode(res.body) as Map<String, dynamic>;
  final results = (j['results'] as List).cast<Map<String, dynamic>>();
  print('OK images=${args.length} organs=${j['query']?['organs']} remaining=${j['remainingIdentificationRequests']}');
  for (final r in results.take(3)) {
    print('  ${r['species']['scientificNameWithoutAuthor']} ${((r['score'] as num) * 100).round()}%');
  }
  exit(0);
}
