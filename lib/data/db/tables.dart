// Drift 테이블 정의. 원본: docs/HANDOFF.md 4장 데이터 모델
import 'dart:convert';

import 'package:drift/drift.dart';

import '../../core/enums.dart';

/// `List<String>` ↔ JSON 문자열 컨버터 (ko_names, common_issues 등)
class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) {
    if (fromDb.isEmpty) return const [];
    return (jsonDecode(fromDb) as List).cast<String>();
  }

  @override
  String toSql(List<String> value) => jsonEncode(value);
}

/// `List<DiaryTag>` ↔ JSON 문자열(enum name 배열)
class DiaryTagListConverter extends TypeConverter<List<DiaryTag>, String> {
  const DiaryTagListConverter();

  @override
  List<DiaryTag> fromSql(String fromDb) {
    if (fromDb.isEmpty) return const [];
    return (jsonDecode(fromDb) as List)
        .cast<String>()
        .map((n) => DiaryTag.values.byName(n))
        .toList();
  }

  @override
  String toSql(List<DiaryTag> value) =>
      jsonEncode(value.map((t) => t.name).toList());
}

/// `List<int>` ↔ JSON (skip_weekdays: DateTime.weekday 1=월 … 7=일)
class IntListConverter extends TypeConverter<List<int>, String> {
  const IntListConverter();

  @override
  List<int> fromSql(String fromDb) {
    if (fromDb.isEmpty) return const [];
    return (jsonDecode(fromDb) as List).cast<int>();
  }

  @override
  String toSql(List<int> value) => jsonEncode(value);
}

/// 품종 마스터. assets/species_ko.json → 첫 실행 시 시드.
class Species extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get scientificName => text().unique()();
  TextColumn get koNames => text().map(const StringListConverter())();
  TextColumn get family => text().nullable()();
  IntColumn get baseWaterDays => integer()();
  TextColumn get lightPref => textEnum<LightPref>()();
  BoolColumn get toxicPet => boolean()();
  BoolColumn get toxicChild => boolean()();
  IntColumn get tempMin => integer().nullable()();
  IntColumn get tempMax => integer().nullable()();
  IntColumn get fertDays => integer().nullable()();
  IntColumn get repotMonths => integer().nullable()();
  TextColumn get commonIssues =>
      text().map(const StringListConverter()).withDefault(const Constant('[]'))();
}

/// 공간 (거실/베란다 …)
class Spaces extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get windowDir => textEnum<WindowDir>()();
  TextColumn get windowDist => textEnum<WindowDist>()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

/// 내 식물
class Plants extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get speciesId =>
      integer().nullable().references(Species, #id, onDelete: KeyAction.setNull)();
  TextColumn get nickname => text()();
  TextColumn get photoPath => text().nullable()();
  IntColumn get spaceId =>
      integer().nullable().references(Spaces, #id, onDelete: KeyAction.setNull)();
  TextColumn get potSize => textEnum<PotSize>()();
  BoolColumn get hasDrainage => boolean().withDefault(const Constant(true))();

  /// 현재 적용 물주기 주기(일). 계산값 또는 수동값.
  IntColumn get waterIntervalDays => integer()();
  BoolColumn get manualOverride => boolean().withDefault(const Constant(false))();

  /// 5-1 feedback_coef. 초기 1.0, 범위 0.5~2.0
  RealColumn get feedbackCoef => real().withDefault(const Constant(1.0))();

  /// "말랐음" 연속 횟수 (2회 연속이면 feedback_coef ×0.9)
  IntColumn get dryStreak => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastWateredAt => dateTime()();
  DateTimeColumn get nextCheckAt => dateTime()();
  IntColumn get fertIntervalDays => integer().nullable()();
  DateTimeColumn get lastFertAt => dateTime().nullable()();
  DateTimeColumn get repotAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

/// 관리 이력
class CareEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get plantId =>
      integer().references(Plants, #id, onDelete: KeyAction.cascade)();
  TextColumn get type => textEnum<CareType>()();
  DateTimeColumn get at => dateTime()();
  TextColumn get note => text().nullable()();
}

/// 생장 일기
class DiaryEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get plantId =>
      integer().references(Plants, #id, onDelete: KeyAction.cascade)();
  TextColumn get photoPath => text().nullable()();
  TextColumn get memo => text().nullable()();
  TextColumn get tags =>
      text().map(const DiaryTagListConverter()).withDefault(const Constant('[]'))();
  DateTimeColumn get at => dateTime()();
}

/// 식별 로그 (자체 모델 학습용). 사진은 로컬 경로만.
class IdentificationLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get localPhotoPath => text()();
  TextColumn get candidatesJson => text()();
  IntColumn get userSelectedSpeciesId =>
      integer().nullable().references(Species, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get at => dateTime()();
}

/// 앱 설정. 단일 행(id = 1).
class Settings extends Table {
  IntColumn get id => integer()();
  IntColumn get notifyHour => integer().withDefault(const Constant(9))();
  IntColumn get notifyMinute => integer().withDefault(const Constant(0))();
  TextColumn get skipWeekdays =>
      text().map(const IntListConverter()).withDefault(const Constant('[]'))();
  TextColumn get backupUserId => text().nullable()();
  BoolColumn get onboardingDone => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
