//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_copy_dto.g.dart';

/// AssetCopyDto
///
/// Properties:
/// * [albums] - Copy album associations
/// * [favorite] - Copy favorite status
/// * [sharedLinks] - Copy shared links
/// * [sidecar] - Copy sidecar file
/// * [sourceId] - Source asset ID
/// * [stack] - Copy stack association
/// * [targetId] - Target asset ID
@BuiltValue()
abstract class AssetCopyDto implements Built<AssetCopyDto, AssetCopyDtoBuilder> {
  /// Copy album associations
  @BuiltValueField(wireName: r'albums')
  bool? get albums;

  /// Copy favorite status
  @BuiltValueField(wireName: r'favorite')
  bool? get favorite;

  /// Copy shared links
  @BuiltValueField(wireName: r'sharedLinks')
  bool? get sharedLinks;

  /// Copy sidecar file
  @BuiltValueField(wireName: r'sidecar')
  bool? get sidecar;

  /// Source asset ID
  @BuiltValueField(wireName: r'sourceId')
  String get sourceId;

  /// Copy stack association
  @BuiltValueField(wireName: r'stack')
  bool? get stack;

  /// Target asset ID
  @BuiltValueField(wireName: r'targetId')
  String get targetId;

  AssetCopyDto._();

  factory AssetCopyDto([void updates(AssetCopyDtoBuilder b)]) = _$AssetCopyDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssetCopyDtoBuilder b) => b
      ..albums = true
      ..favorite = true
      ..sharedLinks = true
      ..sidecar = true
      ..stack = true;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssetCopyDto> get serializer => _$AssetCopyDtoSerializer();
}

class _$AssetCopyDtoSerializer implements PrimitiveSerializer<AssetCopyDto> {
  @override
  final Iterable<Type> types = const [AssetCopyDto, _$AssetCopyDto];

  @override
  final String wireName = r'AssetCopyDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssetCopyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.albums != null) {
      yield r'albums';
      yield serializers.serialize(
        object.albums,
        specifiedType: const FullType(bool),
      );
    }
    if (object.favorite != null) {
      yield r'favorite';
      yield serializers.serialize(
        object.favorite,
        specifiedType: const FullType(bool),
      );
    }
    if (object.sharedLinks != null) {
      yield r'sharedLinks';
      yield serializers.serialize(
        object.sharedLinks,
        specifiedType: const FullType(bool),
      );
    }
    if (object.sidecar != null) {
      yield r'sidecar';
      yield serializers.serialize(
        object.sidecar,
        specifiedType: const FullType(bool),
      );
    }
    yield r'sourceId';
    yield serializers.serialize(
      object.sourceId,
      specifiedType: const FullType(String),
    );
    if (object.stack != null) {
      yield r'stack';
      yield serializers.serialize(
        object.stack,
        specifiedType: const FullType(bool),
      );
    }
    yield r'targetId';
    yield serializers.serialize(
      object.targetId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AssetCopyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AssetCopyDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'albums':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.albums = valueDes;
          break;
        case r'favorite':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.favorite = valueDes;
          break;
        case r'sharedLinks':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.sharedLinks = valueDes;
          break;
        case r'sidecar':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.sidecar = valueDes;
          break;
        case r'sourceId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sourceId = valueDes;
          break;
        case r'stack':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.stack = valueDes;
          break;
        case r'targetId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.targetId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AssetCopyDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssetCopyDtoBuilder();
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


