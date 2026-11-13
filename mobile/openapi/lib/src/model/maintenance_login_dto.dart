//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'maintenance_login_dto.g.dart';

/// MaintenanceLoginDto
///
/// Properties:
/// * [token] - Maintenance token
@BuiltValue()
abstract class MaintenanceLoginDto implements Built<MaintenanceLoginDto, MaintenanceLoginDtoBuilder> {
  /// Maintenance token
  @BuiltValueField(wireName: r'token')
  String? get token;

  MaintenanceLoginDto._();

  factory MaintenanceLoginDto([void updates(MaintenanceLoginDtoBuilder b)]) = _$MaintenanceLoginDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MaintenanceLoginDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MaintenanceLoginDto> get serializer => _$MaintenanceLoginDtoSerializer();
}

class _$MaintenanceLoginDtoSerializer implements PrimitiveSerializer<MaintenanceLoginDto> {
  @override
  final Iterable<Type> types = const [MaintenanceLoginDto, _$MaintenanceLoginDto];

  @override
  final String wireName = r'MaintenanceLoginDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MaintenanceLoginDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.token != null) {
      yield r'token';
      yield serializers.serialize(
        object.token,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MaintenanceLoginDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MaintenanceLoginDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.token = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MaintenanceLoginDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MaintenanceLoginDtoBuilder();
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


