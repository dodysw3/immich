//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/queue_command.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'queue_command_dto.g.dart';

/// QueueCommandDto
///
/// Properties:
/// * [command] 
/// * [force] - Force the command execution (if applicable)
@BuiltValue()
abstract class QueueCommandDto implements Built<QueueCommandDto, QueueCommandDtoBuilder> {
  @BuiltValueField(wireName: r'command')
  QueueCommand get command;
  // enum commandEnum {  start,  pause,  resume,  empty,  clear-failed,  };

  /// Force the command execution (if applicable)
  @BuiltValueField(wireName: r'force')
  bool? get force;

  QueueCommandDto._();

  factory QueueCommandDto([void updates(QueueCommandDtoBuilder b)]) = _$QueueCommandDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(QueueCommandDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<QueueCommandDto> get serializer => _$QueueCommandDtoSerializer();
}

class _$QueueCommandDtoSerializer implements PrimitiveSerializer<QueueCommandDto> {
  @override
  final Iterable<Type> types = const [QueueCommandDto, _$QueueCommandDto];

  @override
  final String wireName = r'QueueCommandDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    QueueCommandDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'command';
    yield serializers.serialize(
      object.command,
      specifiedType: const FullType(QueueCommand),
    );
    if (object.force != null) {
      yield r'force';
      yield serializers.serialize(
        object.force,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    QueueCommandDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required QueueCommandDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'command':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QueueCommand),
          ) as QueueCommand;
          result.command = valueDes;
          break;
        case r'force':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
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
  QueueCommandDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = QueueCommandDtoBuilder();
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


