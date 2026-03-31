// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biocoin_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBioCoinTransactionCollection on Isar {
  IsarCollection<BioCoinTransaction> get bioCoinTransactions =>
      this.collection();
}

const BioCoinTransactionSchema = CollectionSchema(
  name: r'BioCoinTransaction',
  id: -1555999225667512335,
  properties: {
    r'amount': PropertySchema(
      id: 0,
      name: r'amount',
      type: IsarType.long,
    ),
    r'balanceAfter': PropertySchema(
      id: 1,
      name: r'balanceAfter',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'description': PropertySchema(
      id: 3,
      name: r'description',
      type: IsarType.string,
    ),
    r'metadata': PropertySchema(
      id: 4,
      name: r'metadata',
      type: IsarType.string,
    ),
    r'source': PropertySchema(
      id: 5,
      name: r'source',
      type: IsarType.byte,
      enumMap: _BioCoinTransactionsourceEnumValueMap,
    ),
    r'type': PropertySchema(
      id: 6,
      name: r'type',
      type: IsarType.byte,
      enumMap: _BioCoinTransactiontypeEnumValueMap,
    ),
    r'userId': PropertySchema(
      id: 7,
      name: r'userId',
      type: IsarType.long,
    )
  },
  estimateSize: _bioCoinTransactionEstimateSize,
  serialize: _bioCoinTransactionSerialize,
  deserialize: _bioCoinTransactionDeserialize,
  deserializeProp: _bioCoinTransactionDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _bioCoinTransactionGetId,
  getLinks: _bioCoinTransactionGetLinks,
  attach: _bioCoinTransactionAttach,
  version: '3.1.0+1',
);

int _bioCoinTransactionEstimateSize(
  BioCoinTransaction object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.description.length * 3;
  {
    final value = object.metadata;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _bioCoinTransactionSerialize(
  BioCoinTransaction object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.amount);
  writer.writeLong(offsets[1], object.balanceAfter);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.description);
  writer.writeString(offsets[4], object.metadata);
  writer.writeByte(offsets[5], object.source.index);
  writer.writeByte(offsets[6], object.type.index);
  writer.writeLong(offsets[7], object.userId);
}

BioCoinTransaction _bioCoinTransactionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BioCoinTransaction();
  object.amount = reader.readLong(offsets[0]);
  object.balanceAfter = reader.readLong(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.description = reader.readString(offsets[3]);
  object.id = id;
  object.metadata = reader.readStringOrNull(offsets[4]);
  object.source = _BioCoinTransactionsourceValueEnumMap[
          reader.readByteOrNull(offsets[5])] ??
      TransactionSource.arena;
  object.type =
      _BioCoinTransactiontypeValueEnumMap[reader.readByteOrNull(offsets[6])] ??
          TransactionType.earned;
  object.userId = reader.readLong(offsets[7]);
  return object;
}

P _bioCoinTransactionDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (_BioCoinTransactionsourceValueEnumMap[
              reader.readByteOrNull(offset)] ??
          TransactionSource.arena) as P;
    case 6:
      return (_BioCoinTransactiontypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          TransactionType.earned) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _BioCoinTransactionsourceEnumValueMap = {
  'arena': 0,
  'biofuel': 1,
  'comms': 2,
  'logic': 3,
  'math': 4,
  'coding': 5,
  'neuro': 6,
  'override': 7,
  'parent': 8,
  'system': 9,
};
const _BioCoinTransactionsourceValueEnumMap = {
  0: TransactionSource.arena,
  1: TransactionSource.biofuel,
  2: TransactionSource.comms,
  3: TransactionSource.logic,
  4: TransactionSource.math,
  5: TransactionSource.coding,
  6: TransactionSource.neuro,
  7: TransactionSource.override,
  8: TransactionSource.parent,
  9: TransactionSource.system,
};
const _BioCoinTransactiontypeEnumValueMap = {
  'earned': 0,
  'spent': 1,
  'bonus': 2,
  'penalty': 3,
};
const _BioCoinTransactiontypeValueEnumMap = {
  0: TransactionType.earned,
  1: TransactionType.spent,
  2: TransactionType.bonus,
  3: TransactionType.penalty,
};

Id _bioCoinTransactionGetId(BioCoinTransaction object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _bioCoinTransactionGetLinks(
    BioCoinTransaction object) {
  return [];
}

void _bioCoinTransactionAttach(
    IsarCollection<dynamic> col, Id id, BioCoinTransaction object) {
  object.id = id;
}

extension BioCoinTransactionQueryWhereSort
    on QueryBuilder<BioCoinTransaction, BioCoinTransaction, QWhere> {
  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BioCoinTransactionQueryWhere
    on QueryBuilder<BioCoinTransaction, BioCoinTransaction, QWhereClause> {
  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterWhereClause>
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

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterWhereClause>
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
}

extension BioCoinTransactionQueryFilter
    on QueryBuilder<BioCoinTransaction, BioCoinTransaction, QFilterCondition> {
  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      amountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      amountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amount',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      amountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amount',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      amountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      balanceAfterEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'balanceAfter',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      balanceAfterGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'balanceAfter',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      balanceAfterLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'balanceAfter',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      balanceAfterBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'balanceAfter',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      descriptionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      descriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      descriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      descriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
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

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
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

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
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

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      metadataIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'metadata',
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      metadataIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'metadata',
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      metadataEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'metadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      metadataGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'metadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      metadataLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'metadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      metadataBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'metadata',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      metadataStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'metadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      metadataEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'metadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      metadataContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'metadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      metadataMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'metadata',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      metadataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'metadata',
        value: '',
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      metadataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'metadata',
        value: '',
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      sourceEqualTo(TransactionSource value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      sourceGreaterThan(
    TransactionSource value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'source',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      sourceLessThan(
    TransactionSource value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'source',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      sourceBetween(
    TransactionSource lower,
    TransactionSource upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'source',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      typeEqualTo(TransactionType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      typeGreaterThan(
    TransactionType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      typeLessThan(
    TransactionType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      typeBetween(
    TransactionType lower,
    TransactionType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      userIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      userIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      userIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterFilterCondition>
      userIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BioCoinTransactionQueryObject
    on QueryBuilder<BioCoinTransaction, BioCoinTransaction, QFilterCondition> {}

extension BioCoinTransactionQueryLinks
    on QueryBuilder<BioCoinTransaction, BioCoinTransaction, QFilterCondition> {}

extension BioCoinTransactionQuerySortBy
    on QueryBuilder<BioCoinTransaction, BioCoinTransaction, QSortBy> {
  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      sortByBalanceAfter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balanceAfter', Sort.asc);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      sortByBalanceAfterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balanceAfter', Sort.desc);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      sortByMetadata() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadata', Sort.asc);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      sortByMetadataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadata', Sort.desc);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      sortBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      sortBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension BioCoinTransactionQuerySortThenBy
    on QueryBuilder<BioCoinTransaction, BioCoinTransaction, QSortThenBy> {
  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      thenByBalanceAfter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balanceAfter', Sort.asc);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      thenByBalanceAfterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balanceAfter', Sort.desc);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      thenByMetadata() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadata', Sort.asc);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      thenByMetadataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadata', Sort.desc);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      thenBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      thenBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension BioCoinTransactionQueryWhereDistinct
    on QueryBuilder<BioCoinTransaction, BioCoinTransaction, QDistinct> {
  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QDistinct>
      distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QDistinct>
      distinctByBalanceAfter() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'balanceAfter');
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QDistinct>
      distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QDistinct>
      distinctByMetadata({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'metadata', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QDistinct>
      distinctBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'source');
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QDistinct>
      distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }

  QueryBuilder<BioCoinTransaction, BioCoinTransaction, QDistinct>
      distinctByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId');
    });
  }
}

extension BioCoinTransactionQueryProperty
    on QueryBuilder<BioCoinTransaction, BioCoinTransaction, QQueryProperty> {
  QueryBuilder<BioCoinTransaction, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BioCoinTransaction, int, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<BioCoinTransaction, int, QQueryOperations>
      balanceAfterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'balanceAfter');
    });
  }

  QueryBuilder<BioCoinTransaction, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<BioCoinTransaction, String, QQueryOperations>
      descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<BioCoinTransaction, String?, QQueryOperations>
      metadataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'metadata');
    });
  }

  QueryBuilder<BioCoinTransaction, TransactionSource, QQueryOperations>
      sourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'source');
    });
  }

  QueryBuilder<BioCoinTransaction, TransactionType, QQueryOperations>
      typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<BioCoinTransaction, int, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBioCoinConfigCollection on Isar {
  IsarCollection<BioCoinConfig> get bioCoinConfigs => this.collection();
}

