import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plant_app/core/enums.dart';
import 'package:plant_app/data/db/app_database.dart';
import 'package:plant_app/data/repositories/diary_repository.dart';
import 'package:plant_app/data/repositories/plant_repository.dart';

void main() {
  late AppDatabase db;
  late DiaryRepository diary;
  late PlantRepository plants;
  final now = DateTime(2026, 9, 16, 12);

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    diary = DiaryRepository(db, clock: () => now);
    plants = PlantRepository(db, clock: () => now);
  });

  tearDown(() => db.close());

  test('일기 추가 → 최신순 조회, 빈 메모는 null', () async {
    final id = await plants.create(
      nickname: 'A',
      potSize: PotSize.m,
      hasDrainage: true,
      lastWateredAt: now,
    );
    await diary.add(plantId: id, memo: '  ', at: DateTime(2026, 9, 10));
    await diary.add(
      plantId: id,
      memo: '새잎!',
      tags: [DiaryTag.newLeaf],
      photoPath: '/p/1.jpg',
      at: DateTime(2026, 9, 15),
    );
    final list = await diary.watchByPlant(id).first;
    expect(list.length, 2);
    expect(list.first.memo, '새잎!');
    expect(list.first.tags, [DiaryTag.newLeaf]);
    expect(list.first.photoPath, '/p/1.jpg');
    expect(list.last.memo, isNull);
  });

  test('식물 삭제 시 일기도 삭제(cascade), 개별 삭제 가능', () async {
    final id = await plants.create(
      nickname: 'A',
      potSize: PotSize.m,
      hasDrainage: true,
      lastWateredAt: now,
    );
    final d1 = await diary.add(plantId: id, memo: '1');
    await diary.add(plantId: id, memo: '2');
    await diary.delete(d1);
    expect((await diary.getAll()).length, 1);
    await plants.delete(id);
    expect(await diary.getAll(), isEmpty);
  });
}
