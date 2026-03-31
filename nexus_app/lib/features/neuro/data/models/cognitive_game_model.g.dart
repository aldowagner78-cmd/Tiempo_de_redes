// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cognitive_game_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCognitiveGameModelCollection on Isar {
  IsarCollection<CognitiveGameModel> get cognitiveGameModels =>
      this.collection();
}

const CognitiveGameModelSchema = CollectionSchema(
  name: r'CognitiveGameModel',
  id: -5085841424339656581,
  properties: {
    r'accuracy': PropertySchema(
      id: 0,
      name: r'accuracy',
      type: IsarType.double,
    ),
    r'avgReactionTimeMs': PropertySchema(
      id: 1,
      name: r'avgReactionTimeMs',
      type: IsarType.long,
    ),
    r'bestStreak': PropertySchema(
      id: 2,
      name: r'bestStreak',
      type: IsarType.long,
    ),
    r'coinsEarned': PropertySchema(
      id: 3,
      name: r'coinsEarned',
      type: IsarType.long,
    ),
    r'completedAt': PropertySchema(
      id: 4,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'gameType': PropertySchema(
      id: 5,
      name: r'gameType',
      type: IsarType.string,
      enumMap: _CognitiveGameModelgameTypeEnumValueMap,
    ),
    r'levelReached': PropertySchema(
      id: 6,
      name: r'levelReached',
      type: IsarType.long,
    ),
    r'score': PropertySchema(
      id: 7,
      name: r'score',
      type: IsarType.long,
    ),
    r'sessionDurationSeconds': PropertySchema(
      id: 8,
      name: r'sessionDurationSeconds',
      type: IsarType.long,
    ),
    r'timeEarnedSeconds': PropertySchema(
      id: 9,
      name: r'timeEarnedSeconds',
      type: IsarType.long,
    ),
    r'xpEarned': PropertySchema(
      id: 10,
      name: r'xpEarned',
      type: IsarType.long,
    )
  },
  estimateSize: _cognitiveGameModelEstimateSize,
  serialize: _cognitiveGameModelSerialize,
  deserialize: _cognitiveGameModelDeserialize,
  deserializeProp: _cognitiveGameModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'completedAt': IndexSchema(
      id: -3156591011457686752,
      name: r'completedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'completedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _cognitiveGameModelGetId,
  getLinks: _cognitiveGameModelGetLinks,
  attach: _cognitiveGameModelAttach,
  version: '3.1.0+1',
);

int _cognitiveGameModelEstimateSize(
  CognitiveGameModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.gameType.name.length * 3;
  return bytesCount;
}

void _cognitiveGameModelSerialize(
  CognitiveGameModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.accuracy);
  writer.writeLong(offsets[1], object.avgReactionTimeMs);
  writer.writeLong(offsets[2], object.bestStreak);
  writer.writeLong(offsets[3], object.coinsEarned);
  writer.writeDateTime(offsets[4], object.completedAt);
  writer.writeString(offsets[5], object.gameType.name);
  writer.writeLong(offsets[6], object.levelReached);
  writer.writeLong(offsets[7], object.score);
  writer.writeLong(offsets[8], object.sessionDurationSeconds);
  writer.writeLong(offsets[9], object.timeEarnedSeconds);
  writer.writeLong(offsets[10], object.xpEarned);
}

CognitiveGameModel _cognitiveGameModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CognitiveGameModel();
  object.accuracy = reader.readDouble(offsets[0]);
  object.avgReactionTimeMs = reader.readLong(offsets[1]);
  object.bestStreak = reader.readLong(offsets[2]);
  object.coinsEarned = reader.readLong(offsets[3]);
  object.completedAt = reader.readDateTime(offsets[4]);
  object.gameType = _CognitiveGameModelgameTypeValueEnumMap[
          reader.readStringOrNull(offsets[5])] ??
      CognitiveGameType.nBack;
  object.id = id;
  object.levelReached = reader.readLong(offsets[6]);
  object.score = reader.readLong(offsets[7]);
  object.sessionDurationSeconds = reader.readLong(offsets[8]);
  object.timeEarnedSeconds = reader.readLong(offsets[9]);
  object.xpEarned = reader.readLong(offsets[10]);
  return object;
}

P _cognitiveGameModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (_CognitiveGameModelgameTypeValueEnumMap[
              reader.readStringOrNull(offset)] ??
          CognitiveGameType.nBack) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _CognitiveGameModelgameTypeEnumValueMap = {
  r'nBack': r'nBack',
  r'stroopTest': r'stroopTest',
  r'dividedAttention': r'dividedAttention',
  r'reactionTime': r'reactionTime',
  r'patternMemory': r'patternMemory',
  r'simonSays': r'simonSays',
};
const _CognitiveGameModelgameTypeValueEnumMap = {
  r'nBack': CognitiveGameType.nBack,
  r'stroopTest': CognitiveGameType.stroopTest,
  r'dividedAttention': CognitiveGameType.dividedAttention,
  r'reactionTime': CognitiveGameType.reactionTime,
  r'patternMemory': CognitiveGameType.patternMemory,
  r'simonSays': CognitiveGameType.simonSays,
};

