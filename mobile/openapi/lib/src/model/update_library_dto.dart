//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_library_dto.g.dart';

/// UpdateLibraryDto
///
/// Properties:
/// * [exclusionPatterns] - Exclusion patterns (max 128)
/// * [importPaths] - Import paths (max 128)
/// * [name] - Library name
@BuiltValue()
abstract class UpdateLibraryDto implements Built<UpdateLibraryDto, UpdateLibraryDtoBuilder> {
  /// Exclusion patterns (max 128)
  @BuiltValueField(wireName: r'exclusionPatterns')
  BuiltList<String>? get exclusionPatterns;

  /// Import paths (max 128)
  @BuiltValueField(wireName: r'importPaths')
  BuiltList<String>? get importPaths;

  /// Library name
  @BuiltValueField(wireName: r'name')
  String? get name;

  UpdateLibraryDto._();

  factory UpdateLibraryDto([void updates(UpdateLibraryDtoBuilder b)]) = _$UpdateLibraryDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateLibraryDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateLibraryDto> get serializer => _$UpdateLibraryDtoSerializer();
}

class _$UpdateLibraryDtoSerializer implements PrimitiveSerializer<UpdateLibraryDto> {
  @override
  final Iterable<Type> types = const [UpdateLibraryDto, _$UpdateLibraryDto];

  @override
  final String wireName = r'UpdateLibraryDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateLibraryDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.exclusionPatterns != null) {
      yield r'exclusionPatterns';
      yield serializers.serialize(
        object.exclusionPatterns,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.importPaths != null) {
      yield r'importPaths';
      yield serializers.serialize(
        object.importPaths,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateLibraryDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateLibraryDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'exclusionPatterns':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.exclusionPatterns.replace(valueDes);
          break;
        case r'importPaths':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.importPaths.replace(valueDes);
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateLibraryDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateLibraryDtoBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


