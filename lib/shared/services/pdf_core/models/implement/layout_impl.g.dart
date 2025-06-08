// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layout_impl.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLayoutModelCollection on Isar {
  IsarCollection<LayoutModel> get layoutModels => this.collection();
}

const LayoutModelSchema = CollectionSchema(
  name: r'pdf_layout',
  id: 5438317236946775742,
  properties: {
    r'caption': PropertySchema(id: 0, name: r'caption', type: IsarType.string),
    r'content': PropertySchema(id: 1, name: r'content', type: IsarType.string),
    r'figureId': PropertySchema(
      id: 2,
      name: r'figureId',
      type: IsarType.string,
    ),
    r'figureNumber': PropertySchema(
      id: 3,
      name: r'figureNumber',
      type: IsarType.long,
    ),
    r'height': PropertySchema(id: 4, name: r'height', type: IsarType.double),
    r'latex': PropertySchema(id: 5, name: r'latex', type: IsarType.string),
    r'left': PropertySchema(id: 6, name: r'left', type: IsarType.double),
    r'referenceText': PropertySchema(
      id: 7,
      name: r'referenceText',
      type: IsarType.string,
    ),
    r'referencedFigureId': PropertySchema(
      id: 8,
      name: r'referencedFigureId',
      type: IsarType.string,
    ),
    r'text': PropertySchema(id: 9, name: r'text', type: IsarType.string),
    r'top': PropertySchema(id: 10, name: r'top', type: IsarType.double),
    r'type': PropertySchema(
      id: 11,
      name: r'type',
      type: IsarType.byte,
      enumMap: _LayoutModeltypeEnumValueMap,
    ),
    r'width': PropertySchema(id: 12, name: r'width', type: IsarType.double),
  },
  estimateSize: _layoutModelEstimateSize,
  serialize: _layoutModelSerialize,
  deserialize: _layoutModelDeserialize,
  deserializeProp: _layoutModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'page': LinkSchema(
      id: 5970635397071008796,
      name: r'page',
      target: r'pdf_page',
      single: true,
    ),
  },
  embeddedSchemas: {},
  getId: _layoutModelGetId,
  getLinks: _layoutModelGetLinks,
  attach: _layoutModelAttach,
  version: '3.1.0+1',
);

int _layoutModelEstimateSize(
  LayoutModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.caption;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.content.length * 3;
  {
    final value = object.figureId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.latex;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.referenceText;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.referencedFigureId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.text;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _layoutModelSerialize(
  LayoutModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.caption);
  writer.writeString(offsets[1], object.content);
  writer.writeString(offsets[2], object.figureId);
  writer.writeLong(offsets[3], object.figureNumber);
  writer.writeDouble(offsets[4], object.height);
  writer.writeString(offsets[5], object.latex);
  writer.writeDouble(offsets[6], object.left);
  writer.writeString(offsets[7], object.referenceText);
  writer.writeString(offsets[8], object.referencedFigureId);
  writer.writeString(offsets[9], object.text);
  writer.writeDouble(offsets[10], object.top);
  writer.writeByte(offsets[11], object.type.index);
  writer.writeDouble(offsets[12], object.width);
}

LayoutModel _layoutModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LayoutModel(
    caption: reader.readStringOrNull(offsets[0]),
    content: reader.readString(offsets[1]),
    figureId: reader.readStringOrNull(offsets[2]),
    figureNumber: reader.readLongOrNull(offsets[3]),
    height: reader.readDouble(offsets[4]),
    latex: reader.readStringOrNull(offsets[5]),
    left: reader.readDouble(offsets[6]),
    referenceText: reader.readStringOrNull(offsets[7]),
    referencedFigureId: reader.readStringOrNull(offsets[8]),
    text: reader.readStringOrNull(offsets[9]),
    top: reader.readDouble(offsets[10]),
    type:
        _LayoutModeltypeValueEnumMap[reader.readByteOrNull(offsets[11])] ??
        LayoutType.formula,
    width: reader.readDouble(offsets[12]),
  );
  object.id = id;
  return object;
}

P _layoutModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readDouble(offset)) as P;
    case 11:
      return (_LayoutModeltypeValueEnumMap[reader.readByteOrNull(offset)] ??
              LayoutType.formula)
          as P;
    case 12:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _LayoutModeltypeEnumValueMap = {
  'formula': 0,
  'text': 1,
  'number': 2,
  'header': 3,
  'algorithm': 4,
  'figure': 5,
  'figureReference': 6,
};
const _LayoutModeltypeValueEnumMap = {
  0: LayoutType.formula,
  1: LayoutType.text,
  2: LayoutType.number,
  3: LayoutType.header,
  4: LayoutType.algorithm,
  5: LayoutType.figure,
  6: LayoutType.figureReference,
};

