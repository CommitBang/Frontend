// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pdf_impl.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPDFModelCollection on Isar {
  IsarCollection<PDFModel> get pDFModels => this.collection();
}

const PDFModelSchema = CollectionSchema(
  name: r'pdf',
  id: 570058889926642554,
  properties: {
    r'created_at': PropertySchema(
      id: 0,
      name: r'created_at',
      type: IsarType.dateTime,
    ),
    r'current_page': PropertySchema(
      id: 1,
      name: r'current_page',
      type: IsarType.long,
    ),
    r'name': PropertySchema(
      id: 2,
      name: r'name',
      type: IsarType.string,
    ),
    r'path': PropertySchema(
      id: 3,
      name: r'path',
      type: IsarType.string,
    ),
    r'pdf_status': PropertySchema(
      id: 4,
      name: r'pdf_status',
      type: IsarType.byte,
      enumMap: _PDFModelstatusEnumValueMap,
    ),
    r'thumbnail': PropertySchema(
      id: 5,
      name: r'thumbnail',
      type: IsarType.longList,
    ),
    r'total_pages': PropertySchema(
      id: 6,
      name: r'total_pages',
      type: IsarType.long,
    ),
    r'updated_at': PropertySchema(
      id: 7,
      name: r'updated_at',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _pDFModelEstimateSize,
  serialize: _pDFModelSerialize,
  deserialize: _pDFModelDeserialize,
  deserializeProp: _pDFModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'pages': LinkSchema(
      id: 8977893419427002576,
      name: r'pages',
      target: r'pdf_page',
      single: false,
      linkName: r'pdf',
    )
  },
  embeddedSchemas: {},
  getId: _pDFModelGetId,
  getLinks: _pDFModelGetLinks,
  attach: _pDFModelAttach,
  version: '3.1.0+1',
);

int _pDFModelEstimateSize(
  PDFModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.path.length * 3;
  {
    final value = object.thumbnail;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  return bytesCount;
}

void _pDFModelSerialize(
  PDFModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeLong(offsets[1], object.currentPage);
  writer.writeString(offsets[2], object.name);
  writer.writeString(offsets[3], object.path);
  writer.writeByte(offsets[4], object.status.index);
  writer.writeLongList(offsets[5], object.thumbnail);
  writer.writeLong(offsets[6], object.totalPages);
  writer.writeDateTime(offsets[7], object.updatedAt);
}

PDFModel _pDFModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PDFModel(
    createdAt: reader.readDateTime(offsets[0]),
    currentPage: reader.readLong(offsets[1]),
    name: reader.readString(offsets[2]),
    path: reader.readString(offsets[3]),
    status: _PDFModelstatusValueEnumMap[reader.readByteOrNull(offsets[4])] ??
        PDFStatus.pending,
    thumbnail: reader.readLongList(offsets[5]),
    totalPages: reader.readLong(offsets[6]),
  );
  object.id = id;
  return object;
}

P _pDFModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (_PDFModelstatusValueEnumMap[reader.readByteOrNull(offset)] ??
          PDFStatus.pending) as P;
    case 5:
      return (reader.readLongList(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _PDFModelstatusEnumValueMap = {
  'pending': 0,
  'processing': 1,
  'completed': 2,
  'failed': 3,
};
const _PDFModelstatusValueEnumMap = {
  0: PDFStatus.pending,
  1: PDFStatus.processing,
  2: PDFStatus.completed,
  3: PDFStatus.failed,
};

Id _pDFModelGetId(PDFModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _pDFModelGetLinks(PDFModel object) {
  return [object.pages];
}

void _pDFModelAttach(IsarCollection<dynamic> col, Id id, PDFModel object) {
  object.id = id;
  object.pages.attach(col, col.isar.collection<PageModel>(), r'pages', id);
}

extension PDFModelQueryWhereSort on QueryBuilder<PDFModel, PDFModel, QWhere> {
  QueryBuilder<PDFModel, PDFModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PDFModelQueryWhere on QueryBuilder<PDFModel, PDFModel, QWhereClause> {
  QueryBuilder<PDFModel, PDFModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<PDFModel, PDFModel, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterWhereClause> idBetween(
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

extension PDFModelQueryFilter
    on QueryBuilder<PDFModel, PDFModel, QFilterCondition> {
  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'created_at',
        value: value,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'created_at',
        value: value,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'created_at',
        value: value,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'created_at',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> currentPageEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'current_page',
        value: value,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition>
      currentPageGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'current_page',
        value: value,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> currentPageLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'current_page',
        value: value,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> currentPageBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'current_page',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> pathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> pathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> pathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> pathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'path',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> pathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> pathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> pathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> pathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'path',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> pathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'path',
        value: '',
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> pathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'path',
        value: '',
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> statusEqualTo(
      PDFStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pdf_status',
        value: value,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> statusGreaterThan(
    PDFStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pdf_status',
        value: value,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> statusLessThan(
    PDFStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pdf_status',
        value: value,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> statusBetween(
    PDFStatus lower,
    PDFStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pdf_status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> thumbnailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'thumbnail',
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> thumbnailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'thumbnail',
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition>
      thumbnailElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'thumbnail',
        value: value,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition>
      thumbnailElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'thumbnail',
        value: value,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition>
      thumbnailElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'thumbnail',
        value: value,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition>
      thumbnailElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'thumbnail',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition>
      thumbnailLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'thumbnail',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> thumbnailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'thumbnail',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition>
      thumbnailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'thumbnail',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition>
      thumbnailLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'thumbnail',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition>
      thumbnailLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'thumbnail',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition>
      thumbnailLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'thumbnail',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> totalPagesEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'total_pages',
        value: value,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> totalPagesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'total_pages',
        value: value,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> totalPagesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'total_pages',
        value: value,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> totalPagesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'total_pages',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> updatedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updated_at',
        value: value,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updated_at',
        value: value,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updated_at',
        value: value,
      ));
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updated_at',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PDFModelQueryObject
    on QueryBuilder<PDFModel, PDFModel, QFilterCondition> {}

extension PDFModelQueryLinks
    on QueryBuilder<PDFModel, PDFModel, QFilterCondition> {
  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> pages(
      FilterQuery<PageModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'pages');
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> pagesLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pages', length, true, length, true);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> pagesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pages', 0, true, 0, true);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> pagesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pages', 0, false, 999999, true);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> pagesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pages', 0, true, length, include);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition>
      pagesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pages', length, include, 999999, true);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterFilterCondition> pagesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'pages', lower, includeLower, upper, includeUpper);
    });
  }
}

extension PDFModelQuerySortBy on QueryBuilder<PDFModel, PDFModel, QSortBy> {
  QueryBuilder<PDFModel, PDFModel, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'created_at', Sort.asc);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'created_at', Sort.desc);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterSortBy> sortByCurrentPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'current_page', Sort.asc);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterSortBy> sortByCurrentPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'current_page', Sort.desc);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterSortBy> sortByPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.asc);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterSortBy> sortByPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.desc);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pdf_status', Sort.asc);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pdf_status', Sort.desc);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterSortBy> sortByTotalPages() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total_pages', Sort.asc);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterSortBy> sortByTotalPagesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total_pages', Sort.desc);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updated_at', Sort.asc);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updated_at', Sort.desc);
    });
  }
}

