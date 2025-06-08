// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_impl.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPageModelCollection on Isar {
  IsarCollection<PageModel> get pageModels => this.collection();
}

const PageModelSchema = CollectionSchema(
  name: r'pdf_page',
  id: 1218244564669969734,
  properties: {
    r'full_text': PropertySchema(
      id: 0,
      name: r'full_text',
      type: IsarType.string,
    ),
    r'height': PropertySchema(id: 1, name: r'height', type: IsarType.long),
    r'page_index': PropertySchema(
      id: 2,
      name: r'page_index',
      type: IsarType.long,
    ),
    r'width': PropertySchema(id: 3, name: r'width', type: IsarType.long),
  },
  estimateSize: _pageModelEstimateSize,
  serialize: _pageModelSerialize,
  deserialize: _pageModelDeserialize,
  deserializeProp: _pageModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'layouts': LinkSchema(
      id: -916033694433650513,
      name: r'layouts',
      target: r'pdf_layout',
      single: false,
      linkName: r'page',
    ),
    r'pdf': LinkSchema(
      id: -8981500599912119256,
      name: r'pdf',
      target: r'pdf',
      single: true,
    ),
  },
  embeddedSchemas: {},
  getId: _pageModelGetId,
  getLinks: _pageModelGetLinks,
  attach: _pageModelAttach,
  version: '3.1.0+1',
);

int _pageModelEstimateSize(
  PageModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.fullText.length * 3;
  return bytesCount;
}

void _pageModelSerialize(
  PageModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.fullText);
  writer.writeLong(offsets[1], object.height);
  writer.writeLong(offsets[2], object.pageIndex);
  writer.writeLong(offsets[3], object.width);
}

PageModel _pageModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PageModel(
    fullText: reader.readString(offsets[0]),
    height: reader.readLong(offsets[1]),
    pageIndex: reader.readLong(offsets[2]),
    width: reader.readLong(offsets[3]),
  );
  object.id = id;
  return object;
}

P _pageModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _pageModelGetId(PageModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _pageModelGetLinks(PageModel object) {
  return [object.layouts, object.pdf];
}

void _pageModelAttach(IsarCollection<dynamic> col, Id id, PageModel object) {
  object.id = id;
  object.layouts.attach(
    col,
    col.isar.collection<LayoutModel>(),
    r'layouts',
    id,
  );
  object.pdf.attach(col, col.isar.collection<PDFModel>(), r'pdf', id);
}

extension PageModelQueryWhereSort
    on QueryBuilder<PageModel, PageModel, QWhere> {
  QueryBuilder<PageModel, PageModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PageModelQueryWhere
    on QueryBuilder<PageModel, PageModel, QWhereClause> {
  QueryBuilder<PageModel, PageModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<PageModel, PageModel, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterWhereClause> idBetween(
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

extension PageModelQueryFilter
    on QueryBuilder<PageModel, PageModel, QFilterCondition> {
  QueryBuilder<PageModel, PageModel, QAfterFilterCondition> fullTextEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'full_text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterFilterCondition> fullTextGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'full_text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterFilterCondition> fullTextLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'full_text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterFilterCondition> fullTextBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'full_text',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterFilterCondition> fullTextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'full_text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterFilterCondition> fullTextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'full_text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterFilterCondition> fullTextContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'full_text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterFilterCondition> fullTextMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'full_text',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterFilterCondition> fullTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'full_text', value: ''),
      );
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterFilterCondition>
  fullTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'full_text', value: ''),
      );
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterFilterCondition> heightEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'height', value: value),
      );
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterFilterCondition> heightGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'height',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterFilterCondition> heightLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'height',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterFilterCondition> heightBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'height',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<PageModel, PageModel, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<PageModel, PageModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<PageModel, PageModel, QAfterFilterCondition> pageIndexEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'page_index', value: value),
      );
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterFilterCondition>
  pageIndexGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'page_index',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterFilterCondition> pageIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'page_index',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterFilterCondition> pageIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'page_index',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterFilterCondition> widthEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'width', value: value),
      );
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterFilterCondition> widthGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'width',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterFilterCondition> widthLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'width',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterFilterCondition> widthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'width',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension PageModelQueryObject
    on QueryBuilder<PageModel, PageModel, QFilterCondition> {}

extension PageModelQueryLinks
    on QueryBuilder<PageModel, PageModel, QFilterCondition> {
  QueryBuilder<PageModel, PageModel, QAfterFilterCondition> layouts(
    FilterQuery<LayoutModel> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'layouts');
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterFilterCondition>
  layoutsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'layouts', length, true, length, true);
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterFilterCondition> layoutsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'layouts', 0, true, 0, true);
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterFilterCondition>
  layoutsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'layouts', 0, false, 999999, true);
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterFilterCondition>
  layoutsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'layouts', 0, true, length, include);
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterFilterCondition>
  layoutsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'layouts', length, include, 999999, true);
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterFilterCondition>
  layoutsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
        r'layouts',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterFilterCondition> pdf(
    FilterQuery<PDFModel> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'pdf');
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterFilterCondition> pdfIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pdf', 0, true, 0, true);
    });
  }
}

extension PageModelQuerySortBy on QueryBuilder<PageModel, PageModel, QSortBy> {
  QueryBuilder<PageModel, PageModel, QAfterSortBy> sortByFullText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'full_text', Sort.asc);
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterSortBy> sortByFullTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'full_text', Sort.desc);
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterSortBy> sortByHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.asc);
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterSortBy> sortByHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.desc);
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterSortBy> sortByPageIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'page_index', Sort.asc);
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterSortBy> sortByPageIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'page_index', Sort.desc);
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterSortBy> sortByWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.asc);
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterSortBy> sortByWidthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.desc);
    });
  }
}

extension PageModelQuerySortThenBy
    on QueryBuilder<PageModel, PageModel, QSortThenBy> {
  QueryBuilder<PageModel, PageModel, QAfterSortBy> thenByFullText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'full_text', Sort.asc);
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterSortBy> thenByFullTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'full_text', Sort.desc);
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterSortBy> thenByHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.asc);
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterSortBy> thenByHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.desc);
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterSortBy> thenByPageIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'page_index', Sort.asc);
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterSortBy> thenByPageIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'page_index', Sort.desc);
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterSortBy> thenByWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.asc);
    });
  }

  QueryBuilder<PageModel, PageModel, QAfterSortBy> thenByWidthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.desc);
    });
  }
}

extension PageModelQueryWhereDistinct
    on QueryBuilder<PageModel, PageModel, QDistinct> {
  QueryBuilder<PageModel, PageModel, QDistinct> distinctByFullText({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'full_text', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PageModel, PageModel, QDistinct> distinctByHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'height');
    });
  }

  QueryBuilder<PageModel, PageModel, QDistinct> distinctByPageIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'page_index');
    });
  }

  QueryBuilder<PageModel, PageModel, QDistinct> distinctByWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'width');
    });
  }
}

extension PageModelQueryProperty
    on QueryBuilder<PageModel, PageModel, QQueryProperty> {
  QueryBuilder<PageModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PageModel, String, QQueryOperations> fullTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'full_text');
    });
  }

  QueryBuilder<PageModel, int, QQueryOperations> heightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'height');
    });
  }

  QueryBuilder<PageModel, int, QQueryOperations> pageIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'page_index');
    });
  }

  QueryBuilder<PageModel, int, QQueryOperations> widthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'width');
    });
  }
}
