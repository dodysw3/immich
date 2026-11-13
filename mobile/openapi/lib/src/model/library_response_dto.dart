//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'library_response_dto.g.dart';

/// LibraryResponseDto
///
/// Properties:
/// * [assetCount] - Number of assets
/// * [createdAt] - Creation date
/// * [exclusionPatterns] - Exclusion patterns
/// * [id] - Library ID
/// * [importPaths] - Import paths
/// * [name] - Library name
/// * [ownerId] - Owner user ID
/// * [refreshedAt] - Last refresh date
/// * [updatedAt] - Last update date
@BuiltValue()
abstract class LibraryResponseDto implements Built<LibraryResponseDto, LibraryResponseDtoBuilder> {
  /// Number of assets
  @BuiltValueField(wireName: r'assetCount')
  int get assetCount;

  /// Creation date
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  /// Exclusion patterns
  @BuiltValueField(wireName: r'exclusionPatterns')
  BuiltList<String> get exclusionPatterns;

  /// Library ID
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Import paths
  @BuiltValueField(wireName: r'importPaths')
  BuiltList<String> get importPaths;

  /// Library name
  @BuiltValueField(wireName: r'name')
  String get name;

  /// Owner user ID
  @BuiltValueField(wireName: r'ownerId')
  String get ownerId;

  /// Last refresh date
  @BuiltValueField(wireName: r'refreshedAt')
  DateTime? get refreshedAt;

  /// Last update date
  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  LibraryResponseDto._();

  factory LibraryResponseDto([void updates(LibraryResponseDtoBuilder b)]) = _$LibraryResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LibraryResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LibraryResponseDto> get serializer => _$LibraryResponseDtoSerializer();
}

class _$LibraryResponseDtoSerializer implements PrimitiveSerializer<LibraryResponseDto> {
  @override
  final Iterable<Type> types = const [LibraryResponseDto, _$LibraryResponseDto];

  @override
  final String wireName = r'LibraryResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LibraryResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assetCount';
    yield serializers.serialize(
      object.assetCount,
      specifiedType: const FullType(int),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'exclusionPatterns';
    yield serializers.serialize(
      object.exclusionPatterns,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'importPaths';
    yield serializers.serialize(
      object.importPaths,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'ownerId';
    yield serializers.serialize(
      object.ownerId,
      specifiedType: const FullType(String),
    );
    yield r'refreshedAt';
    yield object.refreshedAt == null ? null : serializers.serialize(
      object.refreshedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LibraryResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LibraryResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'assetCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.assetCount = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'exclusionPatterns':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.exclusionPatterns.replace(valueDes);
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'importPaths':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.importPaths.replace(valueDes);
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'ownerId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ownerId = valueDes;
          break;
        case r'refreshedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.refreshedAt = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LibraryResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LibraryResponseDtoBuilder();
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


