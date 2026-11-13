//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_face_delete_dto.g.dart';

/// AssetFaceDeleteDto
///
/// Properties:
/// * [force] - Force delete even if person has other faces
@BuiltValue()
abstract class AssetFaceDeleteDto implements Built<AssetFaceDeleteDto, AssetFaceDeleteDtoBuilder> {
  /// Force delete even if person has other faces
  @BuiltValueField(wireName: r'force')
  bool get force;

  AssetFaceDeleteDto._();

  factory AssetFaceDeleteDto([void updates(AssetFaceDeleteDtoBuilder b)]) = _$AssetFaceDeleteDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssetFaceDeleteDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssetFaceDeleteDto> get serializer => _$AssetFaceDeleteDtoSerializer();
}

class _$AssetFaceDeleteDtoSerializer implements PrimitiveSerializer<AssetFaceDeleteDto> {
  @override
  final Iterable<Type> types = const [AssetFaceDeleteDto, _$AssetFaceDeleteDto];

  @override
  final String wireName = r'AssetFaceDeleteDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssetFaceDeleteDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'force';
    yield serializers.serialize(
      object.force,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AssetFaceDeleteDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AssetFaceDeleteDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'force':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.force = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AssetFaceDeleteDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssetFaceDeleteDtoBuilder();
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


