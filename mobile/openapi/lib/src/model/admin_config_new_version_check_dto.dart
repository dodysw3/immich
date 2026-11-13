//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/release_channel.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_new_version_check_dto.g.dart';

/// AdminConfigNewVersionCheckDto
///
/// Properties:
/// * [channel] 
/// * [enabled] - Enabled
@BuiltValue()
abstract class AdminConfigNewVersionCheckDto implements Built<AdminConfigNewVersionCheckDto, AdminConfigNewVersionCheckDtoBuilder> {
  @BuiltValueField(wireName: r'channel')
  ReleaseChannel get channel;
  // enum channelEnum {  stable,  releaseCandidate,  };

  /// Enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  AdminConfigNewVersionCheckDto._();

  factory AdminConfigNewVersionCheckDto([void updates(AdminConfigNewVersionCheckDtoBuilder b)]) = _$AdminConfigNewVersionCheckDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigNewVersionCheckDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigNewVersionCheckDto> get serializer => _$AdminConfigNewVersionCheckDtoSerializer();
}

class _$AdminConfigNewVersionCheckDtoSerializer implements PrimitiveSerializer<AdminConfigNewVersionCheckDto> {
  @override
  final Iterable<Type> types = const [AdminConfigNewVersionCheckDto, _$AdminConfigNewVersionCheckDto];

  @override
  final String wireName = r'AdminConfigNewVersionCheckDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigNewVersionCheckDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'channel';
    yield serializers.serialize(
      object.channel,
      specifiedType: const FullType(ReleaseChannel),
    );
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigNewVersionCheckDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigNewVersionCheckDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'channel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ReleaseChannel),
          ) as ReleaseChannel;
          result.channel = valueDes;
          break;
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigNewVersionCheckDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigNewVersionCheckDtoBuilder();
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