const BioCoinConfigSchema = CollectionSchema(
  name: r'BioCoinConfig',
  id: -6349836198892081264,
  properties: {
    r'coinsPerCodingExercise': PropertySchema(
      id: 0,
      name: r'coinsPerCodingExercise',
      type: IsarType.long,
    ),
    r'coinsPerHealthyMeal': PropertySchema(
      id: 1,
      name: r'coinsPerHealthyMeal',
      type: IsarType.long,
    ),
    r'coinsPerMathProblem': PropertySchema(
      id: 2,
      name: r'coinsPerMathProblem',
      type: IsarType.long,
    ),
    r'coinsPerMinute': PropertySchema(
      id: 3,
      name: r'coinsPerMinute',
      type: IsarType.long,
    ),
    r'coinsPerPuzzle': PropertySchema(
      id: 4,
      name: r'coinsPerPuzzle',
      type: IsarType.long,
    ),
    r'coinsPerReadingQuiz': PropertySchema(
      id: 5,
      name: r'coinsPerReadingQuiz',
      type: IsarType.long,
    ),
    r'coinsPerThousandSteps': PropertySchema(
      id: 6,
      name: r'coinsPerThousandSteps',
      type: IsarType.long,
    ),
    r'currentStreakDays': PropertySchema(
      id: 7,
      name: r'currentStreakDays',
      type: IsarType.long,
    ),
    r'lastActivityDate': PropertySchema(
      id: 8,
      name: r'lastActivityDate',
      type: IsarType.dateTime,
    ),
    r'streakMultiplier': PropertySchema(
      id: 9,
      name: r'streakMultiplier',
      type: IsarType.double,
    )
  },
  estimateSize: _bioCoinConfigEstimateSize,
  serialize: _bioCoinConfigSerialize,
  deserialize: _bioCoinConfigDeserialize,
  deserializeProp: _bioCoinConfigDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _bioCoinConfigGetId,
  getLinks: _bioCoinConfigGetLinks,
  attach: _bioCoinConfigAttach,
  version: '3.1.0+1',
);

