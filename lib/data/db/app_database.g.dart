// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SpeciesTable extends Species with TableInfo<$SpeciesTable, SpeciesRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpeciesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _scientificNameMeta = const VerificationMeta(
    'scientificName',
  );
  @override
  late final GeneratedColumn<String> scientificName = GeneratedColumn<String>(
    'scientific_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> koNames =
      GeneratedColumn<String>(
        'ko_names',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>($SpeciesTable.$converterkoNames);
  static const VerificationMeta _familyMeta = const VerificationMeta('family');
  @override
  late final GeneratedColumn<String> family = GeneratedColumn<String>(
    'family',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _baseWaterDaysMeta = const VerificationMeta(
    'baseWaterDays',
  );
  @override
  late final GeneratedColumn<int> baseWaterDays = GeneratedColumn<int>(
    'base_water_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LightPref, String> lightPref =
      GeneratedColumn<String>(
        'light_pref',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LightPref>($SpeciesTable.$converterlightPref);
  static const VerificationMeta _toxicPetMeta = const VerificationMeta(
    'toxicPet',
  );
  @override
  late final GeneratedColumn<bool> toxicPet = GeneratedColumn<bool>(
    'toxic_pet',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("toxic_pet" IN (0, 1))',
    ),
  );
  static const VerificationMeta _toxicChildMeta = const VerificationMeta(
    'toxicChild',
  );
  @override
  late final GeneratedColumn<bool> toxicChild = GeneratedColumn<bool>(
    'toxic_child',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("toxic_child" IN (0, 1))',
    ),
  );
  static const VerificationMeta _tempMinMeta = const VerificationMeta(
    'tempMin',
  );
  @override
  late final GeneratedColumn<int> tempMin = GeneratedColumn<int>(
    'temp_min',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tempMaxMeta = const VerificationMeta(
    'tempMax',
  );
  @override
  late final GeneratedColumn<int> tempMax = GeneratedColumn<int>(
    'temp_max',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fertDaysMeta = const VerificationMeta(
    'fertDays',
  );
  @override
  late final GeneratedColumn<int> fertDays = GeneratedColumn<int>(
    'fert_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repotMonthsMeta = const VerificationMeta(
    'repotMonths',
  );
  @override
  late final GeneratedColumn<int> repotMonths = GeneratedColumn<int>(
    'repot_months',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  commonIssues = GeneratedColumn<String>(
    'common_issues',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  ).withConverter<List<String>>($SpeciesTable.$convertercommonIssues);
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('foliage'),
  );
  static const VerificationMeta _searchTextMeta = const VerificationMeta(
    'searchText',
  );
  @override
  late final GeneratedColumn<String> searchText = GeneratedColumn<String>(
    'search_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    scientificName,
    koNames,
    family,
    baseWaterDays,
    lightPref,
    toxicPet,
    toxicChild,
    tempMin,
    tempMax,
    fertDays,
    repotMonths,
    commonIssues,
    category,
    searchText,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'species';
  @override
  VerificationContext validateIntegrity(
    Insertable<SpeciesRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('scientific_name')) {
      context.handle(
        _scientificNameMeta,
        scientificName.isAcceptableOrUnknown(
          data['scientific_name']!,
          _scientificNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scientificNameMeta);
    }
    if (data.containsKey('family')) {
      context.handle(
        _familyMeta,
        family.isAcceptableOrUnknown(data['family']!, _familyMeta),
      );
    }
    if (data.containsKey('base_water_days')) {
      context.handle(
        _baseWaterDaysMeta,
        baseWaterDays.isAcceptableOrUnknown(
          data['base_water_days']!,
          _baseWaterDaysMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_baseWaterDaysMeta);
    }
    if (data.containsKey('toxic_pet')) {
      context.handle(
        _toxicPetMeta,
        toxicPet.isAcceptableOrUnknown(data['toxic_pet']!, _toxicPetMeta),
      );
    } else if (isInserting) {
      context.missing(_toxicPetMeta);
    }
    if (data.containsKey('toxic_child')) {
      context.handle(
        _toxicChildMeta,
        toxicChild.isAcceptableOrUnknown(data['toxic_child']!, _toxicChildMeta),
      );
    } else if (isInserting) {
      context.missing(_toxicChildMeta);
    }
    if (data.containsKey('temp_min')) {
      context.handle(
        _tempMinMeta,
        tempMin.isAcceptableOrUnknown(data['temp_min']!, _tempMinMeta),
      );
    }
    if (data.containsKey('temp_max')) {
      context.handle(
        _tempMaxMeta,
        tempMax.isAcceptableOrUnknown(data['temp_max']!, _tempMaxMeta),
      );
    }
    if (data.containsKey('fert_days')) {
      context.handle(
        _fertDaysMeta,
        fertDays.isAcceptableOrUnknown(data['fert_days']!, _fertDaysMeta),
      );
    }
    if (data.containsKey('repot_months')) {
      context.handle(
        _repotMonthsMeta,
        repotMonths.isAcceptableOrUnknown(
          data['repot_months']!,
          _repotMonthsMeta,
        ),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('search_text')) {
      context.handle(
        _searchTextMeta,
        searchText.isAcceptableOrUnknown(data['search_text']!, _searchTextMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SpeciesRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpeciesRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      scientificName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scientific_name'],
      )!,
      koNames: $SpeciesTable.$converterkoNames.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}ko_names'],
        )!,
      ),
      family: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}family'],
      ),
      baseWaterDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_water_days'],
      )!,
      lightPref: $SpeciesTable.$converterlightPref.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}light_pref'],
        )!,
      ),
      toxicPet: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}toxic_pet'],
      )!,
      toxicChild: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}toxic_child'],
      )!,
      tempMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}temp_min'],
      ),
      tempMax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}temp_max'],
      ),
      fertDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fert_days'],
      ),
      repotMonths: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repot_months'],
      ),
      commonIssues: $SpeciesTable.$convertercommonIssues.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}common_issues'],
        )!,
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      searchText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}search_text'],
      )!,
    );
  }

  @override
  $SpeciesTable createAlias(String alias) {
    return $SpeciesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterkoNames =
      const StringListConverter();
  static JsonTypeConverter2<LightPref, String, String> $converterlightPref =
      const EnumNameConverter<LightPref>(LightPref.values);
  static TypeConverter<List<String>, String> $convertercommonIssues =
      const StringListConverter();
}

class SpeciesRow extends DataClass implements Insertable<SpeciesRow> {
  final int id;
  final String scientificName;
  final List<String> koNames;
  final String? family;
  final int baseWaterDays;
  final LightPref lightPref;
  final bool toxicPet;
  final bool toxicChild;
  final int? tempMin;
  final int? tempMax;
  final int? fertDays;
  final int? repotMonths;
  final List<String> commonIssues;

  /// foliage / succulent / herb / flower / other
  final String category;

