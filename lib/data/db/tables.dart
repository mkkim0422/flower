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
@DataClassName('SpeciesRow')
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
  TextColumn get commonIssues => text()
      .map(const StringListConverter())
      .withDefault(const Constant('[]'))();

  /// foliage / succulent / herb / flower / other
  TextColumn get category => text().withDefault(const Constant('foliage'))();

  /// 검색용: ko_names를 공백으로 이어붙인 소문자 문자열
  TextColumn get searchText => text().withDefault(const Constant(''))();

  /// 적정 생육 온도 (없으면 temp_min~temp_max 로 대체)
  IntColumn get tempOptMin => integer().nullable()();
  IntColumn get tempOptMax => integer().nullable()();

  /// 영어 이름·독성 설명·흔한 문제 (글로벌)
  TextColumn get namesEn => text()
      .map(const StringListConverter())
      .withDefault(const Constant('[]'))();
  TextColumn get toxicityNoteEn => text().withDefault(const Constant(''))();
  TextColumn get commonIssuesEn => text()
      .map(const StringListConverter())
      .withDefault(const Constant('[]'))();

  /// 도감 대표 사진 (위키미디어 공용, 자유 라이선스). 없으면 null
  TextColumn get imageUrl => text().nullable()();
  TextColumn get imageAuthor => text().nullable()();
  TextColumn get imageLicense => text().nullable()();
  TextColumn get imagePage => text().nullable()();

  /// 경고할 만큼 위험한지 (앱은 이 값이 true 일 때만 독성 경고를 띄운다)
  BoolColumn get toxicSevere => boolean().withDefault(const Constant(false))();

  /// 독성 설명: 원인 부위·성분, 증상, 대처 (1~2문장)
  TextColumn get toxicityNote => text().withDefault(const Constant(''))();

  /// 아이 독성 3단계 (toxic_child 는 == toxic 인지의 요약)
  TextColumn get toxicChildLevel =>
      textEnum<ChildToxicity>().withDefault(const Constant('none'))();
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
  IntColumn get speciesId => integer().nullable().references(
    Species,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get nickname => text()();
  TextColumn get photoPath => text().nullable()();
  IntColumn get spaceId => integer().nullable().references(
    Spaces,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get potSize => textEnum<PotSize>()();
  BoolColumn get hasDrainage => boolean().withDefault(const Constant(true))();

  /// 현재 적용 물주기 주기(일). 계산값 또는 수동값.
  IntColumn get waterIntervalDays => integer()();
  BoolColumn get manualOverride =>
      boolean().withDefault(const Constant(false))();

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

  /// 사용자 메모 (PLT-01 내 메모)
  TextColumn get memo => text().nullable()();
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
  TextColumn get tags => text()
      .map(const DiaryTagListConverter())
      .withDefault(const Constant('[]'))();
  DateTimeColumn get at => dateTime()();
}

/// 식별 로그 (자체 모델 학습용). 사진은 로컬 경로만.
class IdentificationLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get localPhotoPath => text()();
  TextColumn get candidatesJson => text()();
  IntColumn get userSelectedSpeciesId => integer().nullable().references(
    Species,
    #id,
    onDelete: KeyAction.setNull,
  )();
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
  BoolColumn get onboardingDone =>
      boolean().withDefault(const Constant(false))();

  /// PlantNet 일 호출 카운터 (5-2): yyyymmdd 정수 + 당일 호출 수
  IntColumn get plantnetDay => integer().withDefault(const Constant(0))();
  IntColumn get plantnetCount => integer().withDefault(const Constant(0))();

  /// 홈 내 식물 목록 보기: true = 앨범(2열), false = 목록
  BoolColumn get homeGrid => boolean().withDefault(const Constant(true))();

  /// 알림 시점: true = 하루 전에 알림, false = 당일
  BoolColumn get notifyDayBefore =>
      boolean().withDefault(const Constant(false))();

  /// (미사용) 라이트 시안 비교용이었음. 2026-09-17 화이트로 확정되어 읽지 않는다.
  IntColumn get themeVariant => integer().withDefault(const Constant(0))();

  /// 알림 잠시 멈추기: 이 날짜(포함)까지 알림을 보내지 않는다. null 이면 켜짐
  DateTimeColumn get notifyPausedUntil => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
