//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/asset_file_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_file_response_dto.g.dart';

/// AssetFileResponseDto
///
/// Properties:
/// * [createdAt] - Creation date
/// * [id] - Asset file ID
/// * [isEdited] - The file was generated from an edit
/// * [isProgressive] - The file is a progressively encoded JPEG
/// * [isTransparent] - The file is transparent
/// * [path] - File path
/// * [type] 
/// * [updatedAt] - Update date
@BuiltValue()
abstract class AssetFileResponseDto implements Built<AssetFileResponseDto, AssetFileResponseDtoBuilder> {
  /// Creation date
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  /// Asset file ID
  @BuiltValueField(wireName: r'id')
  String get id;

  /// The file was generated from an edit
  @BuiltValueField(wireName: r'isEdited')
  bool get isEdited;

  /// The file is a progressively encoded JPEG
  @BuiltValueField(wireName: r'isProgressive')
  bool get isProgressive;

  /// The file is transparent
  @BuiltValueField(wireName: r'isTransparent')
  bool get isTransparent;

  /// File path
  @BuiltValueField(wireName: r'path')
  String get path;

  @BuiltValueField(wireName: r'type')
  AssetFileType get type;
  // enum typeEnum {  fullsize,  preview,  thumbnail,  sidecar,  encoded_video,  };

  /// Update date
  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  AssetFileResponseDto._();

  factory AssetFileResponseDto([void updates(AssetFileResponseDtoBuilder b)]) = _$AssetFileResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssetFileResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssetFileResponseDto> get serializer => _$AssetFileResponseDtoSerializer();
}

class _$AssetFileResponseDtoSerializer implements PrimitiveSerializer<AssetFileResponseDto> {
  @override
  final Iterable<Type> types = const [AssetFileResponseDto, _$AssetFileResponseDto];

  @override
  final String wireName = r'AssetFileResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssetFileResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'isEdited';
    yield serializers.serialize(
      object.isEdited,
      specifiedType: const FullType(bool),
    );
    yield r'isProgressive';
    yield serializers.serialize(
      object.isProgressive,
      specifiedType: const FullType(bool),
    );
    yield r'isTransparent';
    yield serializers.serialize(
      object.isTransparent,
      specifiedType: const FullType(bool),
    );
    yield r'path';
    yield serializers.serialize(
      object.path,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(AssetFileType),
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
    AssetFileResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AssetFileResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'isEdited':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isEdited = valueDes;
          break;
        case r'isProgressive':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isProgressive = valueDes;
          break;
        case r'isTransparent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isTransparent = valueDes;
          break;
        case r'path':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.path = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AssetFileType),
          ) as AssetFileType;
          result.type = valueDes;
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
  AssetFileResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssetFileResponseDtoBuilder();
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