Id _layoutModelGetId(LayoutModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _layoutModelGetLinks(LayoutModel object) {
  return [object.page];
}

void _layoutModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  LayoutModel object,
) {
  object.id = id;
  object.page.attach(col, col.isar.collection<PageModel>(), r'page', id);
}

extension LayoutModelQueryWhereSort
    on QueryBuilder<LayoutModel, LayoutModel, QWhere> {
  QueryBuilder<LayoutModel, LayoutModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LayoutModelQueryWhere
    on QueryBuilder<LayoutModel, LayoutModel, QWhereClause> {
  QueryBuilder<LayoutModel, LayoutModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
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

  QueryBuilder<LayoutModel, LayoutModel, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension LayoutModelQueryFilter
    on QueryBuilder<LayoutModel, LayoutModel, QFilterCondition> {
  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  captionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'caption'),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  captionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'caption'),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> captionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'caption',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  captionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'caption',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> captionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'caption',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> captionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'caption',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  captionStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'caption',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> captionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'caption',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> captionContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'caption',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> captionMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'caption',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  captionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'caption', value: ''),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  captionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'caption', value: ''),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> contentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'content',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  contentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'content',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> contentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'content',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> contentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'content',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  contentStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'content',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> contentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'content',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> contentContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'content',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> contentMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'content',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  contentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'content', value: ''),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  contentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'content', value: ''),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  figureIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'figureId'),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  figureIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'figureId'),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> figureIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'figureId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  figureIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'figureId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  figureIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'figureId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> figureIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'figureId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  figureIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'figureId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  figureIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'figureId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  figureIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'figureId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> figureIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'figureId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  figureIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'figureId', value: ''),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  figureIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'figureId', value: ''),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  figureNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'figureNumber'),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  figureNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'figureNumber'),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  figureNumberEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'figureNumber', value: value),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  figureNumberGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'figureNumber',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  figureNumberLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'figureNumber',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  figureNumberBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'figureNumber',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> heightEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'height',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  heightGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'height',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> heightLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'height',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> heightBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'height',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> latexIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'latex'),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  latexIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'latex'),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> latexEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'latex',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  latexGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'latex',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> latexLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'latex',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> latexBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'latex',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> latexStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'latex',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> latexEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'latex',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> latexContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'latex',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> latexMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'latex',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> latexIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'latex', value: ''),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  latexIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'latex', value: ''),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> leftEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'left',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> leftGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'left',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> leftLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'left',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> leftBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'left',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  referenceTextIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'referenceText'),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  referenceTextIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'referenceText'),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  referenceTextEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'referenceText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  referenceTextGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'referenceText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  referenceTextLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'referenceText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  referenceTextBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'referenceText',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  referenceTextStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'referenceText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  referenceTextEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'referenceText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  referenceTextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'referenceText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  referenceTextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'referenceText',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  referenceTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'referenceText', value: ''),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  referenceTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'referenceText', value: ''),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  referencedFigureIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'referencedFigureId'),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  referencedFigureIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'referencedFigureId'),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  referencedFigureIdEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'referencedFigureId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  referencedFigureIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'referencedFigureId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  referencedFigureIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'referencedFigureId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  referencedFigureIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'referencedFigureId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  referencedFigureIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'referencedFigureId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  referencedFigureIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'referencedFigureId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  referencedFigureIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'referencedFigureId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  referencedFigureIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'referencedFigureId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  referencedFigureIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'referencedFigureId', value: ''),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  referencedFigureIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'referencedFigureId', value: ''),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> textIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'text'),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  textIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'text'),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> textEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> textGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> textLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> textBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'text',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> textStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> textEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> textContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> textMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'text',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'text', value: ''),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'text', value: ''),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> topEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'top',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> topGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'top',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> topLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'top',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> topBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'top',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> typeEqualTo(
    LayoutType value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'type', value: value),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> typeGreaterThan(
    LayoutType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'type',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> typeLessThan(
    LayoutType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'type',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> typeBetween(
    LayoutType lower,
    LayoutType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'type',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> widthEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'width',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition>
  widthGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'width',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> widthLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'width',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> widthBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'width',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }
}

extension LayoutModelQueryObject
    on QueryBuilder<LayoutModel, LayoutModel, QFilterCondition> {}

extension LayoutModelQueryLinks
    on QueryBuilder<LayoutModel, LayoutModel, QFilterCondition> {
  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> page(
    FilterQuery<PageModel> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'page');
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterFilterCondition> pageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'page', 0, true, 0, true);
    });
  }
}