Id _cognitiveGameModelGetId(CognitiveGameModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _cognitiveGameModelGetLinks(
    CognitiveGameModel object) {
  return [];
}

void _cognitiveGameModelAttach(
    IsarCollection<dynamic> col, Id id, CognitiveGameModel object) {
  object.id = id;
}

extension CognitiveGameModelQueryWhereSort
    on QueryBuilder<CognitiveGameModel, CognitiveGameModel, QWhere> {
  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterWhere>
      anyCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'completedAt'),
      );
    });
  }
}

extension CognitiveGameModelQueryWhere
    on QueryBuilder<CognitiveGameModel, CognitiveGameModel, QWhereClause> {
  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterWhereClause>
      completedAtEqualTo(DateTime completedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'completedAt',
        value: [completedAt],
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterWhereClause>
      completedAtNotEqualTo(DateTime completedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completedAt',
              lower: [],
              upper: [completedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completedAt',
              lower: [completedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completedAt',
              lower: [completedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completedAt',
              lower: [],
              upper: [completedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterWhereClause>
      completedAtGreaterThan(
    DateTime completedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'completedAt',
        lower: [completedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterWhereClause>
      completedAtLessThan(
    DateTime completedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'completedAt',
        lower: [],
        upper: [completedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterWhereClause>
      completedAtBetween(
    DateTime lowerCompletedAt,
    DateTime upperCompletedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'completedAt',
        lower: [lowerCompletedAt],
        includeLower: includeLower,
        upper: [upperCompletedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CognitiveGameModelQueryFilter
    on QueryBuilder<CognitiveGameModel, CognitiveGameModel, QFilterCondition> {
  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      accuracyEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accuracy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      accuracyGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'accuracy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      accuracyLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'accuracy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      accuracyBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'accuracy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      avgReactionTimeMsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avgReactionTimeMs',
        value: value,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      avgReactionTimeMsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'avgReactionTimeMs',
        value: value,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      avgReactionTimeMsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'avgReactionTimeMs',
        value: value,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      avgReactionTimeMsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'avgReactionTimeMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      bestStreakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bestStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      bestStreakGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bestStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      bestStreakLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bestStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      bestStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bestStreak',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      coinsEarnedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'coinsEarned',
        value: value,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      coinsEarnedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'coinsEarned',
        value: value,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      coinsEarnedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'coinsEarned',
        value: value,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      coinsEarnedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'coinsEarned',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      completedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      completedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      completedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      completedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      gameTypeEqualTo(
    CognitiveGameType value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gameType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      gameTypeGreaterThan(
    CognitiveGameType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gameType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      gameTypeLessThan(
    CognitiveGameType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gameType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      gameTypeBetween(
    CognitiveGameType lower,
    CognitiveGameType upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gameType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      gameTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'gameType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      gameTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'gameType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      gameTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'gameType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      gameTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'gameType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      gameTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gameType',
        value: '',
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      gameTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'gameType',
        value: '',
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      levelReachedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'levelReached',
        value: value,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      levelReachedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'levelReached',
        value: value,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      levelReachedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'levelReached',
        value: value,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      levelReachedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'levelReached',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      scoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'score',
        value: value,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      scoreGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'score',
        value: value,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      scoreLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'score',
        value: value,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      scoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'score',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      sessionDurationSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      sessionDurationSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sessionDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      sessionDurationSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sessionDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      sessionDurationSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sessionDurationSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      timeEarnedSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeEarnedSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      timeEarnedSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timeEarnedSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      timeEarnedSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timeEarnedSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      timeEarnedSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timeEarnedSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      xpEarnedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'xpEarned',
        value: value,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      xpEarnedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'xpEarned',
        value: value,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      xpEarnedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'xpEarned',
        value: value,
      ));
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterFilterCondition>
      xpEarnedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'xpEarned',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CognitiveGameModelQueryObject
    on QueryBuilder<CognitiveGameModel, CognitiveGameModel, QFilterCondition> {}

extension CognitiveGameModelQueryLinks
    on QueryBuilder<CognitiveGameModel, CognitiveGameModel, QFilterCondition> {}

extension CognitiveGameModelQuerySortBy
    on QueryBuilder<CognitiveGameModel, CognitiveGameModel, QSortBy> {
  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      sortByAccuracy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accuracy', Sort.asc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      sortByAccuracyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accuracy', Sort.desc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      sortByAvgReactionTimeMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgReactionTimeMs', Sort.asc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      sortByAvgReactionTimeMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgReactionTimeMs', Sort.desc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      sortByBestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestStreak', Sort.asc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      sortByBestStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestStreak', Sort.desc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      sortByCoinsEarned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsEarned', Sort.asc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      sortByCoinsEarnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsEarned', Sort.desc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      sortByGameType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameType', Sort.asc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      sortByGameTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameType', Sort.desc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      sortByLevelReached() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'levelReached', Sort.asc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      sortByLevelReachedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'levelReached', Sort.desc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      sortByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      sortByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      sortBySessionDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionDurationSeconds', Sort.asc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      sortBySessionDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionDurationSeconds', Sort.desc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      sortByTimeEarnedSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeEarnedSeconds', Sort.asc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      sortByTimeEarnedSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeEarnedSeconds', Sort.desc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      sortByXpEarned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xpEarned', Sort.asc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      sortByXpEarnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xpEarned', Sort.desc);
    });
  }
}

extension CognitiveGameModelQuerySortThenBy
    on QueryBuilder<CognitiveGameModel, CognitiveGameModel, QSortThenBy> {
  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      thenByAccuracy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accuracy', Sort.asc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      thenByAccuracyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accuracy', Sort.desc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      thenByAvgReactionTimeMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgReactionTimeMs', Sort.asc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      thenByAvgReactionTimeMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgReactionTimeMs', Sort.desc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      thenByBestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestStreak', Sort.asc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      thenByBestStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestStreak', Sort.desc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      thenByCoinsEarned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsEarned', Sort.asc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      thenByCoinsEarnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsEarned', Sort.desc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      thenByGameType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameType', Sort.asc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      thenByGameTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameType', Sort.desc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      thenByLevelReached() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'levelReached', Sort.asc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      thenByLevelReachedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'levelReached', Sort.desc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      thenByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      thenByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      thenBySessionDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionDurationSeconds', Sort.asc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      thenBySessionDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionDurationSeconds', Sort.desc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      thenByTimeEarnedSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeEarnedSeconds', Sort.asc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      thenByTimeEarnedSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeEarnedSeconds', Sort.desc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      thenByXpEarned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xpEarned', Sort.asc);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QAfterSortBy>
      thenByXpEarnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xpEarned', Sort.desc);
    });
  }
}

extension CognitiveGameModelQueryWhereDistinct
    on QueryBuilder<CognitiveGameModel, CognitiveGameModel, QDistinct> {
  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QDistinct>
      distinctByAccuracy() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accuracy');
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QDistinct>
      distinctByAvgReactionTimeMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'avgReactionTimeMs');
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QDistinct>
      distinctByBestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bestStreak');
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QDistinct>
      distinctByCoinsEarned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'coinsEarned');
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QDistinct>
      distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QDistinct>
      distinctByGameType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gameType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QDistinct>
      distinctByLevelReached() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'levelReached');
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QDistinct>
      distinctByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'score');
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QDistinct>
      distinctBySessionDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionDurationSeconds');
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QDistinct>
      distinctByTimeEarnedSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timeEarnedSeconds');
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameModel, QDistinct>
      distinctByXpEarned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'xpEarned');
    });
  }
}

extension CognitiveGameModelQueryProperty
    on QueryBuilder<CognitiveGameModel, CognitiveGameModel, QQueryProperty> {
  QueryBuilder<CognitiveGameModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CognitiveGameModel, double, QQueryOperations>
      accuracyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accuracy');
    });
  }

  QueryBuilder<CognitiveGameModel, int, QQueryOperations>
      avgReactionTimeMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'avgReactionTimeMs');
    });
  }

  QueryBuilder<CognitiveGameModel, int, QQueryOperations> bestStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bestStreak');
    });
  }

  QueryBuilder<CognitiveGameModel, int, QQueryOperations>
      coinsEarnedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coinsEarned');
    });
  }

  QueryBuilder<CognitiveGameModel, DateTime, QQueryOperations>
      completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<CognitiveGameModel, CognitiveGameType, QQueryOperations>
      gameTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gameType');
    });
  }

  QueryBuilder<CognitiveGameModel, int, QQueryOperations>
      levelReachedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'levelReached');
    });
  }

  QueryBuilder<CognitiveGameModel, int, QQueryOperations> scoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'score');
    });
  }

  QueryBuilder<CognitiveGameModel, int, QQueryOperations>
      sessionDurationSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionDurationSeconds');
    });
  }

  QueryBuilder<CognitiveGameModel, int, QQueryOperations>
      timeEarnedSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeEarnedSeconds');
    });
  }

  QueryBuilder<CognitiveGameModel, int, QQueryOperations> xpEarnedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'xpEarned');
    });
  }
}