  /// 검색용: ko_names를 공백으로 이어붙인 소문자 문자열
  final String searchText;
  const SpeciesRow({
    required this.id,
    required this.scientificName,
    required this.koNames,
    this.family,
    required this.baseWaterDays,
    required this.lightPref,
    required this.toxicPet,
    required this.toxicChild,
    this.tempMin,
    this.tempMax,
    this.fertDays,
    this.repotMonths,
    required this.commonIssues,
    required this.category,
    required this.searchText,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['scientific_name'] = Variable<String>(scientificName);
    {
      map['ko_names'] = Variable<String>(
        $SpeciesTable.$converterkoNames.toSql(koNames),
      );
    }
    if (!nullToAbsent || family != null) {
      map['family'] = Variable<String>(family);
    }
    map['base_water_days'] = Variable<int>(baseWaterDays);
    {
      map['light_pref'] = Variable<String>(
        $SpeciesTable.$converterlightPref.toSql(lightPref),
      );
    }
    map['toxic_pet'] = Variable<bool>(toxicPet);
    map['toxic_child'] = Variable<bool>(toxicChild);
    if (!nullToAbsent || tempMin != null) {
      map['temp_min'] = Variable<int>(tempMin);
    }
    if (!nullToAbsent || tempMax != null) {
      map['temp_max'] = Variable<int>(tempMax);
    }
    if (!nullToAbsent || fertDays != null) {
      map['fert_days'] = Variable<int>(fertDays);
    }
    if (!nullToAbsent || repotMonths != null) {
      map['repot_months'] = Variable<int>(repotMonths);
    }
    {
      map['common_issues'] = Variable<String>(
        $SpeciesTable.$convertercommonIssues.toSql(commonIssues),
      );
    }
    map['category'] = Variable<String>(category);
    map['search_text'] = Variable<String>(searchText);
    return map;
  }

  SpeciesCompanion toCompanion(bool nullToAbsent) {
    return SpeciesCompanion(
      id: Value(id),
      scientificName: Value(scientificName),
      koNames: Value(koNames),
      family: family == null && nullToAbsent
          ? const Value.absent()
          : Value(family),
      baseWaterDays: Value(baseWaterDays),
      lightPref: Value(lightPref),
      toxicPet: Value(toxicPet),
      toxicChild: Value(toxicChild),
      tempMin: tempMin == null && nullToAbsent
          ? const Value.absent()
          : Value(tempMin),
      tempMax: tempMax == null && nullToAbsent
          ? const Value.absent()
          : Value(tempMax),
      fertDays: fertDays == null && nullToAbsent
          ? const Value.absent()
          : Value(fertDays),
      repotMonths: repotMonths == null && nullToAbsent
          ? const Value.absent()
          : Value(repotMonths),
      commonIssues: Value(commonIssues),
      category: Value(category),
      searchText: Value(searchText),
    );
  }

  factory SpeciesRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpeciesRow(
      id: serializer.fromJson<int>(json['id']),
      scientificName: serializer.fromJson<String>(json['scientificName']),
      koNames: serializer.fromJson<List<String>>(json['koNames']),
      family: serializer.fromJson<String?>(json['family']),
      baseWaterDays: serializer.fromJson<int>(json['baseWaterDays']),
      lightPref: $SpeciesTable.$converterlightPref.fromJson(
        serializer.fromJson<String>(json['lightPref']),
      ),
      toxicPet: serializer.fromJson<bool>(json['toxicPet']),
      toxicChild: serializer.fromJson<bool>(json['toxicChild']),
      tempMin: serializer.fromJson<int?>(json['tempMin']),
      tempMax: serializer.fromJson<int?>(json['tempMax']),
      fertDays: serializer.fromJson<int?>(json['fertDays']),
      repotMonths: serializer.fromJson<int?>(json['repotMonths']),
      commonIssues: serializer.fromJson<List<String>>(json['commonIssues']),
      category: serializer.fromJson<String>(json['category']),
      searchText: serializer.fromJson<String>(json['searchText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'scientificName': serializer.toJson<String>(scientificName),
      'koNames': serializer.toJson<List<String>>(koNames),
      'family': serializer.toJson<String?>(family),
      'baseWaterDays': serializer.toJson<int>(baseWaterDays),
      'lightPref': serializer.toJson<String>(
        $SpeciesTable.$converterlightPref.toJson(lightPref),
      ),
      'toxicPet': serializer.toJson<bool>(toxicPet),
      'toxicChild': serializer.toJson<bool>(toxicChild),
      'tempMin': serializer.toJson<int?>(tempMin),
      'tempMax': serializer.toJson<int?>(tempMax),
      'fertDays': serializer.toJson<int?>(fertDays),
      'repotMonths': serializer.toJson<int?>(repotMonths),
      'commonIssues': serializer.toJson<List<String>>(commonIssues),
      'category': serializer.toJson<String>(category),
      'searchText': serializer.toJson<String>(searchText),
    };
  }

  SpeciesRow copyWith({
    int? id,
    String? scientificName,
    List<String>? koNames,
    Value<String?> family = const Value.absent(),
    int? baseWaterDays,
    LightPref? lightPref,
    bool? toxicPet,
    bool? toxicChild,
    Value<int?> tempMin = const Value.absent(),
    Value<int?> tempMax = const Value.absent(),
    Value<int?> fertDays = const Value.absent(),
    Value<int?> repotMonths = const Value.absent(),
    List<String>? commonIssues,
    String? category,
    String? searchText,
  }) => SpeciesRow(
    id: id ?? this.id,
    scientificName: scientificName ?? this.scientificName,
    koNames: koNames ?? this.koNames,
    family: family.present ? family.value : this.family,
    baseWaterDays: baseWaterDays ?? this.baseWaterDays,
    lightPref: lightPref ?? this.lightPref,
    toxicPet: toxicPet ?? this.toxicPet,
    toxicChild: toxicChild ?? this.toxicChild,
    tempMin: tempMin.present ? tempMin.value : this.tempMin,
    tempMax: tempMax.present ? tempMax.value : this.tempMax,
    fertDays: fertDays.present ? fertDays.value : this.fertDays,
    repotMonths: repotMonths.present ? repotMonths.value : this.repotMonths,
    commonIssues: commonIssues ?? this.commonIssues,
    category: category ?? this.category,
    searchText: searchText ?? this.searchText,
  );
  SpeciesRow copyWithCompanion(SpeciesCompanion data) {
    return SpeciesRow(
      id: data.id.present ? data.id.value : this.id,
      scientificName: data.scientificName.present
          ? data.scientificName.value
          : this.scientificName,
      koNames: data.koNames.present ? data.koNames.value : this.koNames,
      family: data.family.present ? data.family.value : this.family,
      baseWaterDays: data.baseWaterDays.present
          ? data.baseWaterDays.value
          : this.baseWaterDays,
      lightPref: data.lightPref.present ? data.lightPref.value : this.lightPref,
      toxicPet: data.toxicPet.present ? data.toxicPet.value : this.toxicPet,
      toxicChild: data.toxicChild.present
          ? data.toxicChild.value
          : this.toxicChild,
      tempMin: data.tempMin.present ? data.tempMin.value : this.tempMin,
      tempMax: data.tempMax.present ? data.tempMax.value : this.tempMax,
      fertDays: data.fertDays.present ? data.fertDays.value : this.fertDays,
      repotMonths: data.repotMonths.present
          ? data.repotMonths.value
          : this.repotMonths,
      commonIssues: data.commonIssues.present
          ? data.commonIssues.value
          : this.commonIssues,
      category: data.category.present ? data.category.value : this.category,
      searchText: data.searchText.present
          ? data.searchText.value
          : this.searchText,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SpeciesRow(')
          ..write('id: $id, ')
          ..write('scientificName: $scientificName, ')
          ..write('koNames: $koNames, ')
          ..write('family: $family, ')
          ..write('baseWaterDays: $baseWaterDays, ')
          ..write('lightPref: $lightPref, ')
          ..write('toxicPet: $toxicPet, ')
          ..write('toxicChild: $toxicChild, ')
          ..write('tempMin: $tempMin, ')
          ..write('tempMax: $tempMax, ')
          ..write('fertDays: $fertDays, ')
          ..write('repotMonths: $repotMonths, ')
          ..write('commonIssues: $commonIssues, ')
          ..write('category: $category, ')
          ..write('searchText: $searchText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    scientificName,
    koNames,
    family,
    baseWaterDays,
    lightPref,
    toxicPet,
    toxicChild,
    tempMin,
    tempMax,
    fertDays,
    repotMonths,
    commonIssues,
    category,
    searchText,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpeciesRow &&
          other.id == this.id &&
          other.scientificName == this.scientificName &&
          other.koNames == this.koNames &&
          other.family == this.family &&
          other.baseWaterDays == this.baseWaterDays &&
          other.lightPref == this.lightPref &&
          other.toxicPet == this.toxicPet &&
          other.toxicChild == this.toxicChild &&
          other.tempMin == this.tempMin &&
          other.tempMax == this.tempMax &&
          other.fertDays == this.fertDays &&
          other.repotMonths == this.repotMonths &&
          other.commonIssues == this.commonIssues &&
          other.category == this.category &&
          other.searchText == this.searchText);
}

class SpeciesCompanion extends UpdateCompanion<SpeciesRow> {
  final Value<int> id;
  final Value<String> scientificName;
  final Value<List<String>> koNames;
  final Value<String?> family;
  final Value<int> baseWaterDays;
  final Value<LightPref> lightPref;
  final Value<bool> toxicPet;
  final Value<bool> toxicChild;
  final Value<int?> tempMin;
  final Value<int?> tempMax;
  final Value<int?> fertDays;
  final Value<int?> repotMonths;
  final Value<List<String>> commonIssues;
  final Value<String> category;
  final Value<String> searchText;
  const SpeciesCompanion({
    this.id = const Value.absent(),
    this.scientificName = const Value.absent(),
    this.koNames = const Value.absent(),
    this.family = const Value.absent(),
    this.baseWaterDays = const Value.absent(),
    this.lightPref = const Value.absent(),
    this.toxicPet = const Value.absent(),
    this.toxicChild = const Value.absent(),
    this.tempMin = const Value.absent(),
    this.tempMax = const Value.absent(),
    this.fertDays = const Value.absent(),
    this.repotMonths = const Value.absent(),
    this.commonIssues = const Value.absent(),
    this.category = const Value.absent(),
    this.searchText = const Value.absent(),
  });
  SpeciesCompanion.insert({
    this.id = const Value.absent(),
    required String scientificName,
    required List<String> koNames,
    this.family = const Value.absent(),
    required int baseWaterDays,
    required LightPref lightPref,
    required bool toxicPet,
    required bool toxicChild,
    this.tempMin = const Value.absent(),
    this.tempMax = const Value.absent(),
    this.fertDays = const Value.absent(),
    this.repotMonths = const Value.absent(),
    this.commonIssues = const Value.absent(),
    this.category = const Value.absent(),
    this.searchText = const Value.absent(),
  }) : scientificName = Value(scientificName),
       koNames = Value(koNames),
       baseWaterDays = Value(baseWaterDays),
       lightPref = Value(lightPref),
       toxicPet = Value(toxicPet),
       toxicChild = Value(toxicChild);
  static Insertable<SpeciesRow> custom({
    Expression<int>? id,
    Expression<String>? scientificName,
    Expression<String>? koNames,
    Expression<String>? family,
    Expression<int>? baseWaterDays,
    Expression<String>? lightPref,
    Expression<bool>? toxicPet,
    Expression<bool>? toxicChild,
    Expression<int>? tempMin,
    Expression<int>? tempMax,
    Expression<int>? fertDays,
    Expression<int>? repotMonths,
    Expression<String>? commonIssues,
    Expression<String>? category,
    Expression<String>? searchText,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (scientificName != null) 'scientific_name': scientificName,
      if (koNames != null) 'ko_names': koNames,
      if (family != null) 'family': family,
      if (baseWaterDays != null) 'base_water_days': baseWaterDays,
      if (lightPref != null) 'light_pref': lightPref,
      if (toxicPet != null) 'toxic_pet': toxicPet,
      if (toxicChild != null) 'toxic_child': toxicChild,
      if (tempMin != null) 'temp_min': tempMin,
      if (tempMax != null) 'temp_max': tempMax,
      if (fertDays != null) 'fert_days': fertDays,
      if (repotMonths != null) 'repot_months': repotMonths,
      if (commonIssues != null) 'common_issues': commonIssues,
      if (category != null) 'category': category,
      if (searchText != null) 'search_text': searchText,
    });
  }

  SpeciesCompanion copyWith({
    Value<int>? id,
    Value<String>? scientificName,
    Value<List<String>>? koNames,
    Value<String?>? family,
    Value<int>? baseWaterDays,
    Value<LightPref>? lightPref,
    Value<bool>? toxicPet,
    Value<bool>? toxicChild,
    Value<int?>? tempMin,
    Value<int?>? tempMax,
    Value<int?>? fertDays,
    Value<int?>? repotMonths,
    Value<List<String>>? commonIssues,
    Value<String>? category,
    Value<String>? searchText,
  }) {
    return SpeciesCompanion(
      id: id ?? this.id,
      scientificName: scientificName ?? this.scientificName,
      koNames: koNames ?? this.koNames,
      family: family ?? this.family,
      baseWaterDays: baseWaterDays ?? this.baseWaterDays,
      lightPref: lightPref ?? this.lightPref,
      toxicPet: toxicPet ?? this.toxicPet,
      toxicChild: toxicChild ?? this.toxicChild,
      tempMin: tempMin ?? this.tempMin,
      tempMax: tempMax ?? this.tempMax,
      fertDays: fertDays ?? this.fertDays,
      repotMonths: repotMonths ?? this.repotMonths,
      commonIssues: commonIssues ?? this.commonIssues,
      category: category ?? this.category,
      searchText: searchText ?? this.searchText,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (scientificName.present) {
      map['scientific_name'] = Variable<String>(scientificName.value);
    }
    if (koNames.present) {
      map['ko_names'] = Variable<String>(
        $SpeciesTable.$converterkoNames.toSql(koNames.value),
      );
    }
    if (family.present) {
      map['family'] = Variable<String>(family.value);
    }
    if (baseWaterDays.present) {
      map['base_water_days'] = Variable<int>(baseWaterDays.value);
    }
    if (lightPref.present) {
      map['light_pref'] = Variable<String>(
        $SpeciesTable.$converterlightPref.toSql(lightPref.value),
      );
    }
    if (toxicPet.present) {
      map['toxic_pet'] = Variable<bool>(toxicPet.value);
    }
    if (toxicChild.present) {
      map['toxic_child'] = Variable<bool>(toxicChild.value);
    }
    if (tempMin.present) {
      map['temp_min'] = Variable<int>(tempMin.value);
    }
    if (tempMax.present) {
      map['temp_max'] = Variable<int>(tempMax.value);
    }
    if (fertDays.present) {
      map['fert_days'] = Variable<int>(fertDays.value);
    }
    if (repotMonths.present) {
      map['repot_months'] = Variable<int>(repotMonths.value);
    }
    if (commonIssues.present) {
      map['common_issues'] = Variable<String>(
        $SpeciesTable.$convertercommonIssues.toSql(commonIssues.value),
      );
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (searchText.present) {
      map['search_text'] = Variable<String>(searchText.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpeciesCompanion(')
          ..write('id: $id, ')
          ..write('scientificName: $scientificName, ')
          ..write('koNames: $koNames, ')
          ..write('family: $family, ')
          ..write('baseWaterDays: $baseWaterDays, ')
          ..write('lightPref: $lightPref, ')
          ..write('toxicPet: $toxicPet, ')
          ..write('toxicChild: $toxicChild, ')
          ..write('tempMin: $tempMin, ')
          ..write('tempMax: $tempMax, ')
          ..write('fertDays: $fertDays, ')
          ..write('repotMonths: $repotMonths, ')
          ..write('commonIssues: $commonIssues, ')
          ..write('category: $category, ')
          ..write('searchText: $searchText')
          ..write(')'))
        .toString();
  }
}

class $SpacesTable extends Spaces with TableInfo<$SpacesTable, Space> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpacesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<WindowDir, String> windowDir =
      GeneratedColumn<String>(
        'window_dir',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<WindowDir>($SpacesTable.$converterwindowDir);
  @override
  late final GeneratedColumnWithTypeConverter<WindowDist, String> windowDist =
      GeneratedColumn<String>(
        'window_dist',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<WindowDist>($SpacesTable.$converterwindowDist);
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    windowDir,
    windowDist,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'spaces';
  @override
  VerificationContext validateIntegrity(
    Insertable<Space> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Space map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Space(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      windowDir: $SpacesTable.$converterwindowDir.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}window_dir'],
        )!,
      ),
      windowDist: $SpacesTable.$converterwindowDist.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}window_dist'],
        )!,
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $SpacesTable createAlias(String alias) {
    return $SpacesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<WindowDir, String, String> $converterwindowDir =
      const EnumNameConverter<WindowDir>(WindowDir.values);
  static JsonTypeConverter2<WindowDist, String, String> $converterwindowDist =
      const EnumNameConverter<WindowDist>(WindowDist.values);
}

class Space extends DataClass implements Insertable<Space> {
  final int id;
  final String name;
  final WindowDir windowDir;
  final WindowDist windowDist;
  final int sortOrder;
  const Space({
    required this.id,
    required this.name,
    required this.windowDir,
    required this.windowDist,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['window_dir'] = Variable<String>(
        $SpacesTable.$converterwindowDir.toSql(windowDir),
      );
    }
    {
      map['window_dist'] = Variable<String>(
        $SpacesTable.$converterwindowDist.toSql(windowDist),
      );
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  SpacesCompanion toCompanion(bool nullToAbsent) {
    return SpacesCompanion(
      id: Value(id),
      name: Value(name),
      windowDir: Value(windowDir),
      windowDist: Value(windowDist),
      sortOrder: Value(sortOrder),
    );
  }

  factory Space.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Space(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      windowDir: $SpacesTable.$converterwindowDir.fromJson(
        serializer.fromJson<String>(json['windowDir']),
      ),
      windowDist: $SpacesTable.$converterwindowDist.fromJson(
        serializer.fromJson<String>(json['windowDist']),
      ),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'windowDir': serializer.toJson<String>(
        $SpacesTable.$converterwindowDir.toJson(windowDir),
      ),
      'windowDist': serializer.toJson<String>(
        $SpacesTable.$converterwindowDist.toJson(windowDist),
      ),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Space copyWith({
    int? id,
    String? name,
    WindowDir? windowDir,
    WindowDist? windowDist,
    int? sortOrder,
  }) => Space(
    id: id ?? this.id,
    name: name ?? this.name,
    windowDir: windowDir ?? this.windowDir,
    windowDist: windowDist ?? this.windowDist,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  Space copyWithCompanion(SpacesCompanion data) {
    return Space(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      windowDir: data.windowDir.present ? data.windowDir.value : this.windowDir,
      windowDist: data.windowDist.present
          ? data.windowDist.value
          : this.windowDist,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Space(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('windowDir: $windowDir, ')
          ..write('windowDist: $windowDist, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, windowDir, windowDist, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Space &&
          other.id == this.id &&
          other.name == this.name &&
          other.windowDir == this.windowDir &&
          other.windowDist == this.windowDist &&
          other.sortOrder == this.sortOrder);
}

class SpacesCompanion extends UpdateCompanion<Space> {
  final Value<int> id;
  final Value<String> name;
  final Value<WindowDir> windowDir;
  final Value<WindowDist> windowDist;
  final Value<int> sortOrder;
  const SpacesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.windowDir = const Value.absent(),
    this.windowDist = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  SpacesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required WindowDir windowDir,
    required WindowDist windowDist,
    this.sortOrder = const Value.absent(),
  }) : name = Value(name),
       windowDir = Value(windowDir),
       windowDist = Value(windowDist);
  static Insertable<Space> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? windowDir,
    Expression<String>? windowDist,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (windowDir != null) 'window_dir': windowDir,
      if (windowDist != null) 'window_dist': windowDist,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  SpacesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<WindowDir>? windowDir,
    Value<WindowDist>? windowDist,
    Value<int>? sortOrder,
  }) {
    return SpacesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      windowDir: windowDir ?? this.windowDir,
      windowDist: windowDist ?? this.windowDist,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (windowDir.present) {
      map['window_dir'] = Variable<String>(
        $SpacesTable.$converterwindowDir.toSql(windowDir.value),
      );
    }
    if (windowDist.present) {
      map['window_dist'] = Variable<String>(
        $SpacesTable.$converterwindowDist.toSql(windowDist.value),
      );
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpacesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('windowDir: $windowDir, ')
          ..write('windowDist: $windowDist, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $PlantsTable extends Plants with TableInfo<$PlantsTable, Plant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _speciesIdMeta = const VerificationMeta(
    'speciesId',
  );
  @override
  late final GeneratedColumn<int> speciesId = GeneratedColumn<int>(
    'species_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES species (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _nicknameMeta = const VerificationMeta(
    'nickname',
  );
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
    'nickname',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _spaceIdMeta = const VerificationMeta(
    'spaceId',
  );
  @override
  late final GeneratedColumn<int> spaceId = GeneratedColumn<int>(
    'space_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES spaces (id) ON DELETE SET NULL',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<PotSize, String> potSize =
      GeneratedColumn<String>(
        'pot_size',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PotSize>($PlantsTable.$converterpotSize);
  static const VerificationMeta _hasDrainageMeta = const VerificationMeta(
    'hasDrainage',
  );
  @override
  late final GeneratedColumn<bool> hasDrainage = GeneratedColumn<bool>(
    'has_drainage',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_drainage" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _waterIntervalDaysMeta = const VerificationMeta(
    'waterIntervalDays',
  );
  @override
  late final GeneratedColumn<int> waterIntervalDays = GeneratedColumn<int>(
    'water_interval_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _manualOverrideMeta = const VerificationMeta(
    'manualOverride',
  );
  @override
  late final GeneratedColumn<bool> manualOverride = GeneratedColumn<bool>(
    'manual_override',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("manual_override" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _feedbackCoefMeta = const VerificationMeta(
    'feedbackCoef',
  );
  @override
  late final GeneratedColumn<double> feedbackCoef = GeneratedColumn<double>(
    'feedback_coef',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _dryStreakMeta = const VerificationMeta(
    'dryStreak',
  );
  @override
  late final GeneratedColumn<int> dryStreak = GeneratedColumn<int>(
    'dry_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastWateredAtMeta = const VerificationMeta(
    'lastWateredAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastWateredAt =
      GeneratedColumn<DateTime>(
        'last_watered_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _nextCheckAtMeta = const VerificationMeta(
    'nextCheckAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextCheckAt = GeneratedColumn<DateTime>(
    'next_check_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fertIntervalDaysMeta = const VerificationMeta(
    'fertIntervalDays',
  );
  @override
  late final GeneratedColumn<int> fertIntervalDays = GeneratedColumn<int>(
    'fert_interval_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastFertAtMeta = const VerificationMeta(
    'lastFertAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastFertAt = GeneratedColumn<DateTime>(
    'last_fert_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repotAtMeta = const VerificationMeta(
    'repotAt',
  );
  @override
  late final GeneratedColumn<DateTime> repotAt = GeneratedColumn<DateTime>(
    'repot_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    speciesId,
    nickname,
    photoPath,
    spaceId,
    potSize,
    hasDrainage,
    waterIntervalDays,
    manualOverride,
    feedbackCoef,
    dryStreak,
    lastWateredAt,
    nextCheckAt,
    fertIntervalDays,
    lastFertAt,
    repotAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plants';
  @override
  VerificationContext validateIntegrity(
    Insertable<Plant> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('species_id')) {
      context.handle(
        _speciesIdMeta,
        speciesId.isAcceptableOrUnknown(data['species_id']!, _speciesIdMeta),
      );
    }
    if (data.containsKey('nickname')) {
      context.handle(
        _nicknameMeta,
        nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta),
      );
    } else if (isInserting) {
      context.missing(_nicknameMeta);
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('space_id')) {
      context.handle(
        _spaceIdMeta,
        spaceId.isAcceptableOrUnknown(data['space_id']!, _spaceIdMeta),
      );
    }
    if (data.containsKey('has_drainage')) {
      context.handle(
        _hasDrainageMeta,
        hasDrainage.isAcceptableOrUnknown(
          data['has_drainage']!,
          _hasDrainageMeta,
        ),
      );
    }
    if (data.containsKey('water_interval_days')) {
      context.handle(
        _waterIntervalDaysMeta,
        waterIntervalDays.isAcceptableOrUnknown(
          data['water_interval_days']!,
          _waterIntervalDaysMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_waterIntervalDaysMeta);
    }
    if (data.containsKey('manual_override')) {
      context.handle(
        _manualOverrideMeta,
        manualOverride.isAcceptableOrUnknown(
          data['manual_override']!,
          _manualOverrideMeta,
        ),
      );
    }
    if (data.containsKey('feedback_coef')) {
      context.handle(
        _feedbackCoefMeta,
        feedbackCoef.isAcceptableOrUnknown(
          data['feedback_coef']!,
          _feedbackCoefMeta,
        ),
      );
    }
    if (data.containsKey('dry_streak')) {
      context.handle(
        _dryStreakMeta,
        dryStreak.isAcceptableOrUnknown(data['dry_streak']!, _dryStreakMeta),
      );
    }
    if (data.containsKey('last_watered_at')) {
      context.handle(
        _lastWateredAtMeta,
        lastWateredAt.isAcceptableOrUnknown(
          data['last_watered_at']!,
          _lastWateredAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastWateredAtMeta);
    }
    if (data.containsKey('next_check_at')) {
      context.handle(
        _nextCheckAtMeta,
        nextCheckAt.isAcceptableOrUnknown(
          data['next_check_at']!,
          _nextCheckAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextCheckAtMeta);
    }
    if (data.containsKey('fert_interval_days')) {
      context.handle(
        _fertIntervalDaysMeta,
        fertIntervalDays.isAcceptableOrUnknown(
          data['fert_interval_days']!,
          _fertIntervalDaysMeta,
        ),
      );
    }
    if (data.containsKey('last_fert_at')) {
      context.handle(
        _lastFertAtMeta,
        lastFertAt.isAcceptableOrUnknown(
          data['last_fert_at']!,
          _lastFertAtMeta,
        ),
      );
    }
    if (data.containsKey('repot_at')) {
      context.handle(
        _repotAtMeta,
        repotAt.isAcceptableOrUnknown(data['repot_at']!, _repotAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Plant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Plant(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      speciesId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}species_id'],
      ),
      nickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nickname'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      spaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}space_id'],
      ),
      potSize: $PlantsTable.$converterpotSize.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}pot_size'],
        )!,
      ),
      hasDrainage: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_drainage'],
      )!,
      waterIntervalDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}water_interval_days'],
      )!,
      manualOverride: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}manual_override'],
      )!,
      feedbackCoef: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}feedback_coef'],
      )!,
      dryStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dry_streak'],
      )!,
      lastWateredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_watered_at'],
      )!,
      nextCheckAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_check_at'],
      )!,
      fertIntervalDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fert_interval_days'],
      ),
      lastFertAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_fert_at'],
      ),
      repotAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}repot_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PlantsTable createAlias(String alias) {
    return $PlantsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PotSize, String, String> $converterpotSize =
      const EnumNameConverter<PotSize>(PotSize.values);
}

class Plant extends DataClass implements Insertable<Plant> {
  final int id;
  final int? speciesId;
  final String nickname;
  final String? photoPath;
  final int? spaceId;
  final PotSize potSize;
  final bool hasDrainage;

  /// 현재 적용 물주기 주기(일). 계산값 또는 수동값.
  final int waterIntervalDays;
  final bool manualOverride;

  /// 5-1 feedback_coef. 초기 1.0, 범위 0.5~2.0
  final double feedbackCoef;

  /// "말랐음" 연속 횟수 (2회 연속이면 feedback_coef ×0.9)
  final int dryStreak;
  final DateTime lastWateredAt;
  final DateTime nextCheckAt;
  final int? fertIntervalDays;
  final DateTime? lastFertAt;
  final DateTime? repotAt;
  final DateTime createdAt;
  const Plant({
    required this.id,
    this.speciesId,
    required this.nickname,
    this.photoPath,
    this.spaceId,
    required this.potSize,
    required this.hasDrainage,
    required this.waterIntervalDays,
    required this.manualOverride,
    required this.feedbackCoef,
    required this.dryStreak,
    required this.lastWateredAt,
    required this.nextCheckAt,
    this.fertIntervalDays,
    this.lastFertAt,
    this.repotAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || speciesId != null) {
      map['species_id'] = Variable<int>(speciesId);
    }
    map['nickname'] = Variable<String>(nickname);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || spaceId != null) {
      map['space_id'] = Variable<int>(spaceId);
    }
    {
      map['pot_size'] = Variable<String>(
        $PlantsTable.$converterpotSize.toSql(potSize),
      );
    }
    map['has_drainage'] = Variable<bool>(hasDrainage);
    map['water_interval_days'] = Variable<int>(waterIntervalDays);
    map['manual_override'] = Variable<bool>(manualOverride);
    map['feedback_coef'] = Variable<double>(feedbackCoef);
    map['dry_streak'] = Variable<int>(dryStreak);
    map['last_watered_at'] = Variable<DateTime>(lastWateredAt);
    map['next_check_at'] = Variable<DateTime>(nextCheckAt);
    if (!nullToAbsent || fertIntervalDays != null) {
      map['fert_interval_days'] = Variable<int>(fertIntervalDays);
    }
    if (!nullToAbsent || lastFertAt != null) {
      map['last_fert_at'] = Variable<DateTime>(lastFertAt);
    }
    if (!nullToAbsent || repotAt != null) {
      map['repot_at'] = Variable<DateTime>(repotAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PlantsCompanion toCompanion(bool nullToAbsent) {
    return PlantsCompanion(
      id: Value(id),
      speciesId: speciesId == null && nullToAbsent
          ? const Value.absent()
          : Value(speciesId),
      nickname: Value(nickname),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      spaceId: spaceId == null && nullToAbsent
          ? const Value.absent()
          : Value(spaceId),
      potSize: Value(potSize),
      hasDrainage: Value(hasDrainage),
      waterIntervalDays: Value(waterIntervalDays),
      manualOverride: Value(manualOverride),
      feedbackCoef: Value(feedbackCoef),
      dryStreak: Value(dryStreak),
      lastWateredAt: Value(lastWateredAt),
      nextCheckAt: Value(nextCheckAt),
      fertIntervalDays: fertIntervalDays == null && nullToAbsent
          ? const Value.absent()
          : Value(fertIntervalDays),
      lastFertAt: lastFertAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastFertAt),
      repotAt: repotAt == null && nullToAbsent
          ? const Value.absent()
          : Value(repotAt),
      createdAt: Value(createdAt),
    );
  }

  factory Plant.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Plant(
      id: serializer.fromJson<int>(json['id']),
      speciesId: serializer.fromJson<int?>(json['speciesId']),
      nickname: serializer.fromJson<String>(json['nickname']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      spaceId: serializer.fromJson<int?>(json['spaceId']),
      potSize: $PlantsTable.$converterpotSize.fromJson(
        serializer.fromJson<String>(json['potSize']),
      ),
      hasDrainage: serializer.fromJson<bool>(json['hasDrainage']),
      waterIntervalDays: serializer.fromJson<int>(json['waterIntervalDays']),
      manualOverride: serializer.fromJson<bool>(json['manualOverride']),
      feedbackCoef: serializer.fromJson<double>(json['feedbackCoef']),
      dryStreak: serializer.fromJson<int>(json['dryStreak']),
      lastWateredAt: serializer.fromJson<DateTime>(json['lastWateredAt']),
      nextCheckAt: serializer.fromJson<DateTime>(json['nextCheckAt']),
      fertIntervalDays: serializer.fromJson<int?>(json['fertIntervalDays']),
      lastFertAt: serializer.fromJson<DateTime?>(json['lastFertAt']),
      repotAt: serializer.fromJson<DateTime?>(json['repotAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'speciesId': serializer.toJson<int?>(speciesId),
      'nickname': serializer.toJson<String>(nickname),
      'photoPath': serializer.toJson<String?>(photoPath),
      'spaceId': serializer.toJson<int?>(spaceId),
      'potSize': serializer.toJson<String>(
        $PlantsTable.$converterpotSize.toJson(potSize),
      ),
      'hasDrainage': serializer.toJson<bool>(hasDrainage),
      'waterIntervalDays': serializer.toJson<int>(waterIntervalDays),
      'manualOverride': serializer.toJson<bool>(manualOverride),
      'feedbackCoef': serializer.toJson<double>(feedbackCoef),
      'dryStreak': serializer.toJson<int>(dryStreak),
      'lastWateredAt': serializer.toJson<DateTime>(lastWateredAt),
      'nextCheckAt': serializer.toJson<DateTime>(nextCheckAt),
      'fertIntervalDays': serializer.toJson<int?>(fertIntervalDays),
      'lastFertAt': serializer.toJson<DateTime?>(lastFertAt),
      'repotAt': serializer.toJson<DateTime?>(repotAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Plant copyWith({
    int? id,
    Value<int?> speciesId = const Value.absent(),
    String? nickname,
    Value<String?> photoPath = const Value.absent(),
    Value<int?> spaceId = const Value.absent(),
    PotSize? potSize,
    bool? hasDrainage,
    int? waterIntervalDays,
    bool? manualOverride,
    double? feedbackCoef,
    int? dryStreak,
    DateTime? lastWateredAt,
    DateTime? nextCheckAt,
    Value<int?> fertIntervalDays = const Value.absent(),
    Value<DateTime?> lastFertAt = const Value.absent(),
    Value<DateTime?> repotAt = const Value.absent(),
    DateTime? createdAt,
  }) => Plant(
    id: id ?? this.id,
    speciesId: speciesId.present ? speciesId.value : this.speciesId,
    nickname: nickname ?? this.nickname,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    spaceId: spaceId.present ? spaceId.value : this.spaceId,
    potSize: potSize ?? this.potSize,
    hasDrainage: hasDrainage ?? this.hasDrainage,
    waterIntervalDays: waterIntervalDays ?? this.waterIntervalDays,
    manualOverride: manualOverride ?? this.manualOverride,
    feedbackCoef: feedbackCoef ?? this.feedbackCoef,
    dryStreak: dryStreak ?? this.dryStreak,
    lastWateredAt: lastWateredAt ?? this.lastWateredAt,
    nextCheckAt: nextCheckAt ?? this.nextCheckAt,
    fertIntervalDays: fertIntervalDays.present
        ? fertIntervalDays.value
        : this.fertIntervalDays,
    lastFertAt: lastFertAt.present ? lastFertAt.value : this.lastFertAt,
    repotAt: repotAt.present ? repotAt.value : this.repotAt,
    createdAt: createdAt ?? this.createdAt,
  );
  Plant copyWithCompanion(PlantsCompanion data) {
    return Plant(
      id: data.id.present ? data.id.value : this.id,
      speciesId: data.speciesId.present ? data.speciesId.value : this.speciesId,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      spaceId: data.spaceId.present ? data.spaceId.value : this.spaceId,
      potSize: data.potSize.present ? data.potSize.value : this.potSize,
      hasDrainage: data.hasDrainage.present
          ? data.hasDrainage.value
          : this.hasDrainage,
      waterIntervalDays: data.waterIntervalDays.present
          ? data.waterIntervalDays.value
          : this.waterIntervalDays,
      manualOverride: data.manualOverride.present
          ? data.manualOverride.value
          : this.manualOverride,
      feedbackCoef: data.feedbackCoef.present
          ? data.feedbackCoef.value
          : this.feedbackCoef,
      dryStreak: data.dryStreak.present ? data.dryStreak.value : this.dryStreak,
      lastWateredAt: data.lastWateredAt.present
          ? data.lastWateredAt.value
          : this.lastWateredAt,
      nextCheckAt: data.nextCheckAt.present
          ? data.nextCheckAt.value
          : this.nextCheckAt,
      fertIntervalDays: data.fertIntervalDays.present
          ? data.fertIntervalDays.value
          : this.fertIntervalDays,
      lastFertAt: data.lastFertAt.present
          ? data.lastFertAt.value
          : this.lastFertAt,
      repotAt: data.repotAt.present ? data.repotAt.value : this.repotAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Plant(')
          ..write('id: $id, ')
          ..write('speciesId: $speciesId, ')
          ..write('nickname: $nickname, ')
          ..write('photoPath: $photoPath, ')
          ..write('spaceId: $spaceId, ')
          ..write('potSize: $potSize, ')
          ..write('hasDrainage: $hasDrainage, ')
          ..write('waterIntervalDays: $waterIntervalDays, ')
          ..write('manualOverride: $manualOverride, ')
          ..write('feedbackCoef: $feedbackCoef, ')
          ..write('dryStreak: $dryStreak, ')
          ..write('lastWateredAt: $lastWateredAt, ')
          ..write('nextCheckAt: $nextCheckAt, ')
          ..write('fertIntervalDays: $fertIntervalDays, ')
          ..write('lastFertAt: $lastFertAt, ')
          ..write('repotAt: $repotAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    speciesId,
    nickname,
    photoPath,
    spaceId,
    potSize,
    hasDrainage,
    waterIntervalDays,
    manualOverride,
    feedbackCoef,
    dryStreak,
    lastWateredAt,
    nextCheckAt,
    fertIntervalDays,
    lastFertAt,
    repotAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Plant &&
          other.id == this.id &&
          other.speciesId == this.speciesId &&
          other.nickname == this.nickname &&
          other.photoPath == this.photoPath &&
          other.spaceId == this.spaceId &&
          other.potSize == this.potSize &&
          other.hasDrainage == this.hasDrainage &&
          other.waterIntervalDays == this.waterIntervalDays &&
          other.manualOverride == this.manualOverride &&
          other.feedbackCoef == this.feedbackCoef &&
          other.dryStreak == this.dryStreak &&
          other.lastWateredAt == this.lastWateredAt &&
          other.nextCheckAt == this.nextCheckAt &&
          other.fertIntervalDays == this.fertIntervalDays &&
          other.lastFertAt == this.lastFertAt &&
          other.repotAt == this.repotAt &&
          other.createdAt == this.createdAt);
}

class PlantsCompanion extends UpdateCompanion<Plant> {
  final Value<int> id;
  final Value<int?> speciesId;
  final Value<String> nickname;
  final Value<String?> photoPath;
  final Value<int?> spaceId;
  final Value<PotSize> potSize;
  final Value<bool> hasDrainage;
  final Value<int> waterIntervalDays;
  final Value<bool> manualOverride;
  final Value<double> feedbackCoef;
  final Value<int> dryStreak;
  final Value<DateTime> lastWateredAt;
  final Value<DateTime> nextCheckAt;
  final Value<int?> fertIntervalDays;
  final Value<DateTime?> lastFertAt;
  final Value<DateTime?> repotAt;
  final Value<DateTime> createdAt;
  const PlantsCompanion({
    this.id = const Value.absent(),
    this.speciesId = const Value.absent(),
    this.nickname = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.spaceId = const Value.absent(),
    this.potSize = const Value.absent(),
    this.hasDrainage = const Value.absent(),
    this.waterIntervalDays = const Value.absent(),
    this.manualOverride = const Value.absent(),
    this.feedbackCoef = const Value.absent(),
    this.dryStreak = const Value.absent(),
    this.lastWateredAt = const Value.absent(),
    this.nextCheckAt = const Value.absent(),
    this.fertIntervalDays = const Value.absent(),
    this.lastFertAt = const Value.absent(),
    this.repotAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PlantsCompanion.insert({
    this.id = const Value.absent(),
    this.speciesId = const Value.absent(),
    required String nickname,
    this.photoPath = const Value.absent(),
    this.spaceId = const Value.absent(),
    required PotSize potSize,
    this.hasDrainage = const Value.absent(),
    required int waterIntervalDays,
    this.manualOverride = const Value.absent(),
    this.feedbackCoef = const Value.absent(),
    this.dryStreak = const Value.absent(),
    required DateTime lastWateredAt,
    required DateTime nextCheckAt,
    this.fertIntervalDays = const Value.absent(),
    this.lastFertAt = const Value.absent(),
    this.repotAt = const Value.absent(),
    required DateTime createdAt,
  }) : nickname = Value(nickname),
       potSize = Value(potSize),
       waterIntervalDays = Value(waterIntervalDays),
       lastWateredAt = Value(lastWateredAt),
       nextCheckAt = Value(nextCheckAt),
       createdAt = Value(createdAt);
  static Insertable<Plant> custom({
    Expression<int>? id,
    Expression<int>? speciesId,
    Expression<String>? nickname,
    Expression<String>? photoPath,
    Expression<int>? spaceId,
    Expression<String>? potSize,
    Expression<bool>? hasDrainage,
    Expression<int>? waterIntervalDays,
    Expression<bool>? manualOverride,
    Expression<double>? feedbackCoef,
    Expression<int>? dryStreak,
    Expression<DateTime>? lastWateredAt,
    Expression<DateTime>? nextCheckAt,
    Expression<int>? fertIntervalDays,
    Expression<DateTime>? lastFertAt,
    Expression<DateTime>? repotAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (speciesId != null) 'species_id': speciesId,
      if (nickname != null) 'nickname': nickname,
      if (photoPath != null) 'photo_path': photoPath,
      if (spaceId != null) 'space_id': spaceId,
      if (potSize != null) 'pot_size': potSize,
      if (hasDrainage != null) 'has_drainage': hasDrainage,
      if (waterIntervalDays != null) 'water_interval_days': waterIntervalDays,
      if (manualOverride != null) 'manual_override': manualOverride,
      if (feedbackCoef != null) 'feedback_coef': feedbackCoef,
      if (dryStreak != null) 'dry_streak': dryStreak,
      if (lastWateredAt != null) 'last_watered_at': lastWateredAt,
      if (nextCheckAt != null) 'next_check_at': nextCheckAt,
      if (fertIntervalDays != null) 'fert_interval_days': fertIntervalDays,
      if (lastFertAt != null) 'last_fert_at': lastFertAt,
      if (repotAt != null) 'repot_at': repotAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PlantsCompanion copyWith({
    Value<int>? id,
    Value<int?>? speciesId,
    Value<String>? nickname,
    Value<String?>? photoPath,
    Value<int?>? spaceId,
    Value<PotSize>? potSize,
    Value<bool>? hasDrainage,
    Value<int>? waterIntervalDays,
    Value<bool>? manualOverride,
    Value<double>? feedbackCoef,
    Value<int>? dryStreak,
    Value<DateTime>? lastWateredAt,
    Value<DateTime>? nextCheckAt,
    Value<int?>? fertIntervalDays,
    Value<DateTime?>? lastFertAt,
    Value<DateTime?>? repotAt,
    Value<DateTime>? createdAt,
  }) {
    return PlantsCompanion(
      id: id ?? this.id,
      speciesId: speciesId ?? this.speciesId,
      nickname: nickname ?? this.nickname,
      photoPath: photoPath ?? this.photoPath,
      spaceId: spaceId ?? this.spaceId,
      potSize: potSize ?? this.potSize,
      hasDrainage: hasDrainage ?? this.hasDrainage,
      waterIntervalDays: waterIntervalDays ?? this.waterIntervalDays,
      manualOverride: manualOverride ?? this.manualOverride,
      feedbackCoef: feedbackCoef ?? this.feedbackCoef,
      dryStreak: dryStreak ?? this.dryStreak,
      lastWateredAt: lastWateredAt ?? this.lastWateredAt,
      nextCheckAt: nextCheckAt ?? this.nextCheckAt,
      fertIntervalDays: fertIntervalDays ?? this.fertIntervalDays,
      lastFertAt: lastFertAt ?? this.lastFertAt,
      repotAt: repotAt ?? this.repotAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (speciesId.present) {
      map['species_id'] = Variable<int>(speciesId.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (spaceId.present) {
      map['space_id'] = Variable<int>(spaceId.value);
    }
    if (potSize.present) {
      map['pot_size'] = Variable<String>(
        $PlantsTable.$converterpotSize.toSql(potSize.value),
      );
    }
    if (hasDrainage.present) {
      map['has_drainage'] = Variable<bool>(hasDrainage.value);
    }
    if (waterIntervalDays.present) {
      map['water_interval_days'] = Variable<int>(waterIntervalDays.value);
    }
    if (manualOverride.present) {
      map['manual_override'] = Variable<bool>(manualOverride.value);
    }
    if (feedbackCoef.present) {
      map['feedback_coef'] = Variable<double>(feedbackCoef.value);
    }
    if (dryStreak.present) {
      map['dry_streak'] = Variable<int>(dryStreak.value);
    }
    if (lastWateredAt.present) {
      map['last_watered_at'] = Variable<DateTime>(lastWateredAt.value);
    }
    if (nextCheckAt.present) {
      map['next_check_at'] = Variable<DateTime>(nextCheckAt.value);
    }
    if (fertIntervalDays.present) {
      map['fert_interval_days'] = Variable<int>(fertIntervalDays.value);
    }
    if (lastFertAt.present) {
      map['last_fert_at'] = Variable<DateTime>(lastFertAt.value);
    }
    if (repotAt.present) {
      map['repot_at'] = Variable<DateTime>(repotAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlantsCompanion(')
          ..write('id: $id, ')
          ..write('speciesId: $speciesId, ')
          ..write('nickname: $nickname, ')
          ..write('photoPath: $photoPath, ')
          ..write('spaceId: $spaceId, ')
          ..write('potSize: $potSize, ')
          ..write('hasDrainage: $hasDrainage, ')
          ..write('waterIntervalDays: $waterIntervalDays, ')
          ..write('manualOverride: $manualOverride, ')
          ..write('feedbackCoef: $feedbackCoef, ')
          ..write('dryStreak: $dryStreak, ')
          ..write('lastWateredAt: $lastWateredAt, ')
          ..write('nextCheckAt: $nextCheckAt, ')
          ..write('fertIntervalDays: $fertIntervalDays, ')
          ..write('lastFertAt: $lastFertAt, ')
          ..write('repotAt: $repotAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CareEventsTable extends CareEvents
    with TableInfo<$CareEventsTable, CareEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CareEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _plantIdMeta = const VerificationMeta(
    'plantId',
  );
  @override
  late final GeneratedColumn<int> plantId = GeneratedColumn<int>(
    'plant_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES plants (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<CareType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CareType>($CareEventsTable.$convertertype);
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, plantId, type, at, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'care_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<CareEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('plant_id')) {
      context.handle(
        _plantIdMeta,
        plantId.isAcceptableOrUnknown(data['plant_id']!, _plantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_plantIdMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CareEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CareEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      plantId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plant_id'],
      )!,
      type: $CareEventsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $CareEventsTable createAlias(String alias) {
    return $CareEventsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CareType, String, String> $convertertype =
      const EnumNameConverter<CareType>(CareType.values);
}

class CareEvent extends DataClass implements Insertable<CareEvent> {
  final int id;
  final int plantId;
  final CareType type;
  final DateTime at;
  final String? note;
  const CareEvent({
    required this.id,
    required this.plantId,
    required this.type,
    required this.at,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plant_id'] = Variable<int>(plantId);
    {
      map['type'] = Variable<String>(
        $CareEventsTable.$convertertype.toSql(type),
      );
    }
    map['at'] = Variable<DateTime>(at);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  CareEventsCompanion toCompanion(bool nullToAbsent) {
    return CareEventsCompanion(
      id: Value(id),
      plantId: Value(plantId),
      type: Value(type),
      at: Value(at),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory CareEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CareEvent(
      id: serializer.fromJson<int>(json['id']),
      plantId: serializer.fromJson<int>(json['plantId']),
      type: $CareEventsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      at: serializer.fromJson<DateTime>(json['at']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'plantId': serializer.toJson<int>(plantId),
      'type': serializer.toJson<String>(
        $CareEventsTable.$convertertype.toJson(type),
      ),
      'at': serializer.toJson<DateTime>(at),
      'note': serializer.toJson<String?>(note),
    };
  }

  CareEvent copyWith({
    int? id,
    int? plantId,
    CareType? type,
    DateTime? at,
    Value<String?> note = const Value.absent(),
  }) => CareEvent(
    id: id ?? this.id,
    plantId: plantId ?? this.plantId,
    type: type ?? this.type,
    at: at ?? this.at,
    note: note.present ? note.value : this.note,
  );
  CareEvent copyWithCompanion(CareEventsCompanion data) {
    return CareEvent(
      id: data.id.present ? data.id.value : this.id,
      plantId: data.plantId.present ? data.plantId.value : this.plantId,
      type: data.type.present ? data.type.value : this.type,
      at: data.at.present ? data.at.value : this.at,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CareEvent(')
          ..write('id: $id, ')
          ..write('plantId: $plantId, ')
          ..write('type: $type, ')
          ..write('at: $at, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, plantId, type, at, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CareEvent &&
          other.id == this.id &&
          other.plantId == this.plantId &&
          other.type == this.type &&
          other.at == this.at &&
          other.note == this.note);
}

class CareEventsCompanion extends UpdateCompanion<CareEvent> {
  final Value<int> id;
  final Value<int> plantId;
  final Value<CareType> type;
  final Value<DateTime> at;
  final Value<String?> note;
  const CareEventsCompanion({
    this.id = const Value.absent(),
    this.plantId = const Value.absent(),
    this.type = const Value.absent(),
    this.at = const Value.absent(),
    this.note = const Value.absent(),
  });
  CareEventsCompanion.insert({
    this.id = const Value.absent(),
    required int plantId,
    required CareType type,
    required DateTime at,
    this.note = const Value.absent(),
  }) : plantId = Value(plantId),
       type = Value(type),
       at = Value(at);
  static Insertable<CareEvent> custom({
    Expression<int>? id,
    Expression<int>? plantId,
    Expression<String>? type,
    Expression<DateTime>? at,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (plantId != null) 'plant_id': plantId,
      if (type != null) 'type': type,
      if (at != null) 'at': at,
      if (note != null) 'note': note,
    });
  }

  CareEventsCompanion copyWith({
    Value<int>? id,
    Value<int>? plantId,
    Value<CareType>? type,
    Value<DateTime>? at,
    Value<String?>? note,
  }) {
    return CareEventsCompanion(
      id: id ?? this.id,
      plantId: plantId ?? this.plantId,
      type: type ?? this.type,
      at: at ?? this.at,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (plantId.present) {
      map['plant_id'] = Variable<int>(plantId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $CareEventsTable.$convertertype.toSql(type.value),
      );
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CareEventsCompanion(')
          ..write('id: $id, ')
          ..write('plantId: $plantId, ')
          ..write('type: $type, ')
          ..write('at: $at, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $DiaryEntriesTable extends DiaryEntries
    with TableInfo<$DiaryEntriesTable, DiaryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiaryEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _plantIdMeta = const VerificationMeta(
    'plantId',
  );
  @override
  late final GeneratedColumn<int> plantId = GeneratedColumn<int>(
    'plant_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES plants (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
    'memo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<DiaryTag>, String> tags =
      GeneratedColumn<String>(
        'tags',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<DiaryTag>>($DiaryEntriesTable.$convertertags);
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    plantId,
    photoPath,
    memo,
    tags,
    at,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diary_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiaryEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('plant_id')) {
      context.handle(
        _plantIdMeta,
        plantId.isAcceptableOrUnknown(data['plant_id']!, _plantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_plantIdMeta);
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('memo')) {
      context.handle(
        _memoMeta,
        memo.isAcceptableOrUnknown(data['memo']!, _memoMeta),
      );
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiaryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiaryEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      plantId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plant_id'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      memo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memo'],
      ),
      tags: $DiaryEntriesTable.$convertertags.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tags'],
        )!,
      ),
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
    );
  }

  @override
  $DiaryEntriesTable createAlias(String alias) {
    return $DiaryEntriesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<DiaryTag>, String> $convertertags =
      const DiaryTagListConverter();
}

class DiaryEntry extends DataClass implements Insertable<DiaryEntry> {
  final int id;
  final int plantId;
  final String? photoPath;
  final String? memo;
  final List<DiaryTag> tags;
  final DateTime at;
  const DiaryEntry({
    required this.id,
    required this.plantId,
    this.photoPath,
    this.memo,
    required this.tags,
    required this.at,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plant_id'] = Variable<int>(plantId);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    {
      map['tags'] = Variable<String>(
        $DiaryEntriesTable.$convertertags.toSql(tags),
      );
    }
    map['at'] = Variable<DateTime>(at);
    return map;
  }

  DiaryEntriesCompanion toCompanion(bool nullToAbsent) {
    return DiaryEntriesCompanion(
      id: Value(id),
      plantId: Value(plantId),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
      tags: Value(tags),
      at: Value(at),
    );
  }

  factory DiaryEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiaryEntry(
      id: serializer.fromJson<int>(json['id']),
      plantId: serializer.fromJson<int>(json['plantId']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      memo: serializer.fromJson<String?>(json['memo']),
      tags: serializer.fromJson<List<DiaryTag>>(json['tags']),
      at: serializer.fromJson<DateTime>(json['at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'plantId': serializer.toJson<int>(plantId),
      'photoPath': serializer.toJson<String?>(photoPath),
      'memo': serializer.toJson<String?>(memo),
      'tags': serializer.toJson<List<DiaryTag>>(tags),
      'at': serializer.toJson<DateTime>(at),
    };
  }

  DiaryEntry copyWith({
    int? id,
    int? plantId,
    Value<String?> photoPath = const Value.absent(),
    Value<String?> memo = const Value.absent(),
    List<DiaryTag>? tags,
    DateTime? at,
  }) => DiaryEntry(
    id: id ?? this.id,
    plantId: plantId ?? this.plantId,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    memo: memo.present ? memo.value : this.memo,
    tags: tags ?? this.tags,
    at: at ?? this.at,
  );
  DiaryEntry copyWithCompanion(DiaryEntriesCompanion data) {
    return DiaryEntry(
      id: data.id.present ? data.id.value : this.id,
      plantId: data.plantId.present ? data.plantId.value : this.plantId,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      memo: data.memo.present ? data.memo.value : this.memo,
      tags: data.tags.present ? data.tags.value : this.tags,
      at: data.at.present ? data.at.value : this.at,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiaryEntry(')
          ..write('id: $id, ')
          ..write('plantId: $plantId, ')
          ..write('photoPath: $photoPath, ')
          ..write('memo: $memo, ')
          ..write('tags: $tags, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, plantId, photoPath, memo, tags, at);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiaryEntry &&
          other.id == this.id &&
          other.plantId == this.plantId &&
          other.photoPath == this.photoPath &&
          other.memo == this.memo &&
          other.tags == this.tags &&
          other.at == this.at);
}

class DiaryEntriesCompanion extends UpdateCompanion<DiaryEntry> {
  final Value<int> id;
  final Value<int> plantId;
  final Value<String?> photoPath;
  final Value<String?> memo;
  final Value<List<DiaryTag>> tags;
  final Value<DateTime> at;
  const DiaryEntriesCompanion({
    this.id = const Value.absent(),
    this.plantId = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.memo = const Value.absent(),
    this.tags = const Value.absent(),
    this.at = const Value.absent(),
  });
  DiaryEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int plantId,
    this.photoPath = const Value.absent(),
    this.memo = const Value.absent(),
    this.tags = const Value.absent(),
    required DateTime at,
  }) : plantId = Value(plantId),
       at = Value(at);
  static Insertable<DiaryEntry> custom({
    Expression<int>? id,
    Expression<int>? plantId,
    Expression<String>? photoPath,
    Expression<String>? memo,
    Expression<String>? tags,
    Expression<DateTime>? at,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (plantId != null) 'plant_id': plantId,
      if (photoPath != null) 'photo_path': photoPath,
      if (memo != null) 'memo': memo,
      if (tags != null) 'tags': tags,
      if (at != null) 'at': at,
    });
  }

  DiaryEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? plantId,
    Value<String?>? photoPath,
    Value<String?>? memo,
    Value<List<DiaryTag>>? tags,
    Value<DateTime>? at,
  }) {
    return DiaryEntriesCompanion(
      id: id ?? this.id,
      plantId: plantId ?? this.plantId,
      photoPath: photoPath ?? this.photoPath,
      memo: memo ?? this.memo,
      tags: tags ?? this.tags,
      at: at ?? this.at,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (plantId.present) {
      map['plant_id'] = Variable<int>(plantId.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(
        $DiaryEntriesTable.$convertertags.toSql(tags.value),
      );
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiaryEntriesCompanion(')
          ..write('id: $id, ')
          ..write('plantId: $plantId, ')
          ..write('photoPath: $photoPath, ')
          ..write('memo: $memo, ')
          ..write('tags: $tags, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }
}

class $IdentificationLogsTable extends IdentificationLogs
    with TableInfo<$IdentificationLogsTable, IdentificationLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IdentificationLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _localPhotoPathMeta = const VerificationMeta(
    'localPhotoPath',
  );
  @override
  late final GeneratedColumn<String> localPhotoPath = GeneratedColumn<String>(
    'local_photo_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _candidatesJsonMeta = const VerificationMeta(
    'candidatesJson',
  );
  @override
  late final GeneratedColumn<String> candidatesJson = GeneratedColumn<String>(
    'candidates_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userSelectedSpeciesIdMeta =
      const VerificationMeta('userSelectedSpeciesId');
  @override
  late final GeneratedColumn<int> userSelectedSpeciesId = GeneratedColumn<int>(
    'user_selected_species_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES species (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    localPhotoPath,
    candidatesJson,
    userSelectedSpeciesId,
    at,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'identification_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<IdentificationLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('local_photo_path')) {
      context.handle(
        _localPhotoPathMeta,
        localPhotoPath.isAcceptableOrUnknown(
          data['local_photo_path']!,
          _localPhotoPathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localPhotoPathMeta);
    }
    if (data.containsKey('candidates_json')) {
      context.handle(
        _candidatesJsonMeta,
        candidatesJson.isAcceptableOrUnknown(
          data['candidates_json']!,
          _candidatesJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_candidatesJsonMeta);
    }
    if (data.containsKey('user_selected_species_id')) {
      context.handle(
        _userSelectedSpeciesIdMeta,
        userSelectedSpeciesId.isAcceptableOrUnknown(
          data['user_selected_species_id']!,
          _userSelectedSpeciesIdMeta,
        ),
      );
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IdentificationLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IdentificationLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      localPhotoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_photo_path'],
      )!,
      candidatesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}candidates_json'],
      )!,
      userSelectedSpeciesId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_selected_species_id'],
      ),
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
    );
  }

  @override
  $IdentificationLogsTable createAlias(String alias) {
    return $IdentificationLogsTable(attachedDatabase, alias);
  }
}

class IdentificationLog extends DataClass
    implements Insertable<IdentificationLog> {
  final int id;
  final String localPhotoPath;
  final String candidatesJson;
  final int? userSelectedSpeciesId;
  final DateTime at;
  const IdentificationLog({
    required this.id,
    required this.localPhotoPath,
    required this.candidatesJson,
    this.userSelectedSpeciesId,
    required this.at,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['local_photo_path'] = Variable<String>(localPhotoPath);
    map['candidates_json'] = Variable<String>(candidatesJson);
    if (!nullToAbsent || userSelectedSpeciesId != null) {
      map['user_selected_species_id'] = Variable<int>(userSelectedSpeciesId);
    }
    map['at'] = Variable<DateTime>(at);
    return map;
  }

  IdentificationLogsCompanion toCompanion(bool nullToAbsent) {
    return IdentificationLogsCompanion(
      id: Value(id),
      localPhotoPath: Value(localPhotoPath),
      candidatesJson: Value(candidatesJson),
      userSelectedSpeciesId: userSelectedSpeciesId == null && nullToAbsent
          ? const Value.absent()
          : Value(userSelectedSpeciesId),
      at: Value(at),
    );
  }

  factory IdentificationLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IdentificationLog(
      id: serializer.fromJson<int>(json['id']),
      localPhotoPath: serializer.fromJson<String>(json['localPhotoPath']),
      candidatesJson: serializer.fromJson<String>(json['candidatesJson']),
      userSelectedSpeciesId: serializer.fromJson<int?>(
        json['userSelectedSpeciesId'],
      ),
      at: serializer.fromJson<DateTime>(json['at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'localPhotoPath': serializer.toJson<String>(localPhotoPath),
      'candidatesJson': serializer.toJson<String>(candidatesJson),
      'userSelectedSpeciesId': serializer.toJson<int?>(userSelectedSpeciesId),
      'at': serializer.toJson<DateTime>(at),
    };
  }

  IdentificationLog copyWith({
    int? id,
    String? localPhotoPath,
    String? candidatesJson,
    Value<int?> userSelectedSpeciesId = const Value.absent(),
    DateTime? at,
  }) => IdentificationLog(
    id: id ?? this.id,
    localPhotoPath: localPhotoPath ?? this.localPhotoPath,
    candidatesJson: candidatesJson ?? this.candidatesJson,
    userSelectedSpeciesId: userSelectedSpeciesId.present
        ? userSelectedSpeciesId.value
        : this.userSelectedSpeciesId,
    at: at ?? this.at,
  );
  IdentificationLog copyWithCompanion(IdentificationLogsCompanion data) {
    return IdentificationLog(
      id: data.id.present ? data.id.value : this.id,
      localPhotoPath: data.localPhotoPath.present
          ? data.localPhotoPath.value
          : this.localPhotoPath,
      candidatesJson: data.candidatesJson.present
          ? data.candidatesJson.value
          : this.candidatesJson,
      userSelectedSpeciesId: data.userSelectedSpeciesId.present
          ? data.userSelectedSpeciesId.value
          : this.userSelectedSpeciesId,
      at: data.at.present ? data.at.value : this.at,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IdentificationLog(')
          ..write('id: $id, ')
          ..write('localPhotoPath: $localPhotoPath, ')
          ..write('candidatesJson: $candidatesJson, ')
          ..write('userSelectedSpeciesId: $userSelectedSpeciesId, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    localPhotoPath,
    candidatesJson,
    userSelectedSpeciesId,
    at,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IdentificationLog &&
          other.id == this.id &&
          other.localPhotoPath == this.localPhotoPath &&
          other.candidatesJson == this.candidatesJson &&
          other.userSelectedSpeciesId == this.userSelectedSpeciesId &&
          other.at == this.at);
}

class IdentificationLogsCompanion extends UpdateCompanion<IdentificationLog> {
  final Value<int> id;
  final Value<String> localPhotoPath;
  final Value<String> candidatesJson;
  final Value<int?> userSelectedSpeciesId;
  final Value<DateTime> at;
  const IdentificationLogsCompanion({
    this.id = const Value.absent(),
    this.localPhotoPath = const Value.absent(),
    this.candidatesJson = const Value.absent(),
    this.userSelectedSpeciesId = const Value.absent(),
    this.at = const Value.absent(),
  });
  IdentificationLogsCompanion.insert({
    this.id = const Value.absent(),
    required String localPhotoPath,
    required String candidatesJson,
    this.userSelectedSpeciesId = const Value.absent(),
    required DateTime at,
  }) : localPhotoPath = Value(localPhotoPath),
       candidatesJson = Value(candidatesJson),
       at = Value(at);
  static Insertable<IdentificationLog> custom({
    Expression<int>? id,
    Expression<String>? localPhotoPath,
    Expression<String>? candidatesJson,
    Expression<int>? userSelectedSpeciesId,
    Expression<DateTime>? at,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (localPhotoPath != null) 'local_photo_path': localPhotoPath,
      if (candidatesJson != null) 'candidates_json': candidatesJson,
      if (userSelectedSpeciesId != null)
        'user_selected_species_id': userSelectedSpeciesId,
      if (at != null) 'at': at,
    });
  }

  IdentificationLogsCompanion copyWith({
    Value<int>? id,
    Value<String>? localPhotoPath,
    Value<String>? candidatesJson,
    Value<int?>? userSelectedSpeciesId,
    Value<DateTime>? at,
  }) {
    return IdentificationLogsCompanion(
      id: id ?? this.id,
      localPhotoPath: localPhotoPath ?? this.localPhotoPath,
      candidatesJson: candidatesJson ?? this.candidatesJson,
      userSelectedSpeciesId:
          userSelectedSpeciesId ?? this.userSelectedSpeciesId,
      at: at ?? this.at,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (localPhotoPath.present) {
      map['local_photo_path'] = Variable<String>(localPhotoPath.value);
    }
    if (candidatesJson.present) {
      map['candidates_json'] = Variable<String>(candidatesJson.value);
    }
    if (userSelectedSpeciesId.present) {
      map['user_selected_species_id'] = Variable<int>(
        userSelectedSpeciesId.value,
      );
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IdentificationLogsCompanion(')
          ..write('id: $id, ')
          ..write('localPhotoPath: $localPhotoPath, ')
          ..write('candidatesJson: $candidatesJson, ')
          ..write('userSelectedSpeciesId: $userSelectedSpeciesId, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notifyHourMeta = const VerificationMeta(
    'notifyHour',
  );
  @override
  late final GeneratedColumn<int> notifyHour = GeneratedColumn<int>(
    'notify_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(9),
  );
  static const VerificationMeta _notifyMinuteMeta = const VerificationMeta(
    'notifyMinute',
  );
  @override
  late final GeneratedColumn<int> notifyMinute = GeneratedColumn<int>(
    'notify_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<int>, String> skipWeekdays =
      GeneratedColumn<String>(
        'skip_weekdays',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<int>>($SettingsTable.$converterskipWeekdays);
  static const VerificationMeta _backupUserIdMeta = const VerificationMeta(
    'backupUserId',
  );
  @override
  late final GeneratedColumn<String> backupUserId = GeneratedColumn<String>(
    'backup_user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _onboardingDoneMeta = const VerificationMeta(
    'onboardingDone',
  );
  @override
  late final GeneratedColumn<bool> onboardingDone = GeneratedColumn<bool>(
    'onboarding_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    notifyHour,
    notifyMinute,
    skipWeekdays,
    backupUserId,
    onboardingDone,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('notify_hour')) {
      context.handle(
        _notifyHourMeta,
        notifyHour.isAcceptableOrUnknown(data['notify_hour']!, _notifyHourMeta),
      );
    }
    if (data.containsKey('notify_minute')) {
      context.handle(
        _notifyMinuteMeta,
        notifyMinute.isAcceptableOrUnknown(
          data['notify_minute']!,
          _notifyMinuteMeta,
        ),
      );
    }
    if (data.containsKey('backup_user_id')) {
      context.handle(
        _backupUserIdMeta,
        backupUserId.isAcceptableOrUnknown(
          data['backup_user_id']!,
          _backupUserIdMeta,
        ),
      );
    }
    if (data.containsKey('onboarding_done')) {
      context.handle(
        _onboardingDoneMeta,
        onboardingDone.isAcceptableOrUnknown(
          data['onboarding_done']!,
          _onboardingDoneMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      notifyHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}notify_hour'],
      )!,
      notifyMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}notify_minute'],
      )!,
      skipWeekdays: $SettingsTable.$converterskipWeekdays.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}skip_weekdays'],
        )!,
      ),
      backupUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}backup_user_id'],
      ),
      onboardingDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_done'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<int>, String> $converterskipWeekdays =
      const IntListConverter();
}

class Setting extends DataClass implements Insertable<Setting> {
  final int id;
  final int notifyHour;
  final int notifyMinute;
  final List<int> skipWeekdays;
  final String? backupUserId;
  final bool onboardingDone;
  const Setting({
    required this.id,
    required this.notifyHour,
    required this.notifyMinute,
    required this.skipWeekdays,
    this.backupUserId,
    required this.onboardingDone,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['notify_hour'] = Variable<int>(notifyHour);
    map['notify_minute'] = Variable<int>(notifyMinute);
    {
      map['skip_weekdays'] = Variable<String>(
        $SettingsTable.$converterskipWeekdays.toSql(skipWeekdays),
      );
    }
    if (!nullToAbsent || backupUserId != null) {
      map['backup_user_id'] = Variable<String>(backupUserId);
    }
    map['onboarding_done'] = Variable<bool>(onboardingDone);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      notifyHour: Value(notifyHour),
      notifyMinute: Value(notifyMinute),
      skipWeekdays: Value(skipWeekdays),
      backupUserId: backupUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(backupUserId),
      onboardingDone: Value(onboardingDone),
    );
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      id: serializer.fromJson<int>(json['id']),
      notifyHour: serializer.fromJson<int>(json['notifyHour']),
      notifyMinute: serializer.fromJson<int>(json['notifyMinute']),
      skipWeekdays: serializer.fromJson<List<int>>(json['skipWeekdays']),
      backupUserId: serializer.fromJson<String?>(json['backupUserId']),
      onboardingDone: serializer.fromJson<bool>(json['onboardingDone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'notifyHour': serializer.toJson<int>(notifyHour),
      'notifyMinute': serializer.toJson<int>(notifyMinute),
      'skipWeekdays': serializer.toJson<List<int>>(skipWeekdays),
      'backupUserId': serializer.toJson<String?>(backupUserId),
      'onboardingDone': serializer.toJson<bool>(onboardingDone),
    };
  }

  Setting copyWith({
    int? id,
    int? notifyHour,
    int? notifyMinute,
    List<int>? skipWeekdays,
    Value<String?> backupUserId = const Value.absent(),
    bool? onboardingDone,
  }) => Setting(
    id: id ?? this.id,
    notifyHour: notifyHour ?? this.notifyHour,
    notifyMinute: notifyMinute ?? this.notifyMinute,
    skipWeekdays: skipWeekdays ?? this.skipWeekdays,
    backupUserId: backupUserId.present ? backupUserId.value : this.backupUserId,
    onboardingDone: onboardingDone ?? this.onboardingDone,
  );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      id: data.id.present ? data.id.value : this.id,
      notifyHour: data.notifyHour.present
          ? data.notifyHour.value
          : this.notifyHour,
      notifyMinute: data.notifyMinute.present
          ? data.notifyMinute.value
          : this.notifyMinute,
      skipWeekdays: data.skipWeekdays.present
          ? data.skipWeekdays.value
          : this.skipWeekdays,
      backupUserId: data.backupUserId.present
          ? data.backupUserId.value
          : this.backupUserId,
      onboardingDone: data.onboardingDone.present
          ? data.onboardingDone.value
          : this.onboardingDone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('id: $id, ')
          ..write('notifyHour: $notifyHour, ')
          ..write('notifyMinute: $notifyMinute, ')
          ..write('skipWeekdays: $skipWeekdays, ')
          ..write('backupUserId: $backupUserId, ')
          ..write('onboardingDone: $onboardingDone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    notifyHour,
    notifyMinute,
    skipWeekdays,
    backupUserId,
    onboardingDone,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.id == this.id &&
          other.notifyHour == this.notifyHour &&
          other.notifyMinute == this.notifyMinute &&
          other.skipWeekdays == this.skipWeekdays &&
          other.backupUserId == this.backupUserId &&
          other.onboardingDone == this.onboardingDone);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<int> id;
  final Value<int> notifyHour;
  final Value<int> notifyMinute;
  final Value<List<int>> skipWeekdays;
  final Value<String?> backupUserId;
  final Value<bool> onboardingDone;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.notifyHour = const Value.absent(),
    this.notifyMinute = const Value.absent(),
    this.skipWeekdays = const Value.absent(),
    this.backupUserId = const Value.absent(),
    this.onboardingDone = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    this.notifyHour = const Value.absent(),
    this.notifyMinute = const Value.absent(),
    this.skipWeekdays = const Value.absent(),
    this.backupUserId = const Value.absent(),
    this.onboardingDone = const Value.absent(),
  });
  static Insertable<Setting> custom({
    Expression<int>? id,
    Expression<int>? notifyHour,
    Expression<int>? notifyMinute,
    Expression<String>? skipWeekdays,
    Expression<String>? backupUserId,
    Expression<bool>? onboardingDone,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (notifyHour != null) 'notify_hour': notifyHour,
      if (notifyMinute != null) 'notify_minute': notifyMinute,
      if (skipWeekdays != null) 'skip_weekdays': skipWeekdays,
      if (backupUserId != null) 'backup_user_id': backupUserId,
      if (onboardingDone != null) 'onboarding_done': onboardingDone,
    });
  }

  SettingsCompanion copyWith({
    Value<int>? id,
    Value<int>? notifyHour,
    Value<int>? notifyMinute,
    Value<List<int>>? skipWeekdays,
    Value<String?>? backupUserId,
    Value<bool>? onboardingDone,
  }) {
    return SettingsCompanion(
      id: id ?? this.id,
      notifyHour: notifyHour ?? this.notifyHour,
      notifyMinute: notifyMinute ?? this.notifyMinute,
      skipWeekdays: skipWeekdays ?? this.skipWeekdays,
      backupUserId: backupUserId ?? this.backupUserId,
      onboardingDone: onboardingDone ?? this.onboardingDone,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (notifyHour.present) {
      map['notify_hour'] = Variable<int>(notifyHour.value);
    }
    if (notifyMinute.present) {
      map['notify_minute'] = Variable<int>(notifyMinute.value);
    }
    if (skipWeekdays.present) {
      map['skip_weekdays'] = Variable<String>(
        $SettingsTable.$converterskipWeekdays.toSql(skipWeekdays.value),
      );
    }
    if (backupUserId.present) {
      map['backup_user_id'] = Variable<String>(backupUserId.value);
    }
    if (onboardingDone.present) {
      map['onboarding_done'] = Variable<bool>(onboardingDone.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('notifyHour: $notifyHour, ')
          ..write('notifyMinute: $notifyMinute, ')
          ..write('skipWeekdays: $skipWeekdays, ')
          ..write('backupUserId: $backupUserId, ')
          ..write('onboardingDone: $onboardingDone')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SpeciesTable species = $SpeciesTable(this);
  late final $SpacesTable spaces = $SpacesTable(this);
  late final $PlantsTable plants = $PlantsTable(this);
  late final $CareEventsTable careEvents = $CareEventsTable(this);
  late final $DiaryEntriesTable diaryEntries = $DiaryEntriesTable(this);
  late final $IdentificationLogsTable identificationLogs =
      $IdentificationLogsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    species,
    spaces,
    plants,
    careEvents,
    diaryEntries,
    identificationLogs,
    settings,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'species',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('plants', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'spaces',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('plants', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'plants',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('care_events', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'plants',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('diary_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'species',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('identification_logs', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$SpeciesTableCreateCompanionBuilder =
    SpeciesCompanion Function({
      Value<int> id,
      required String scientificName,
      required List<String> koNames,
      Value<String?> family,
      required int baseWaterDays,
      required LightPref lightPref,
      required bool toxicPet,
      required bool toxicChild,
      Value<int?> tempMin,
      Value<int?> tempMax,
      Value<int?> fertDays,
      Value<int?> repotMonths,
      Value<List<String>> commonIssues,
      Value<String> category,
      Value<String> searchText,
    });
typedef $$SpeciesTableUpdateCompanionBuilder =
    SpeciesCompanion Function({
      Value<int> id,
      Value<String> scientificName,
      Value<List<String>> koNames,
      Value<String?> family,
      Value<int> baseWaterDays,
      Value<LightPref> lightPref,
      Value<bool> toxicPet,
      Value<bool> toxicChild,
      Value<int?> tempMin,
      Value<int?> tempMax,
      Value<int?> fertDays,
      Value<int?> repotMonths,
      Value<List<String>> commonIssues,
      Value<String> category,
      Value<String> searchText,
    });

final class $$SpeciesTableReferences
    extends BaseReferences<_$AppDatabase, $SpeciesTable, SpeciesRow> {
  $$SpeciesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlantsTable, List<Plant>> _plantsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.plants,
    aliasName: 'species__id__plants__species_id',
  );

  $$PlantsTableProcessedTableManager get plantsRefs {
    final manager = $$PlantsTableTableManager(
      $_db,
      $_db.plants,
    ).filter((f) => f.speciesId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_plantsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$IdentificationLogsTable, List<IdentificationLog>>
  _identificationLogsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.identificationLogs,
        aliasName: 'species__id__identification_logs__user_selected_species_id',
      );

  $$IdentificationLogsTableProcessedTableManager get identificationLogsRefs {
    final manager =
        $$IdentificationLogsTableTableManager(
          $_db,
          $_db.identificationLogs,
        ).filter(
          (f) => f.userSelectedSpeciesId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _identificationLogsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SpeciesTableFilterComposer
    extends Composer<_$AppDatabase, $SpeciesTable> {
  $$SpeciesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scientificName => $composableBuilder(
    column: $table.scientificName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get koNames => $composableBuilder(
    column: $table.koNames,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get family => $composableBuilder(
    column: $table.family,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baseWaterDays => $composableBuilder(
    column: $table.baseWaterDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LightPref, LightPref, String> get lightPref =>
      $composableBuilder(
        column: $table.lightPref,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get toxicPet => $composableBuilder(
    column: $table.toxicPet,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get toxicChild => $composableBuilder(
    column: $table.toxicChild,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tempMin => $composableBuilder(
    column: $table.tempMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tempMax => $composableBuilder(
    column: $table.tempMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fertDays => $composableBuilder(
    column: $table.fertDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repotMonths => $composableBuilder(
    column: $table.repotMonths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get commonIssues => $composableBuilder(
    column: $table.commonIssues,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get searchText => $composableBuilder(
    column: $table.searchText,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> plantsRefs(
    Expression<bool> Function($$PlantsTableFilterComposer f) f,
  ) {
    final $$PlantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.plants,
      getReferencedColumn: (t) => t.speciesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlantsTableFilterComposer(
            $db: $db,
            $table: $db.plants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> identificationLogsRefs(
    Expression<bool> Function($$IdentificationLogsTableFilterComposer f) f,
  ) {
    final $$IdentificationLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.identificationLogs,
      getReferencedColumn: (t) => t.userSelectedSpeciesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdentificationLogsTableFilterComposer(
            $db: $db,
            $table: $db.identificationLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SpeciesTableOrderingComposer
    extends Composer<_$AppDatabase, $SpeciesTable> {
  $$SpeciesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scientificName => $composableBuilder(
    column: $table.scientificName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get koNames => $composableBuilder(
    column: $table.koNames,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get family => $composableBuilder(
    column: $table.family,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baseWaterDays => $composableBuilder(
    column: $table.baseWaterDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lightPref => $composableBuilder(
    column: $table.lightPref,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get toxicPet => $composableBuilder(
    column: $table.toxicPet,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get toxicChild => $composableBuilder(
    column: $table.toxicChild,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tempMin => $composableBuilder(
    column: $table.tempMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tempMax => $composableBuilder(
    column: $table.tempMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fertDays => $composableBuilder(
    column: $table.fertDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repotMonths => $composableBuilder(
    column: $table.repotMonths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get commonIssues => $composableBuilder(
    column: $table.commonIssues,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get searchText => $composableBuilder(
    column: $table.searchText,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SpeciesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SpeciesTable> {
  $$SpeciesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get scientificName => $composableBuilder(
    column: $table.scientificName,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String> get koNames =>
      $composableBuilder(column: $table.koNames, builder: (column) => column);

  GeneratedColumn<String> get family =>
      $composableBuilder(column: $table.family, builder: (column) => column);

  GeneratedColumn<int> get baseWaterDays => $composableBuilder(
    column: $table.baseWaterDays,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<LightPref, String> get lightPref =>
      $composableBuilder(column: $table.lightPref, builder: (column) => column);

  GeneratedColumn<bool> get toxicPet =>
      $composableBuilder(column: $table.toxicPet, builder: (column) => column);

  GeneratedColumn<bool> get toxicChild => $composableBuilder(
    column: $table.toxicChild,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tempMin =>
      $composableBuilder(column: $table.tempMin, builder: (column) => column);

  GeneratedColumn<int> get tempMax =>
      $composableBuilder(column: $table.tempMax, builder: (column) => column);

  GeneratedColumn<int> get fertDays =>
      $composableBuilder(column: $table.fertDays, builder: (column) => column);

  GeneratedColumn<int> get repotMonths => $composableBuilder(
    column: $table.repotMonths,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String> get commonIssues =>
      $composableBuilder(
        column: $table.commonIssues,
        builder: (column) => column,
      );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get searchText => $composableBuilder(
    column: $table.searchText,
    builder: (column) => column,
  );

  Expression<T> plantsRefs<T extends Object>(
    Expression<T> Function($$PlantsTableAnnotationComposer a) f,
  ) {
    final $$PlantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.plants,
      getReferencedColumn: (t) => t.speciesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlantsTableAnnotationComposer(
            $db: $db,
            $table: $db.plants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> identificationLogsRefs<T extends Object>(
    Expression<T> Function($$IdentificationLogsTableAnnotationComposer a) f,
  ) {
    final $$IdentificationLogsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.identificationLogs,
          getReferencedColumn: (t) => t.userSelectedSpeciesId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IdentificationLogsTableAnnotationComposer(
                $db: $db,
                $table: $db.identificationLogs,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$SpeciesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SpeciesTable,
          SpeciesRow,
          $$SpeciesTableFilterComposer,
          $$SpeciesTableOrderingComposer,
          $$SpeciesTableAnnotationComposer,
          $$SpeciesTableCreateCompanionBuilder,
          $$SpeciesTableUpdateCompanionBuilder,
          (SpeciesRow, $$SpeciesTableReferences),
          SpeciesRow,
          PrefetchHooks Function({bool plantsRefs, bool identificationLogsRefs})
        > {
  $$SpeciesTableTableManager(_$AppDatabase db, $SpeciesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpeciesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpeciesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SpeciesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> scientificName = const Value.absent(),
                Value<List<String>> koNames = const Value.absent(),
                Value<String?> family = const Value.absent(),
                Value<int> baseWaterDays = const Value.absent(),
                Value<LightPref> lightPref = const Value.absent(),
                Value<bool> toxicPet = const Value.absent(),
                Value<bool> toxicChild = const Value.absent(),
                Value<int?> tempMin = const Value.absent(),
                Value<int?> tempMax = const Value.absent(),
                Value<int?> fertDays = const Value.absent(),
                Value<int?> repotMonths = const Value.absent(),
                Value<List<String>> commonIssues = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> searchText = const Value.absent(),
              }) => SpeciesCompanion(
                id: id,
                scientificName: scientificName,
                koNames: koNames,
                family: family,
                baseWaterDays: baseWaterDays,
                lightPref: lightPref,
                toxicPet: toxicPet,
                toxicChild: toxicChild,
                tempMin: tempMin,
                tempMax: tempMax,
                fertDays: fertDays,
                repotMonths: repotMonths,
                commonIssues: commonIssues,
                category: category,
                searchText: searchText,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String scientificName,
                required List<String> koNames,
                Value<String?> family = const Value.absent(),
                required int baseWaterDays,
                required LightPref lightPref,
                required bool toxicPet,
                required bool toxicChild,
                Value<int?> tempMin = const Value.absent(),
                Value<int?> tempMax = const Value.absent(),
                Value<int?> fertDays = const Value.absent(),
                Value<int?> repotMonths = const Value.absent(),
                Value<List<String>> commonIssues = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> searchText = const Value.absent(),
              }) => SpeciesCompanion.insert(
                id: id,
                scientificName: scientificName,
                koNames: koNames,
                family: family,
                baseWaterDays: baseWaterDays,
                lightPref: lightPref,
                toxicPet: toxicPet,
                toxicChild: toxicChild,
                tempMin: tempMin,
                tempMax: tempMax,
                fertDays: fertDays,
                repotMonths: repotMonths,
                commonIssues: commonIssues,
                category: category,
                searchText: searchText,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SpeciesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({plantsRefs = false, identificationLogsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (plantsRefs) db.plants,
                    if (identificationLogsRefs) db.identificationLogs,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (plantsRefs)
                        await $_getPrefetchedData<
                          SpeciesRow,
                          $SpeciesTable,
                          Plant
                        >(
                          currentTable: table,
                          referencedTable: $$SpeciesTableReferences
                              ._plantsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SpeciesTableReferences(
                                db,
                                table,
                                p0,
                              ).plantsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.speciesId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (identificationLogsRefs)
                        await $_getPrefetchedData<
                          SpeciesRow,
                          $SpeciesTable,
                          IdentificationLog
                        >(
                          currentTable: table,
                          referencedTable: $$SpeciesTableReferences
                              ._identificationLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SpeciesTableReferences(
                                db,
                                table,
                                p0,
                              ).identificationLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userSelectedSpeciesId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SpeciesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SpeciesTable,
      SpeciesRow,
      $$SpeciesTableFilterComposer,
      $$SpeciesTableOrderingComposer,
      $$SpeciesTableAnnotationComposer,
      $$SpeciesTableCreateCompanionBuilder,
      $$SpeciesTableUpdateCompanionBuilder,
      (SpeciesRow, $$SpeciesTableReferences),
      SpeciesRow,
      PrefetchHooks Function({bool plantsRefs, bool identificationLogsRefs})
    >;
typedef $$SpacesTableCreateCompanionBuilder =
    SpacesCompanion Function({
      Value<int> id,
      required String name,
      required WindowDir windowDir,
      required WindowDist windowDist,
      Value<int> sortOrder,
    });
typedef $$SpacesTableUpdateCompanionBuilder =
    SpacesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<WindowDir> windowDir,
      Value<WindowDist> windowDist,
      Value<int> sortOrder,
    });

final class $$SpacesTableReferences
    extends BaseReferences<_$AppDatabase, $SpacesTable, Space> {
  $$SpacesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlantsTable, List<Plant>> _plantsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.plants,
    aliasName: 'spaces__id__plants__space_id',
  );

  $$PlantsTableProcessedTableManager get plantsRefs {
    final manager = $$PlantsTableTableManager(
      $_db,
      $_db.plants,
    ).filter((f) => f.spaceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_plantsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SpacesTableFilterComposer
    extends Composer<_$AppDatabase, $SpacesTable> {
  $$SpacesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<WindowDir, WindowDir, String> get windowDir =>
      $composableBuilder(
        column: $table.windowDir,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<WindowDist, WindowDist, String>
  get windowDist => $composableBuilder(
    column: $table.windowDist,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> plantsRefs(
    Expression<bool> Function($$PlantsTableFilterComposer f) f,
  ) {
    final $$PlantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.plants,
      getReferencedColumn: (t) => t.spaceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlantsTableFilterComposer(
            $db: $db,
            $table: $db.plants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SpacesTableOrderingComposer
    extends Composer<_$AppDatabase, $SpacesTable> {
  $$SpacesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get windowDir => $composableBuilder(
    column: $table.windowDir,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get windowDist => $composableBuilder(
    column: $table.windowDist,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SpacesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SpacesTable> {
  $$SpacesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WindowDir, String> get windowDir =>
      $composableBuilder(column: $table.windowDir, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WindowDist, String> get windowDist =>
      $composableBuilder(
        column: $table.windowDist,
        builder: (column) => column,
      );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> plantsRefs<T extends Object>(
    Expression<T> Function($$PlantsTableAnnotationComposer a) f,
  ) {
    final $$PlantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.plants,
      getReferencedColumn: (t) => t.spaceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlantsTableAnnotationComposer(
            $db: $db,
            $table: $db.plants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SpacesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SpacesTable,
          Space,
          $$SpacesTableFilterComposer,
          $$SpacesTableOrderingComposer,
          $$SpacesTableAnnotationComposer,
          $$SpacesTableCreateCompanionBuilder,
          $$SpacesTableUpdateCompanionBuilder,
          (Space, $$SpacesTableReferences),
          Space,
          PrefetchHooks Function({bool plantsRefs})
        > {
  $$SpacesTableTableManager(_$AppDatabase db, $SpacesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpacesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpacesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SpacesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<WindowDir> windowDir = const Value.absent(),
                Value<WindowDist> windowDist = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => SpacesCompanion(
                id: id,
                name: name,
                windowDir: windowDir,
                windowDist: windowDist,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required WindowDir windowDir,
                required WindowDist windowDist,
                Value<int> sortOrder = const Value.absent(),
              }) => SpacesCompanion.insert(
                id: id,
                name: name,
                windowDir: windowDir,
                windowDist: windowDist,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$SpacesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({plantsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (plantsRefs) db.plants],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (plantsRefs)
                    await $_getPrefetchedData<Space, $SpacesTable, Plant>(
                      currentTable: table,
                      referencedTable: $$SpacesTableReferences._plantsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$SpacesTableReferences(db, table, p0).plantsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.spaceId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SpacesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SpacesTable,
      Space,
      $$SpacesTableFilterComposer,
      $$SpacesTableOrderingComposer,
      $$SpacesTableAnnotationComposer,
      $$SpacesTableCreateCompanionBuilder,
      $$SpacesTableUpdateCompanionBuilder,
      (Space, $$SpacesTableReferences),
      Space,
      PrefetchHooks Function({bool plantsRefs})
    >;
typedef $$PlantsTableCreateCompanionBuilder =
    PlantsCompanion Function({
      Value<int> id,
      Value<int?> speciesId,
      required String nickname,
      Value<String?> photoPath,
      Value<int?> spaceId,
      required PotSize potSize,
      Value<bool> hasDrainage,
      required int waterIntervalDays,
      Value<bool> manualOverride,
      Value<double> feedbackCoef,
      Value<int> dryStreak,
      required DateTime lastWateredAt,
      required DateTime nextCheckAt,
      Value<int?> fertIntervalDays,
      Value<DateTime?> lastFertAt,
      Value<DateTime?> repotAt,
      required DateTime createdAt,
    });
typedef $$PlantsTableUpdateCompanionBuilder =
    PlantsCompanion Function({
      Value<int> id,
      Value<int?> speciesId,
      Value<String> nickname,
      Value<String?> photoPath,
      Value<int?> spaceId,
      Value<PotSize> potSize,
      Value<bool> hasDrainage,
      Value<int> waterIntervalDays,
      Value<bool> manualOverride,
      Value<double> feedbackCoef,
      Value<int> dryStreak,
      Value<DateTime> lastWateredAt,
      Value<DateTime> nextCheckAt,
      Value<int?> fertIntervalDays,
      Value<DateTime?> lastFertAt,
      Value<DateTime?> repotAt,
      Value<DateTime> createdAt,
    });

final class $$PlantsTableReferences
    extends BaseReferences<_$AppDatabase, $PlantsTable, Plant> {
  $$PlantsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SpeciesTable _speciesIdTable(_$AppDatabase db) =>
      db.species.createAlias('plants__species_id__species__id');

  $$SpeciesTableProcessedTableManager? get speciesId {
    final $_column = $_itemColumn<int>('species_id');
    if ($_column == null) return null;
    final manager = $$SpeciesTableTableManager(
      $_db,
      $_db.species,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_speciesIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SpacesTable _spaceIdTable(_$AppDatabase db) =>
      db.spaces.createAlias('plants__space_id__spaces__id');

  $$SpacesTableProcessedTableManager? get spaceId {
    final $_column = $_itemColumn<int>('space_id');
    if ($_column == null) return null;
    final manager = $$SpacesTableTableManager(
      $_db,
      $_db.spaces,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_spaceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CareEventsTable, List<CareEvent>>
  _careEventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.careEvents,
    aliasName: 'plants__id__care_events__plant_id',
  );

  $$CareEventsTableProcessedTableManager get careEventsRefs {
    final manager = $$CareEventsTableTableManager(
      $_db,
      $_db.careEvents,
    ).filter((f) => f.plantId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_careEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DiaryEntriesTable, List<DiaryEntry>>
  _diaryEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.diaryEntries,
    aliasName: 'plants__id__diary_entries__plant_id',
  );

  $$DiaryEntriesTableProcessedTableManager get diaryEntriesRefs {
    final manager = $$DiaryEntriesTableTableManager(
      $_db,
      $_db.diaryEntries,
    ).filter((f) => f.plantId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_diaryEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlantsTableFilterComposer
    extends Composer<_$AppDatabase, $PlantsTable> {
  $$PlantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PotSize, PotSize, String> get potSize =>
      $composableBuilder(
        column: $table.potSize,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get hasDrainage => $composableBuilder(
    column: $table.hasDrainage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get waterIntervalDays => $composableBuilder(
    column: $table.waterIntervalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get manualOverride => $composableBuilder(
    column: $table.manualOverride,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get feedbackCoef => $composableBuilder(
    column: $table.feedbackCoef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dryStreak => $composableBuilder(
    column: $table.dryStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastWateredAt => $composableBuilder(
    column: $table.lastWateredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextCheckAt => $composableBuilder(
    column: $table.nextCheckAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fertIntervalDays => $composableBuilder(
    column: $table.fertIntervalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastFertAt => $composableBuilder(
    column: $table.lastFertAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get repotAt => $composableBuilder(
    column: $table.repotAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SpeciesTableFilterComposer get speciesId {
    final $$SpeciesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.speciesId,
      referencedTable: $db.species,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpeciesTableFilterComposer(
            $db: $db,
            $table: $db.species,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SpacesTableFilterComposer get spaceId {
    final $$SpacesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.spaceId,
      referencedTable: $db.spaces,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpacesTableFilterComposer(
            $db: $db,
            $table: $db.spaces,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> careEventsRefs(
    Expression<bool> Function($$CareEventsTableFilterComposer f) f,
  ) {
    final $$CareEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.careEvents,
      getReferencedColumn: (t) => t.plantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareEventsTableFilterComposer(
            $db: $db,
            $table: $db.careEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> diaryEntriesRefs(
    Expression<bool> Function($$DiaryEntriesTableFilterComposer f) f,
  ) {
    final $$DiaryEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.diaryEntries,
      getReferencedColumn: (t) => t.plantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiaryEntriesTableFilterComposer(
            $db: $db,
            $table: $db.diaryEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlantsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlantsTable> {
  $$PlantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get potSize => $composableBuilder(
    column: $table.potSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasDrainage => $composableBuilder(
    column: $table.hasDrainage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get waterIntervalDays => $composableBuilder(
    column: $table.waterIntervalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get manualOverride => $composableBuilder(
    column: $table.manualOverride,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get feedbackCoef => $composableBuilder(
    column: $table.feedbackCoef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dryStreak => $composableBuilder(
    column: $table.dryStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastWateredAt => $composableBuilder(
    column: $table.lastWateredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextCheckAt => $composableBuilder(
    column: $table.nextCheckAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fertIntervalDays => $composableBuilder(
    column: $table.fertIntervalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastFertAt => $composableBuilder(
    column: $table.lastFertAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get repotAt => $composableBuilder(
    column: $table.repotAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SpeciesTableOrderingComposer get speciesId {
    final $$SpeciesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.speciesId,
      referencedTable: $db.species,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpeciesTableOrderingComposer(
            $db: $db,
            $table: $db.species,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SpacesTableOrderingComposer get spaceId {
    final $$SpacesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.spaceId,
      referencedTable: $db.spaces,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpacesTableOrderingComposer(
            $db: $db,
            $table: $db.spaces,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlantsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlantsTable> {
  $$PlantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PotSize, String> get potSize =>
      $composableBuilder(column: $table.potSize, builder: (column) => column);

  GeneratedColumn<bool> get hasDrainage => $composableBuilder(
    column: $table.hasDrainage,
    builder: (column) => column,
  );

  GeneratedColumn<int> get waterIntervalDays => $composableBuilder(
    column: $table.waterIntervalDays,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get manualOverride => $composableBuilder(
    column: $table.manualOverride,
    builder: (column) => column,
  );

  GeneratedColumn<double> get feedbackCoef => $composableBuilder(
    column: $table.feedbackCoef,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dryStreak =>
      $composableBuilder(column: $table.dryStreak, builder: (column) => column);

  GeneratedColumn<DateTime> get lastWateredAt => $composableBuilder(
    column: $table.lastWateredAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextCheckAt => $composableBuilder(
    column: $table.nextCheckAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fertIntervalDays => $composableBuilder(
    column: $table.fertIntervalDays,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastFertAt => $composableBuilder(
    column: $table.lastFertAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get repotAt =>
      $composableBuilder(column: $table.repotAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$SpeciesTableAnnotationComposer get speciesId {
    final $$SpeciesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.speciesId,
      referencedTable: $db.species,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpeciesTableAnnotationComposer(
            $db: $db,
            $table: $db.species,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SpacesTableAnnotationComposer get spaceId {
    final $$SpacesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.spaceId,
      referencedTable: $db.spaces,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpacesTableAnnotationComposer(
            $db: $db,
            $table: $db.spaces,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> careEventsRefs<T extends Object>(
    Expression<T> Function($$CareEventsTableAnnotationComposer a) f,
  ) {
    final $$CareEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.careEvents,
      getReferencedColumn: (t) => t.plantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CareEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.careEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> diaryEntriesRefs<T extends Object>(
    Expression<T> Function($$DiaryEntriesTableAnnotationComposer a) f,
  ) {
    final $$DiaryEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.diaryEntries,
      getReferencedColumn: (t) => t.plantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiaryEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.diaryEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlantsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlantsTable,
          Plant,
          $$PlantsTableFilterComposer,
          $$PlantsTableOrderingComposer,
          $$PlantsTableAnnotationComposer,
          $$PlantsTableCreateCompanionBuilder,
          $$PlantsTableUpdateCompanionBuilder,
          (Plant, $$PlantsTableReferences),
          Plant,
          PrefetchHooks Function({
            bool speciesId,
            bool spaceId,
            bool careEventsRefs,
            bool diaryEntriesRefs,
          })
        > {
  $$PlantsTableTableManager(_$AppDatabase db, $PlantsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> speciesId = const Value.absent(),
                Value<String> nickname = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<int?> spaceId = const Value.absent(),
                Value<PotSize> potSize = const Value.absent(),
                Value<bool> hasDrainage = const Value.absent(),
                Value<int> waterIntervalDays = const Value.absent(),
                Value<bool> manualOverride = const Value.absent(),
                Value<double> feedbackCoef = const Value.absent(),
                Value<int> dryStreak = const Value.absent(),
                Value<DateTime> lastWateredAt = const Value.absent(),
                Value<DateTime> nextCheckAt = const Value.absent(),
                Value<int?> fertIntervalDays = const Value.absent(),
                Value<DateTime?> lastFertAt = const Value.absent(),
                Value<DateTime?> repotAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PlantsCompanion(
                id: id,
                speciesId: speciesId,
                nickname: nickname,
                photoPath: photoPath,
                spaceId: spaceId,
                potSize: potSize,
                hasDrainage: hasDrainage,
                waterIntervalDays: waterIntervalDays,
                manualOverride: manualOverride,
                feedbackCoef: feedbackCoef,
                dryStreak: dryStreak,
                lastWateredAt: lastWateredAt,
                nextCheckAt: nextCheckAt,
                fertIntervalDays: fertIntervalDays,
                lastFertAt: lastFertAt,
                repotAt: repotAt,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> speciesId = const Value.absent(),
                required String nickname,
                Value<String?> photoPath = const Value.absent(),
                Value<int?> spaceId = const Value.absent(),
                required PotSize potSize,
                Value<bool> hasDrainage = const Value.absent(),
                required int waterIntervalDays,
                Value<bool> manualOverride = const Value.absent(),
                Value<double> feedbackCoef = const Value.absent(),
                Value<int> dryStreak = const Value.absent(),
                required DateTime lastWateredAt,
                required DateTime nextCheckAt,
                Value<int?> fertIntervalDays = const Value.absent(),
                Value<DateTime?> lastFertAt = const Value.absent(),
                Value<DateTime?> repotAt = const Value.absent(),
                required DateTime createdAt,
              }) => PlantsCompanion.insert(
                id: id,
                speciesId: speciesId,
                nickname: nickname,
                photoPath: photoPath,
                spaceId: spaceId,
                potSize: potSize,
                hasDrainage: hasDrainage,
                waterIntervalDays: waterIntervalDays,
                manualOverride: manualOverride,
                feedbackCoef: feedbackCoef,
                dryStreak: dryStreak,
                lastWateredAt: lastWateredAt,
                nextCheckAt: nextCheckAt,
                fertIntervalDays: fertIntervalDays,
                lastFertAt: lastFertAt,
                repotAt: repotAt,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$PlantsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                speciesId = false,
                spaceId = false,
                careEventsRefs = false,
                diaryEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (careEventsRefs) db.careEvents,
                    if (diaryEntriesRefs) db.diaryEntries,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (speciesId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.speciesId,
                                    referencedTable: $$PlantsTableReferences
                                        ._speciesIdTable(db),
                                    referencedColumn: $$PlantsTableReferences
                                        ._speciesIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (spaceId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.spaceId,
                                    referencedTable: $$PlantsTableReferences
                                        ._spaceIdTable(db),
                                    referencedColumn: $$PlantsTableReferences
                                        ._spaceIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (careEventsRefs)
                        await $_getPrefetchedData<
                          Plant,
                          $PlantsTable,
                          CareEvent
                        >(
                          currentTable: table,
                          referencedTable: $$PlantsTableReferences
                              ._careEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlantsTableReferences(
                                db,
                                table,
                                p0,
                              ).careEventsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.plantId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (diaryEntriesRefs)
                        await $_getPrefetchedData<
                          Plant,
                          $PlantsTable,
                          DiaryEntry
                        >(
                          currentTable: table,
                          referencedTable: $$PlantsTableReferences
                              ._diaryEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlantsTableReferences(
                                db,
                                table,
                                p0,
                              ).diaryEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.plantId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PlantsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlantsTable,
      Plant,
      $$PlantsTableFilterComposer,
      $$PlantsTableOrderingComposer,
      $$PlantsTableAnnotationComposer,
      $$PlantsTableCreateCompanionBuilder,
      $$PlantsTableUpdateCompanionBuilder,
      (Plant, $$PlantsTableReferences),
      Plant,
      PrefetchHooks Function({
        bool speciesId,
        bool spaceId,
        bool careEventsRefs,
        bool diaryEntriesRefs,
      })
    >;
typedef $$CareEventsTableCreateCompanionBuilder =
    CareEventsCompanion Function({
      Value<int> id,
      required int plantId,
      required CareType type,
      required DateTime at,
      Value<String?> note,
    });
typedef $$CareEventsTableUpdateCompanionBuilder =
    CareEventsCompanion Function({
      Value<int> id,
      Value<int> plantId,
      Value<CareType> type,
      Value<DateTime> at,
      Value<String?> note,
    });

final class $$CareEventsTableReferences
    extends BaseReferences<_$AppDatabase, $CareEventsTable, CareEvent> {
  $$CareEventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlantsTable _plantIdTable(_$AppDatabase db) =>
      db.plants.createAlias('care_events__plant_id__plants__id');

  $$PlantsTableProcessedTableManager get plantId {
    final $_column = $_itemColumn<int>('plant_id')!;

    final manager = $$PlantsTableTableManager(
      $_db,
      $_db.plants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_plantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CareEventsTableFilterComposer
    extends Composer<_$AppDatabase, $CareEventsTable> {
  $$CareEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CareType, CareType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$PlantsTableFilterComposer get plantId {
    final $$PlantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.plantId,
      referencedTable: $db.plants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlantsTableFilterComposer(
            $db: $db,
            $table: $db.plants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CareEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $CareEventsTable> {
  $$CareEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlantsTableOrderingComposer get plantId {
    final $$PlantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.plantId,
      referencedTable: $db.plants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlantsTableOrderingComposer(
            $db: $db,
            $table: $db.plants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CareEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CareEventsTable> {
  $$CareEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CareType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$PlantsTableAnnotationComposer get plantId {
    final $$PlantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.plantId,
      referencedTable: $db.plants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlantsTableAnnotationComposer(
            $db: $db,
            $table: $db.plants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CareEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CareEventsTable,
          CareEvent,
          $$CareEventsTableFilterComposer,
          $$CareEventsTableOrderingComposer,
          $$CareEventsTableAnnotationComposer,
          $$CareEventsTableCreateCompanionBuilder,
          $$CareEventsTableUpdateCompanionBuilder,
          (CareEvent, $$CareEventsTableReferences),
          CareEvent,
          PrefetchHooks Function({bool plantId})
        > {
  $$CareEventsTableTableManager(_$AppDatabase db, $CareEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CareEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CareEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CareEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> plantId = const Value.absent(),
                Value<CareType> type = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => CareEventsCompanion(
                id: id,
                plantId: plantId,
                type: type,
                at: at,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int plantId,
                required CareType type,
                required DateTime at,
                Value<String?> note = const Value.absent(),
              }) => CareEventsCompanion.insert(
                id: id,
                plantId: plantId,
                type: type,
                at: at,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CareEventsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({plantId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (plantId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.plantId,
                                referencedTable: $$CareEventsTableReferences
                                    ._plantIdTable(db),
                                referencedColumn: $$CareEventsTableReferences
                                    ._plantIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CareEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CareEventsTable,
      CareEvent,
      $$CareEventsTableFilterComposer,
      $$CareEventsTableOrderingComposer,
      $$CareEventsTableAnnotationComposer,
      $$CareEventsTableCreateCompanionBuilder,
      $$CareEventsTableUpdateCompanionBuilder,
      (CareEvent, $$CareEventsTableReferences),
      CareEvent,
      PrefetchHooks Function({bool plantId})
    >;
typedef $$DiaryEntriesTableCreateCompanionBuilder =
    DiaryEntriesCompanion Function({
      Value<int> id,
      required int plantId,
      Value<String?> photoPath,
      Value<String?> memo,
      Value<List<DiaryTag>> tags,
      required DateTime at,
    });
typedef $$DiaryEntriesTableUpdateCompanionBuilder =
    DiaryEntriesCompanion Function({
      Value<int> id,
      Value<int> plantId,
      Value<String?> photoPath,
      Value<String?> memo,
      Value<List<DiaryTag>> tags,
      Value<DateTime> at,
    });

final class $$DiaryEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $DiaryEntriesTable, DiaryEntry> {
  $$DiaryEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlantsTable _plantIdTable(_$AppDatabase db) =>
      db.plants.createAlias('diary_entries__plant_id__plants__id');

  $$PlantsTableProcessedTableManager get plantId {
    final $_column = $_itemColumn<int>('plant_id')!;

    final manager = $$PlantsTableTableManager(
      $_db,
      $_db.plants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_plantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DiaryEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $DiaryEntriesTable> {
  $$DiaryEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<DiaryTag>, List<DiaryTag>, String>
  get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  $$PlantsTableFilterComposer get plantId {
    final $$PlantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.plantId,
      referencedTable: $db.plants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlantsTableFilterComposer(
            $db: $db,
            $table: $db.plants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiaryEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $DiaryEntriesTable> {
  $$DiaryEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlantsTableOrderingComposer get plantId {
    final $$PlantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.plantId,
      referencedTable: $db.plants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlantsTableOrderingComposer(
            $db: $db,
            $table: $db.plants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiaryEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiaryEntriesTable> {
  $$DiaryEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<DiaryTag>, String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  $$PlantsTableAnnotationComposer get plantId {
    final $$PlantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.plantId,
      referencedTable: $db.plants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlantsTableAnnotationComposer(
            $db: $db,
            $table: $db.plants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiaryEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiaryEntriesTable,
          DiaryEntry,
          $$DiaryEntriesTableFilterComposer,
          $$DiaryEntriesTableOrderingComposer,
          $$DiaryEntriesTableAnnotationComposer,
          $$DiaryEntriesTableCreateCompanionBuilder,
          $$DiaryEntriesTableUpdateCompanionBuilder,
          (DiaryEntry, $$DiaryEntriesTableReferences),
          DiaryEntry,
          PrefetchHooks Function({bool plantId})
        > {
  $$DiaryEntriesTableTableManager(_$AppDatabase db, $DiaryEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiaryEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiaryEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiaryEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> plantId = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<List<DiaryTag>> tags = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
              }) => DiaryEntriesCompanion(
                id: id,
                plantId: plantId,
                photoPath: photoPath,
                memo: memo,
                tags: tags,
                at: at,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int plantId,
                Value<String?> photoPath = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<List<DiaryTag>> tags = const Value.absent(),
                required DateTime at,
              }) => DiaryEntriesCompanion.insert(
                id: id,
                plantId: plantId,
                photoPath: photoPath,
                memo: memo,
                tags: tags,
                at: at,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DiaryEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({plantId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (plantId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.plantId,
                                referencedTable: $$DiaryEntriesTableReferences
                                    ._plantIdTable(db),
                                referencedColumn: $$DiaryEntriesTableReferences
                                    ._plantIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DiaryEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiaryEntriesTable,
      DiaryEntry,
      $$DiaryEntriesTableFilterComposer,
      $$DiaryEntriesTableOrderingComposer,
      $$DiaryEntriesTableAnnotationComposer,
      $$DiaryEntriesTableCreateCompanionBuilder,
      $$DiaryEntriesTableUpdateCompanionBuilder,
      (DiaryEntry, $$DiaryEntriesTableReferences),
      DiaryEntry,
      PrefetchHooks Function({bool plantId})
    >;
typedef $$IdentificationLogsTableCreateCompanionBuilder =
    IdentificationLogsCompanion Function({
      Value<int> id,
      required String localPhotoPath,
      required String candidatesJson,
      Value<int?> userSelectedSpeciesId,
      required DateTime at,
    });
typedef $$IdentificationLogsTableUpdateCompanionBuilder =
    IdentificationLogsCompanion Function({
      Value<int> id,
      Value<String> localPhotoPath,
      Value<String> candidatesJson,
      Value<int?> userSelectedSpeciesId,
      Value<DateTime> at,
    });

final class $$IdentificationLogsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $IdentificationLogsTable,
          IdentificationLog
        > {
  $$IdentificationLogsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SpeciesTable _userSelectedSpeciesIdTable(_$AppDatabase db) =>
      db.species.createAlias(
        'identification_logs__user_selected_species_id__species__id',
      );

  $$SpeciesTableProcessedTableManager? get userSelectedSpeciesId {
    final $_column = $_itemColumn<int>('user_selected_species_id');
    if ($_column == null) return null;
    final manager = $$SpeciesTableTableManager(
      $_db,
      $_db.species,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _userSelectedSpeciesIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$IdentificationLogsTableFilterComposer
    extends Composer<_$AppDatabase, $IdentificationLogsTable> {
  $$IdentificationLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPhotoPath => $composableBuilder(
    column: $table.localPhotoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get candidatesJson => $composableBuilder(
    column: $table.candidatesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  $$SpeciesTableFilterComposer get userSelectedSpeciesId {
    final $$SpeciesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userSelectedSpeciesId,
      referencedTable: $db.species,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpeciesTableFilterComposer(
            $db: $db,
            $table: $db.species,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IdentificationLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $IdentificationLogsTable> {
  $$IdentificationLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPhotoPath => $composableBuilder(
    column: $table.localPhotoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get candidatesJson => $composableBuilder(
    column: $table.candidatesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  $$SpeciesTableOrderingComposer get userSelectedSpeciesId {
    final $$SpeciesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userSelectedSpeciesId,
      referencedTable: $db.species,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpeciesTableOrderingComposer(
            $db: $db,
            $table: $db.species,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IdentificationLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IdentificationLogsTable> {
  $$IdentificationLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localPhotoPath => $composableBuilder(
    column: $table.localPhotoPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get candidatesJson => $composableBuilder(
    column: $table.candidatesJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  $$SpeciesTableAnnotationComposer get userSelectedSpeciesId {
    final $$SpeciesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userSelectedSpeciesId,
      referencedTable: $db.species,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpeciesTableAnnotationComposer(
            $db: $db,
            $table: $db.species,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IdentificationLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IdentificationLogsTable,
          IdentificationLog,
          $$IdentificationLogsTableFilterComposer,
          $$IdentificationLogsTableOrderingComposer,
          $$IdentificationLogsTableAnnotationComposer,
          $$IdentificationLogsTableCreateCompanionBuilder,
          $$IdentificationLogsTableUpdateCompanionBuilder,
          (IdentificationLog, $$IdentificationLogsTableReferences),
          IdentificationLog,
          PrefetchHooks Function({bool userSelectedSpeciesId})
        > {
  $$IdentificationLogsTableTableManager(
    _$AppDatabase db,
    $IdentificationLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IdentificationLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IdentificationLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IdentificationLogsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> localPhotoPath = const Value.absent(),
                Value<String> candidatesJson = const Value.absent(),
                Value<int?> userSelectedSpeciesId = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
              }) => IdentificationLogsCompanion(
                id: id,
                localPhotoPath: localPhotoPath,
                candidatesJson: candidatesJson,
                userSelectedSpeciesId: userSelectedSpeciesId,
                at: at,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String localPhotoPath,
                required String candidatesJson,
                Value<int?> userSelectedSpeciesId = const Value.absent(),
                required DateTime at,
              }) => IdentificationLogsCompanion.insert(
                id: id,
                localPhotoPath: localPhotoPath,
                candidatesJson: candidatesJson,
                userSelectedSpeciesId: userSelectedSpeciesId,
                at: at,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IdentificationLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userSelectedSpeciesId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userSelectedSpeciesId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userSelectedSpeciesId,
                                referencedTable:
                                    $$IdentificationLogsTableReferences
                                        ._userSelectedSpeciesIdTable(db),
                                referencedColumn:
                                    $$IdentificationLogsTableReferences
                                        ._userSelectedSpeciesIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$IdentificationLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IdentificationLogsTable,
      IdentificationLog,
      $$IdentificationLogsTableFilterComposer,
      $$IdentificationLogsTableOrderingComposer,
      $$IdentificationLogsTableAnnotationComposer,
      $$IdentificationLogsTableCreateCompanionBuilder,
      $$IdentificationLogsTableUpdateCompanionBuilder,
      (IdentificationLog, $$IdentificationLogsTableReferences),
      IdentificationLog,
      PrefetchHooks Function({bool userSelectedSpeciesId})
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      Value<int> id,
      Value<int> notifyHour,
      Value<int> notifyMinute,
      Value<List<int>> skipWeekdays,
      Value<String?> backupUserId,
      Value<bool> onboardingDone,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<int> id,
      Value<int> notifyHour,
      Value<int> notifyMinute,
      Value<List<int>> skipWeekdays,
      Value<String?> backupUserId,
      Value<bool> onboardingDone,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get notifyHour => $composableBuilder(
    column: $table.notifyHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get notifyMinute => $composableBuilder(
    column: $table.notifyMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<int>, List<int>, String>
  get skipWeekdays => $composableBuilder(
    column: $table.skipWeekdays,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get backupUserId => $composableBuilder(
    column: $table.backupUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingDone => $composableBuilder(
    column: $table.onboardingDone,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get notifyHour => $composableBuilder(
    column: $table.notifyHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get notifyMinute => $composableBuilder(
    column: $table.notifyMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get skipWeekdays => $composableBuilder(
    column: $table.skipWeekdays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get backupUserId => $composableBuilder(
    column: $table.backupUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingDone => $composableBuilder(
    column: $table.onboardingDone,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get notifyHour => $composableBuilder(
    column: $table.notifyHour,
    builder: (column) => column,
  );

  GeneratedColumn<int> get notifyMinute => $composableBuilder(
    column: $table.notifyMinute,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<int>, String> get skipWeekdays =>
      $composableBuilder(
        column: $table.skipWeekdays,
        builder: (column) => column,
      );

  GeneratedColumn<String> get backupUserId => $composableBuilder(
    column: $table.backupUserId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onboardingDone => $composableBuilder(
    column: $table.onboardingDone,
    builder: (column) => column,
  );
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> notifyHour = const Value.absent(),
                Value<int> notifyMinute = const Value.absent(),
                Value<List<int>> skipWeekdays = const Value.absent(),
                Value<String?> backupUserId = const Value.absent(),
                Value<bool> onboardingDone = const Value.absent(),
              }) => SettingsCompanion(
                id: id,
                notifyHour: notifyHour,
                notifyMinute: notifyMinute,
                skipWeekdays: skipWeekdays,
                backupUserId: backupUserId,
                onboardingDone: onboardingDone,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> notifyHour = const Value.absent(),
                Value<int> notifyMinute = const Value.absent(),
                Value<List<int>> skipWeekdays = const Value.absent(),
                Value<String?> backupUserId = const Value.absent(),
                Value<bool> onboardingDone = const Value.absent(),
              }) => SettingsCompanion.insert(
                id: id,
                notifyHour: notifyHour,
                notifyMinute: notifyMinute,
                skipWeekdays: skipWeekdays,
                backupUserId: backupUserId,
                onboardingDone: onboardingDone,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SpeciesTableTableManager get species =>
      $$SpeciesTableTableManager(_db, _db.species);
  $$SpacesTableTableManager get spaces =>
      $$SpacesTableTableManager(_db, _db.spaces);
  $$PlantsTableTableManager get plants =>
      $$PlantsTableTableManager(_db, _db.plants);
  $$CareEventsTableTableManager get careEvents =>
      $$CareEventsTableTableManager(_db, _db.careEvents);
  $$DiaryEntriesTableTableManager get diaryEntries =>
      $$DiaryEntriesTableTableManager(_db, _db.diaryEntries);
  $$IdentificationLogsTableTableManager get identificationLogs =>
      $$IdentificationLogsTableTableManager(_db, _db.identificationLogs);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
