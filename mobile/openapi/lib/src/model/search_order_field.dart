//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'search_order_field.g.dart';

class SearchOrderField extends EnumClass {

  @BuiltValueEnumConst(wireName: r'fileCreatedAt')
  static const SearchOrderField fileCreatedAt = _$fileCreatedAt;
  @BuiltValueEnumConst(wireName: r'localDateTime')
  static const SearchOrderField localDateTime = _$localDateTime;
  @BuiltValueEnumConst(wireName: r'fileSizeInBytes')
  static const SearchOrderField fileSizeInBytes = _$fileSizeInBytes;
  @BuiltValueEnumConst(wireName: r'rating')
  static const SearchOrderField rating = _$rating;

  static Serializer<SearchOrderField> get serializer => _$searchOrderFieldSerializer;

  const SearchOrderField._(String name): super(name);

  static BuiltSet<SearchOrderField> get values => _$values;
  static SearchOrderField valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class SearchOrderFieldMixin = Object with _$SearchOrderFieldMixin;

