//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_clip_dto.g.dart';

/// AdminConfigClipDto
///
/// Properties:
/// * [enabled] - Whether the task is enabled
/// * [modelName] - Name of the model to use
@BuiltValue()
abstract class AdminConfigClipDto implements Built<AdminConfigClipDto, AdminConfigClipDtoBuilder> {
  /// Whether the task is enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  /// Name of the model to use
  @BuiltValueField(wireName: r'modelName')
  String get modelName;

  AdminConfigClipDto._();

  factory AdminConfigClipDto([void updates(AdminConfigClipDtoBuilder b)]) = _$AdminConfigClipDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigClipDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigClipDto> get serializer => _$AdminConfigClipDtoSerializer();
}

class _$AdminConfigClipDtoSerializer implements PrimitiveSerializer<AdminConfigClipDto> {
  @override
  final Iterable<Type> types = const [AdminConfigClipDto, _$AdminConfigClipDto];

  @override
  final String wireName = r'AdminConfigClipDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigClipDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'modelName';
    yield serializers.serialize(
      object.modelName,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigClipDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigClipDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'modelName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.modelName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigClipDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigClipDtoBuilder();
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


