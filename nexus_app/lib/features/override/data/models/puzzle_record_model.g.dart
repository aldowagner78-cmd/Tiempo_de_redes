// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'puzzle_record_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPuzzleRecordModelCollection on Isar {
  IsarCollection<PuzzleRecordModel> get puzzleRecordModels => this.collection();
}

const PuzzleRecordModelSchema = CollectionSchema(
  name: r'PuzzleRecordModel',
  id: 4838555191619853878,
  properties: {
    r'attempts': PropertySchema(
      id: 0,
      name: r'attempts',
      type: IsarType.long,
    ),
    r'coinsEarned': PropertySchema(
      id: 1,
      name: r'coinsEarned',
      type: IsarType.long,
    ),
    r'completedAt': PropertySchema(
      id: 2,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'completionTimeSeconds': PropertySchema(
      id: 3,
      name: r'completionTimeSeconds',
      type: IsarType.long,
    ),
    r'difficultyLevel': PropertySchema(
      id: 4,
      name: r'difficultyLevel',
      type: IsarType.long,
    ),
    r'isCompleted': PropertySchema(
      id: 5,
      name: r'isCompleted',
      type: IsarType.bool,
    ),
    r'puzzleId': PropertySchema(
      id: 6,
      name: r'puzzleId',
      type: IsarType.string,
    ),
    r'puzzleType': PropertySchema(
      id: 7,
      name: r'puzzleType',
      type: IsarType.string,
      enumMap: _PuzzleRecordModelpuzzleTypeEnumValueMap,
    ),
    r'score': PropertySchema(
      id: 8,
      name: r'score',
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
  estimateSize: _puzzleRecordModelEstimateSize,
  serialize: _puzzleRecordModelSerialize,
  deserialize: _puzzleRecordModelDeserialize,
  deserializeProp: _puzzleRecordModelDeserializeProp,
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
  getId: _puzzleRecordModelGetId,
  getLinks: _puzzleRecordModelGetLinks,
  attach: _puzzleRecordModelAttach,
  version: '3.1.0+1',
);

int _puzzleRecordModelEstimateSize(
  PuzzleRecordModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.puzzleId.length * 3;
  bytesCount += 3 + object.puzzleType.name.length * 3;
  return bytesCount;
}

void _puzzleRecordModelSerialize(
  PuzzleRecordModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.attempts);
  writer.writeLong(offsets[1], object.coinsEarned);
  writer.writeDateTime(offsets[2], object.completedAt);
  writer.writeLong(offsets[3], object.completionTimeSeconds);
  writer.writeLong(offsets[4], object.difficultyLevel);
  writer.writeBool(offsets[5], object.isCompleted);
  writer.writeString(offsets[6], object.puzzleId);
  writer.writeString(offsets[7], object.puzzleType.name);
  writer.writeLong(offsets[8], object.score);
  writer.writeLong(offsets[9], object.timeEarnedSeconds);
  writer.writeLong(offsets[10], object.xpEarned);
}

PuzzleRecordModel _puzzleRecordModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PuzzleRecordModel();
  object.attempts = reader.readLong(offsets[0]);
  object.coinsEarned = reader.readLong(offsets[1]);
  object.completedAt = reader.readDateTime(offsets[2]);
  object.completionTimeSeconds = reader.readLong(offsets[3]);
  object.difficultyLevel = reader.readLong(offsets[4]);
  object.id = id;
  object.isCompleted = reader.readBool(offsets[5]);
  object.puzzleId = reader.readString(offsets[6]);
  object.puzzleType = _PuzzleRecordModelpuzzleTypeValueEnumMap[
          reader.readStringOrNull(offsets[7])] ??
      PuzzleType.logicGate;
  object.score = reader.readLong(offsets[8]);
  object.timeEarnedSeconds = reader.readLong(offsets[9]);
  object.xpEarned = reader.readLong(offsets[10]);
  return object;
}

P _puzzleRecordModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (_PuzzleRecordModelpuzzleTypeValueEnumMap[
              reader.readStringOrNull(offset)] ??
          PuzzleType.logicGate) as P;
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

const _PuzzleRecordModelpuzzleTypeEnumValueMap = {
  r'logicGate': r'logicGate',
  r'debugging': r'debugging',
  r'flowchart': r'flowchart',
  r'sequenceSort': r'sequenceSort',
  r'patternMatch': r'patternMatch',
};
const _PuzzleRecordModelpuzzleTypeValueEnumMap = {
  r'logicGate': PuzzleType.logicGate,
  r'debugging': PuzzleType.debugging,
  r'flowchart': PuzzleType.flowchart,
  r'sequenceSort': PuzzleType.sequenceSort,
  r'patternMatch': PuzzleType.patternMatch,
};

Id _puzzleRecordModelGetId(PuzzleRecordModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _puzzleRecordModelGetLinks(
    PuzzleRecordModel object) {
  return [];
}

void _puzzleRecordModelAttach(
    IsarCollection<dynamic> col, Id id, PuzzleRecordModel object) {
  object.id = id;
}

extension PuzzleRecordModelQueryWhereSort
    on QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QWhere> {
  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterWhere>
      anyCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'completedAt'),
      );
    });
  }
}