int _bioCoinConfigEstimateSize(
  BioCoinConfig object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _bioCoinConfigSerialize(
  BioCoinConfig object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.coinsPerCodingExercise);
  writer.writeLong(offsets[1], object.coinsPerHealthyMeal);
  writer.writeLong(offsets[2], object.coinsPerMathProblem);
  writer.writeLong(offsets[3], object.coinsPerMinute);
  writer.writeLong(offsets[4], object.coinsPerPuzzle);
  writer.writeLong(offsets[5], object.coinsPerReadingQuiz);
  writer.writeLong(offsets[6], object.coinsPerThousandSteps);
  writer.writeLong(offsets[7], object.currentStreakDays);
  writer.writeDateTime(offsets[8], object.lastActivityDate);
  writer.writeDouble(offsets[9], object.streakMultiplier);
}

BioCoinConfig _bioCoinConfigDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BioCoinConfig();
  object.coinsPerCodingExercise = reader.readLong(offsets[0]);
  object.coinsPerHealthyMeal = reader.readLong(offsets[1]);
  object.coinsPerMathProblem = reader.readLong(offsets[2]);
  object.coinsPerMinute = reader.readLong(offsets[3]);
  object.coinsPerPuzzle = reader.readLong(offsets[4]);
  object.coinsPerReadingQuiz = reader.readLong(offsets[5]);
  object.coinsPerThousandSteps = reader.readLong(offsets[6]);
  object.currentStreakDays = reader.readLong(offsets[7]);
  object.id = id;
  object.lastActivityDate = reader.readDateTimeOrNull(offsets[8]);
  object.streakMultiplier = reader.readDouble(offsets[9]);
  return object;
}