extension PDFModelQuerySortThenBy
    on QueryBuilder<PDFModel, PDFModel, QSortThenBy> {
  QueryBuilder<PDFModel, PDFModel, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'created_at', Sort.asc);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'created_at', Sort.desc);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterSortBy> thenByCurrentPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'current_page', Sort.asc);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterSortBy> thenByCurrentPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'current_page', Sort.desc);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterSortBy> thenByPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.asc);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterSortBy> thenByPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.desc);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pdf_status', Sort.asc);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pdf_status', Sort.desc);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterSortBy> thenByTotalPages() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total_pages', Sort.asc);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterSortBy> thenByTotalPagesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total_pages', Sort.desc);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updated_at', Sort.asc);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updated_at', Sort.desc);
    });
  }
}

extension PDFModelQueryWhereDistinct
    on QueryBuilder<PDFModel, PDFModel, QDistinct> {
  QueryBuilder<PDFModel, PDFModel, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'created_at');
    });
  }

  QueryBuilder<PDFModel, PDFModel, QDistinct> distinctByCurrentPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'current_page');
    });
  }

  QueryBuilder<PDFModel, PDFModel, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QDistinct> distinctByPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'path', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PDFModel, PDFModel, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pdf_status');
    });
  }

  QueryBuilder<PDFModel, PDFModel, QDistinct> distinctByThumbnail() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'thumbnail');
    });
  }

  QueryBuilder<PDFModel, PDFModel, QDistinct> distinctByTotalPages() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'total_pages');
    });
  }

  QueryBuilder<PDFModel, PDFModel, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updated_at');
    });
  }
}

extension PDFModelQueryProperty
    on QueryBuilder<PDFModel, PDFModel, QQueryProperty> {
  QueryBuilder<PDFModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PDFModel, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'created_at');
    });
  }

  QueryBuilder<PDFModel, int, QQueryOperations> currentPageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'current_page');
    });
  }

  QueryBuilder<PDFModel, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<PDFModel, String, QQueryOperations> pathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'path');
    });
  }

  QueryBuilder<PDFModel, PDFStatus, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pdf_status');
    });
  }

  QueryBuilder<PDFModel, List<int>?, QQueryOperations> thumbnailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'thumbnail');
    });
  }

  QueryBuilder<PDFModel, int, QQueryOperations> totalPagesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'total_pages');
    });
  }

  QueryBuilder<PDFModel, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updated_at');
    });
  }
}