extension PuzzleRecordModelQueryWhere
    on QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QWhereClause> {
  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterWhereClause>
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

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterWhereClause>
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

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterWhereClause>
      completedAtEqualTo(DateTime completedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'completedAt',
        value: [completedAt],
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterWhereClause>
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

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterWhereClause>
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

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterWhereClause>
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

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterWhereClause>
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

extension PuzzleRecordModelQueryFilter
    on QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QFilterCondition> {
  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      attemptsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'attempts',
        value: value,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      attemptsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'attempts',
        value: value,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      attemptsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'attempts',
        value: value,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      attemptsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'attempts',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      coinsEarnedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'coinsEarned',
        value: value,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
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

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
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

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
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

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      completedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
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

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
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

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
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

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      completionTimeSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completionTimeSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      completionTimeSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completionTimeSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      completionTimeSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completionTimeSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      completionTimeSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completionTimeSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      difficultyLevelEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'difficultyLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      difficultyLevelGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'difficultyLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      difficultyLevelLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'difficultyLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      difficultyLevelBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'difficultyLevel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
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

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
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

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
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

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      isCompletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      puzzleIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'puzzleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      puzzleIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'puzzleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      puzzleIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'puzzleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      puzzleIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'puzzleId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      puzzleIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'puzzleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      puzzleIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'puzzleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      puzzleIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'puzzleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      puzzleIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'puzzleId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      puzzleIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'puzzleId',
        value: '',
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      puzzleIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'puzzleId',
        value: '',
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      puzzleTypeEqualTo(
    PuzzleType value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'puzzleType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      puzzleTypeGreaterThan(
    PuzzleType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'puzzleType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      puzzleTypeLessThan(
    PuzzleType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'puzzleType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      puzzleTypeBetween(
    PuzzleType lower,
    PuzzleType upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'puzzleType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      puzzleTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'puzzleType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      puzzleTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'puzzleType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      puzzleTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'puzzleType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      puzzleTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'puzzleType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      puzzleTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'puzzleType',
        value: '',
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      puzzleTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'puzzleType',
        value: '',
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      scoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'score',
        value: value,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
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

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
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

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
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

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      timeEarnedSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeEarnedSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
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

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
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

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
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

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
      xpEarnedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'xpEarned',
        value: value,
      ));
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
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

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
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

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterFilterCondition>
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

extension PuzzleRecordModelQueryObject
    on QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QFilterCondition> {}

extension PuzzleRecordModelQueryLinks
    on QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QFilterCondition> {}

extension PuzzleRecordModelQuerySortBy
    on QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QSortBy> {
  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      sortByAttempts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attempts', Sort.asc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      sortByAttemptsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attempts', Sort.desc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      sortByCoinsEarned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsEarned', Sort.asc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      sortByCoinsEarnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsEarned', Sort.desc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      sortByCompletionTimeSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionTimeSeconds', Sort.asc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      sortByCompletionTimeSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionTimeSeconds', Sort.desc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      sortByDifficultyLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficultyLevel', Sort.asc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      sortByDifficultyLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficultyLevel', Sort.desc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      sortByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      sortByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      sortByPuzzleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puzzleId', Sort.asc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      sortByPuzzleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puzzleId', Sort.desc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      sortByPuzzleType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puzzleType', Sort.asc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      sortByPuzzleTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puzzleType', Sort.desc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      sortByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      sortByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      sortByTimeEarnedSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeEarnedSeconds', Sort.asc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      sortByTimeEarnedSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeEarnedSeconds', Sort.desc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      sortByXpEarned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xpEarned', Sort.asc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      sortByXpEarnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xpEarned', Sort.desc);
    });
  }
}

