//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_face_create_dto.g.dart';

/// AssetFaceCreateDto
///
/// Properties:
/// * [assetId] - Asset ID
/// * [height] - Face bounding box height
/// * [imageHeight] - Image height in pixels
/// * [imageWidth] - Image width in pixels
/// * [personId] - Person ID
/// * [userId] - User ID
/// * [width] - Face bounding box width
/// * [x] - Face bounding box X coordinate
/// * [y] - Face bounding box Y coordinate
@BuiltValue()
abstract class AssetFaceCreateDto implements Built<AssetFaceCreateDto, AssetFaceCreateDtoBuilder> {
  /// Asset ID
  @BuiltValueField(wireName: r'assetId')
  String get assetId;

  /// Face bounding box height
  @BuiltValueField(wireName: r'height')
  int get height;

  /// Image height in pixels
  @BuiltValueField(wireName: r'imageHeight')
  int get imageHeight;

  /// Image width in pixels
  @BuiltValueField(wireName: r'imageWidth')
  int get imageWidth;

  /// Person ID
  @BuiltValueField(wireName: r'personId')
  String get personId;

  /// User ID
  @BuiltValueField(wireName: r'userId')
  String? get userId;

  /// Face bounding box width
  @BuiltValueField(wireName: r'width')
  int get width;

  /// Face bounding box X coordinate
  @BuiltValueField(wireName: r'x')
  int get x;

  /// Face bounding box Y coordinate
  @BuiltValueField(wireName: r'y')
  int get y;

  AssetFaceCreateDto._();

  factory AssetFaceCreateDto([void updates(AssetFaceCreateDtoBuilder b)]) = _$AssetFaceCreateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssetFaceCreateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssetFaceCreateDto> get serializer => _$AssetFaceCreateDtoSerializer();
}

class _$AssetFaceCreateDtoSerializer implements PrimitiveSerializer<AssetFaceCreateDto> {
  @override
  final Iterable<Type> types = const [AssetFaceCreateDto, _$AssetFaceCreateDto];

  @override
  final String wireName = r'AssetFaceCreateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssetFaceCreateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assetId';
    yield serializers.serialize(
      object.assetId,
      specifiedType: const FullType(String),
    );
    yield r'height';
    yield serializers.serialize(
      object.height,
      specifiedType: const FullType(int),
    );
    yield r'imageHeight';
    yield serializers.serialize(
      object.imageHeight,
      specifiedType: const FullType(int),
    );
    yield r'imageWidth';
    yield serializers.serialize(
      object.imageWidth,
      specifiedType: const FullType(int),
    );
    yield r'personId';
    yield serializers.serialize(
      object.personId,
      specifiedType: const FullType(String),
    );
    if (object.userId != null) {
      yield r'userId';
      yield serializers.serialize(
        object.userId,
        specifiedType: const FullType(String),
      );
    }
    yield r'width';
    yield serializers.serialize(
      object.width,
      specifiedType: const FullType(int),
    );
    yield r'x';
    yield serializers.serialize(
      object.x,
      specifiedType: const FullType(int),
    );
    yield r'y';
    yield serializers.serialize(
      object.y,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AssetFaceCreateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AssetFaceCreateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'assetId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.assetId = valueDes;
          break;
        case r'height':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.height = valueDes;
          break;
        case r'imageHeight':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.imageHeight = valueDes;
          break;
        case r'imageWidth':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.imageWidth = valueDes;
          break;
        case r'personId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.personId = valueDes;
          break;
        case r'userId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.userId = valueDes;
          break;
        case r'width':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.width = valueDes;
          break;
        case r'x':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.x = valueDes;
          break;
        case r'y':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.y = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AssetFaceCreateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssetFaceCreateDtoBuilder();
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