P _bioCoinConfigDeserializeProp<P>(
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
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _bioCoinConfigGetId(BioCoinConfig object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _bioCoinConfigGetLinks(BioCoinConfig object) {
  return [];
}

void _bioCoinConfigAttach(
    IsarCollection<dynamic> col, Id id, BioCoinConfig object) {
  object.id = id;
}

extension BioCoinConfigQueryWhereSort
    on QueryBuilder<BioCoinConfig, BioCoinConfig, QWhere> {
  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BioCoinConfigQueryWhere
    on QueryBuilder<BioCoinConfig, BioCoinConfig, QWhereClause> {
  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterWhereClause> idBetween(
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
}

extension BioCoinConfigQueryFilter
    on QueryBuilder<BioCoinConfig, BioCoinConfig, QFilterCondition> {
  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      coinsPerCodingExerciseEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'coinsPerCodingExercise',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      coinsPerCodingExerciseGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'coinsPerCodingExercise',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      coinsPerCodingExerciseLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'coinsPerCodingExercise',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      coinsPerCodingExerciseBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'coinsPerCodingExercise',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      coinsPerHealthyMealEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'coinsPerHealthyMeal',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      coinsPerHealthyMealGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'coinsPerHealthyMeal',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      coinsPerHealthyMealLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'coinsPerHealthyMeal',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      coinsPerHealthyMealBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'coinsPerHealthyMeal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      coinsPerMathProblemEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'coinsPerMathProblem',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      coinsPerMathProblemGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'coinsPerMathProblem',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      coinsPerMathProblemLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'coinsPerMathProblem',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      coinsPerMathProblemBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'coinsPerMathProblem',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      coinsPerMinuteEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'coinsPerMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      coinsPerMinuteGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'coinsPerMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      coinsPerMinuteLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'coinsPerMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      coinsPerMinuteBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'coinsPerMinute',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      coinsPerPuzzleEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'coinsPerPuzzle',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      coinsPerPuzzleGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'coinsPerPuzzle',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      coinsPerPuzzleLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'coinsPerPuzzle',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      coinsPerPuzzleBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'coinsPerPuzzle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      coinsPerReadingQuizEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'coinsPerReadingQuiz',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      coinsPerReadingQuizGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'coinsPerReadingQuiz',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      coinsPerReadingQuizLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'coinsPerReadingQuiz',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      coinsPerReadingQuizBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'coinsPerReadingQuiz',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      coinsPerThousandStepsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'coinsPerThousandSteps',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      coinsPerThousandStepsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'coinsPerThousandSteps',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      coinsPerThousandStepsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'coinsPerThousandSteps',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      coinsPerThousandStepsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'coinsPerThousandSteps',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      currentStreakDaysEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentStreakDays',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      currentStreakDaysGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentStreakDays',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      currentStreakDaysLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentStreakDays',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      currentStreakDaysBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentStreakDays',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
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

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition> idBetween(
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

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      lastActivityDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastActivityDate',
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      lastActivityDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastActivityDate',
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      lastActivityDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastActivityDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      lastActivityDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastActivityDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      lastActivityDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastActivityDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      lastActivityDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastActivityDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      streakMultiplierEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'streakMultiplier',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      streakMultiplierGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'streakMultiplier',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      streakMultiplierLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'streakMultiplier',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterFilterCondition>
      streakMultiplierBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'streakMultiplier',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension BioCoinConfigQueryObject
    on QueryBuilder<BioCoinConfig, BioCoinConfig, QFilterCondition> {}

extension BioCoinConfigQueryLinks
    on QueryBuilder<BioCoinConfig, BioCoinConfig, QFilterCondition> {}

extension BioCoinConfigQuerySortBy
    on QueryBuilder<BioCoinConfig, BioCoinConfig, QSortBy> {
  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      sortByCoinsPerCodingExercise() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsPerCodingExercise', Sort.asc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      sortByCoinsPerCodingExerciseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsPerCodingExercise', Sort.desc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      sortByCoinsPerHealthyMeal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsPerHealthyMeal', Sort.asc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      sortByCoinsPerHealthyMealDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsPerHealthyMeal', Sort.desc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      sortByCoinsPerMathProblem() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsPerMathProblem', Sort.asc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      sortByCoinsPerMathProblemDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsPerMathProblem', Sort.desc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      sortByCoinsPerMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsPerMinute', Sort.asc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      sortByCoinsPerMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsPerMinute', Sort.desc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      sortByCoinsPerPuzzle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsPerPuzzle', Sort.asc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      sortByCoinsPerPuzzleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsPerPuzzle', Sort.desc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      sortByCoinsPerReadingQuiz() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsPerReadingQuiz', Sort.asc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      sortByCoinsPerReadingQuizDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsPerReadingQuiz', Sort.desc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      sortByCoinsPerThousandSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsPerThousandSteps', Sort.asc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      sortByCoinsPerThousandStepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsPerThousandSteps', Sort.desc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      sortByCurrentStreakDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreakDays', Sort.asc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      sortByCurrentStreakDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreakDays', Sort.desc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      sortByLastActivityDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastActivityDate', Sort.asc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      sortByLastActivityDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastActivityDate', Sort.desc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      sortByStreakMultiplier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streakMultiplier', Sort.asc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      sortByStreakMultiplierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streakMultiplier', Sort.desc);
    });
  }
}

extension BioCoinConfigQuerySortThenBy
    on QueryBuilder<BioCoinConfig, BioCoinConfig, QSortThenBy> {
  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      thenByCoinsPerCodingExercise() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsPerCodingExercise', Sort.asc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      thenByCoinsPerCodingExerciseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsPerCodingExercise', Sort.desc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      thenByCoinsPerHealthyMeal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsPerHealthyMeal', Sort.asc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      thenByCoinsPerHealthyMealDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsPerHealthyMeal', Sort.desc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      thenByCoinsPerMathProblem() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsPerMathProblem', Sort.asc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      thenByCoinsPerMathProblemDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsPerMathProblem', Sort.desc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      thenByCoinsPerMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsPerMinute', Sort.asc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      thenByCoinsPerMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsPerMinute', Sort.desc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      thenByCoinsPerPuzzle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsPerPuzzle', Sort.asc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      thenByCoinsPerPuzzleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsPerPuzzle', Sort.desc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      thenByCoinsPerReadingQuiz() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsPerReadingQuiz', Sort.asc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      thenByCoinsPerReadingQuizDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsPerReadingQuiz', Sort.desc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      thenByCoinsPerThousandSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsPerThousandSteps', Sort.asc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      thenByCoinsPerThousandStepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinsPerThousandSteps', Sort.desc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      thenByCurrentStreakDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreakDays', Sort.asc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      thenByCurrentStreakDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreakDays', Sort.desc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      thenByLastActivityDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastActivityDate', Sort.asc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      thenByLastActivityDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastActivityDate', Sort.desc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      thenByStreakMultiplier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streakMultiplier', Sort.asc);
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QAfterSortBy>
      thenByStreakMultiplierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streakMultiplier', Sort.desc);
    });
  }
}