extension PuzzleRecordModelQuerySortThenBy
    on QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QSortThenBy> {
  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      thenByAttempts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attempts', Sort.asc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      thenByAttemptsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attempts', Sort.desc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      thenByCoinsEarned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsEarned', Sort.asc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      thenByCoinsEarnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsEarned', Sort.desc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      thenByCompletionTimeSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionTimeSeconds', Sort.asc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      thenByCompletionTimeSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionTimeSeconds', Sort.desc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      thenByDifficultyLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficultyLevel', Sort.asc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      thenByDifficultyLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficultyLevel', Sort.desc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      thenByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      thenByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      thenByPuzzleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puzzleId', Sort.asc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      thenByPuzzleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puzzleId', Sort.desc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      thenByPuzzleType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puzzleType', Sort.asc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      thenByPuzzleTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puzzleType', Sort.desc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      thenByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      thenByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      thenByTimeEarnedSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeEarnedSeconds', Sort.asc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      thenByTimeEarnedSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeEarnedSeconds', Sort.desc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      thenByXpEarned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xpEarned', Sort.asc);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QAfterSortBy>
      thenByXpEarnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xpEarned', Sort.desc);
    });
  }
}

extension PuzzleRecordModelQueryWhereDistinct
    on QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QDistinct> {
  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QDistinct>
      distinctByAttempts() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'attempts');
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QDistinct>
      distinctByCoinsEarned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'coinsEarned');
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QDistinct>
      distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QDistinct>
      distinctByCompletionTimeSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completionTimeSeconds');
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QDistinct>
      distinctByDifficultyLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'difficultyLevel');
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QDistinct>
      distinctByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCompleted');
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QDistinct>
      distinctByPuzzleId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'puzzleId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QDistinct>
      distinctByPuzzleType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'puzzleType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QDistinct>
      distinctByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'score');
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QDistinct>
      distinctByTimeEarnedSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timeEarnedSeconds');
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QDistinct>
      distinctByXpEarned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'xpEarned');
    });
  }
}

extension PuzzleRecordModelQueryProperty
    on QueryBuilder<PuzzleRecordModel, PuzzleRecordModel, QQueryProperty> {
  QueryBuilder<PuzzleRecordModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PuzzleRecordModel, int, QQueryOperations> attemptsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'attempts');
    });
  }

  QueryBuilder<PuzzleRecordModel, int, QQueryOperations> coinsEarnedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coinsEarned');
    });
  }

  QueryBuilder<PuzzleRecordModel, DateTime, QQueryOperations>
      completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<PuzzleRecordModel, int, QQueryOperations>
      completionTimeSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completionTimeSeconds');
    });
  }

  QueryBuilder<PuzzleRecordModel, int, QQueryOperations>
      difficultyLevelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'difficultyLevel');
    });
  }

  QueryBuilder<PuzzleRecordModel, bool, QQueryOperations>
      isCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCompleted');
    });
  }

  QueryBuilder<PuzzleRecordModel, String, QQueryOperations> puzzleIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'puzzleId');
    });
  }

  QueryBuilder<PuzzleRecordModel, PuzzleType, QQueryOperations>
      puzzleTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'puzzleType');
    });
  }

  QueryBuilder<PuzzleRecordModel, int, QQueryOperations> scoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'score');
    });
  }

  QueryBuilder<PuzzleRecordModel, int, QQueryOperations>
      timeEarnedSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeEarnedSeconds');
    });
  }

  QueryBuilder<PuzzleRecordModel, int, QQueryOperations> xpEarnedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'xpEarned');
    });
  }
}