extension LayoutModelQuerySortBy
    on QueryBuilder<LayoutModel, LayoutModel, QSortBy> {
  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> sortByCaption() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'caption', Sort.asc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> sortByCaptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'caption', Sort.desc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> sortByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> sortByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> sortByFigureId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'figureId', Sort.asc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> sortByFigureIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'figureId', Sort.desc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> sortByFigureNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'figureNumber', Sort.asc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy>
  sortByFigureNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'figureNumber', Sort.desc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> sortByHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.asc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> sortByHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.desc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> sortByLatex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latex', Sort.asc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> sortByLatexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latex', Sort.desc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> sortByLeft() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'left', Sort.asc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> sortByLeftDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'left', Sort.desc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> sortByReferenceText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceText', Sort.asc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy>
  sortByReferenceTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceText', Sort.desc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy>
  sortByReferencedFigureId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referencedFigureId', Sort.asc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy>
  sortByReferencedFigureIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referencedFigureId', Sort.desc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> sortByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> sortByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> sortByTop() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'top', Sort.asc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> sortByTopDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'top', Sort.desc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> sortByWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.asc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> sortByWidthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.desc);
    });
  }
}

extension LayoutModelQuerySortThenBy
    on QueryBuilder<LayoutModel, LayoutModel, QSortThenBy> {
  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> thenByCaption() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'caption', Sort.asc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> thenByCaptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'caption', Sort.desc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> thenByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> thenByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> thenByFigureId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'figureId', Sort.asc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> thenByFigureIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'figureId', Sort.desc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> thenByFigureNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'figureNumber', Sort.asc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy>
  thenByFigureNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'figureNumber', Sort.desc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> thenByHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.asc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> thenByHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.desc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> thenByLatex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latex', Sort.asc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> thenByLatexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latex', Sort.desc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> thenByLeft() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'left', Sort.asc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> thenByLeftDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'left', Sort.desc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> thenByReferenceText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceText', Sort.asc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy>
  thenByReferenceTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceText', Sort.desc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy>
  thenByReferencedFigureId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referencedFigureId', Sort.asc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy>
  thenByReferencedFigureIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referencedFigureId', Sort.desc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> thenByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> thenByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> thenByTop() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'top', Sort.asc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> thenByTopDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'top', Sort.desc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> thenByWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.asc);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QAfterSortBy> thenByWidthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.desc);
    });
  }
}

extension LayoutModelQueryWhereDistinct
    on QueryBuilder<LayoutModel, LayoutModel, QDistinct> {
  QueryBuilder<LayoutModel, LayoutModel, QDistinct> distinctByCaption({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'caption', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QDistinct> distinctByContent({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QDistinct> distinctByFigureId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'figureId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QDistinct> distinctByFigureNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'figureNumber');
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QDistinct> distinctByHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'height');
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QDistinct> distinctByLatex({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'latex', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QDistinct> distinctByLeft() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'left');
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QDistinct> distinctByReferenceText({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'referenceText',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QDistinct>
  distinctByReferencedFigureId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'referencedFigureId',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QDistinct> distinctByText({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'text', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QDistinct> distinctByTop() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'top');
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }

  QueryBuilder<LayoutModel, LayoutModel, QDistinct> distinctByWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'width');
    });
  }
}

extension LayoutModelQueryProperty
    on QueryBuilder<LayoutModel, LayoutModel, QQueryProperty> {
  QueryBuilder<LayoutModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LayoutModel, String?, QQueryOperations> captionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'caption');
    });
  }

  QueryBuilder<LayoutModel, String, QQueryOperations> contentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content');
    });
  }

  QueryBuilder<LayoutModel, String?, QQueryOperations> figureIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'figureId');
    });
  }

  QueryBuilder<LayoutModel, int?, QQueryOperations> figureNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'figureNumber');
    });
  }

  QueryBuilder<LayoutModel, double, QQueryOperations> heightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'height');
    });
  }

  QueryBuilder<LayoutModel, String?, QQueryOperations> latexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'latex');
    });
  }

  QueryBuilder<LayoutModel, double, QQueryOperations> leftProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'left');
    });
  }

  QueryBuilder<LayoutModel, String?, QQueryOperations> referenceTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'referenceText');
    });
  }

  QueryBuilder<LayoutModel, String?, QQueryOperations>
  referencedFigureIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'referencedFigureId');
    });
  }

  QueryBuilder<LayoutModel, String?, QQueryOperations> textProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'text');
    });
  }

  QueryBuilder<LayoutModel, double, QQueryOperations> topProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'top');
    });
  }

  QueryBuilder<LayoutModel, LayoutType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<LayoutModel, double, QQueryOperations> widthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'width');
    });
  }
}