extension BioCoinConfigQueryWhereDistinct
    on QueryBuilder<BioCoinConfig, BioCoinConfig, QDistinct> {
  QueryBuilder<BioCoinConfig, BioCoinConfig, QDistinct>
      distinctByCoinsPerCodingExercise() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'coinsPerCodingExercise');
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QDistinct>
      distinctByCoinsPerHealthyMeal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'coinsPerHealthyMeal');
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QDistinct>
      distinctByCoinsPerMathProblem() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'coinsPerMathProblem');
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QDistinct>
      distinctByCoinsPerMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'coinsPerMinute');
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QDistinct>
      distinctByCoinsPerPuzzle() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'coinsPerPuzzle');
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QDistinct>
      distinctByCoinsPerReadingQuiz() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'coinsPerReadingQuiz');
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QDistinct>
      distinctByCoinsPerThousandSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'coinsPerThousandSteps');
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QDistinct>
      distinctByCurrentStreakDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentStreakDays');
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QDistinct>
      distinctByLastActivityDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastActivityDate');
    });
  }

  QueryBuilder<BioCoinConfig, BioCoinConfig, QDistinct>
      distinctByStreakMultiplier() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'streakMultiplier');
    });
  }
}

extension BioCoinConfigQueryProperty
    on QueryBuilder<BioCoinConfig, BioCoinConfig, QQueryProperty> {
  QueryBuilder<BioCoinConfig, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BioCoinConfig, int, QQueryOperations>
      coinsPerCodingExerciseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coinsPerCodingExercise');
    });
  }

  QueryBuilder<BioCoinConfig, int, QQueryOperations>
      coinsPerHealthyMealProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coinsPerHealthyMeal');
    });
  }

  QueryBuilder<BioCoinConfig, int, QQueryOperations>
      coinsPerMathProblemProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coinsPerMathProblem');
    });
  }

  QueryBuilder<BioCoinConfig, int, QQueryOperations> coinsPerMinuteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coinsPerMinute');
    });
  }

  QueryBuilder<BioCoinConfig, int, QQueryOperations> coinsPerPuzzleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coinsPerPuzzle');
    });
  }

  QueryBuilder<BioCoinConfig, int, QQueryOperations>
      coinsPerReadingQuizProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coinsPerReadingQuiz');
    });
  }

  QueryBuilder<BioCoinConfig, int, QQueryOperations>
      coinsPerThousandStepsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coinsPerThousandSteps');
    });
  }

  QueryBuilder<BioCoinConfig, int, QQueryOperations>
      currentStreakDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentStreakDays');
    });
  }

  QueryBuilder<BioCoinConfig, DateTime?, QQueryOperations>
      lastActivityDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastActivityDate');
    });
  }

  QueryBuilder<BioCoinConfig, double, QQueryOperations>
      streakMultiplierProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'streakMultiplier');
    });
  }
}
