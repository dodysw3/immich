//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'person_users_delete_dto_inner.g.dart';

/// PersonUsersDeleteDtoInner
///
/// Properties:
/// * [personId] - Person ID
/// * [sharedById] - User ID of the user that gave access to the person
/// * [sharedWithId] - User ID of the user that was given access to the person
@BuiltValue()
abstract class PersonUsersDeleteDtoInner implements Built<PersonUsersDeleteDtoInner, PersonUsersDeleteDtoInnerBuilder> {
  /// Person ID
  @BuiltValueField(wireName: r'personId')
  String get personId;

  /// User ID of the user that gave access to the person
  @BuiltValueField(wireName: r'sharedById')
  String? get sharedById;

  /// User ID of the user that was given access to the person
  @BuiltValueField(wireName: r'sharedWithId')
  String get sharedWithId;

  PersonUsersDeleteDtoInner._();

  factory PersonUsersDeleteDtoInner([void updates(PersonUsersDeleteDtoInnerBuilder b)]) = _$PersonUsersDeleteDtoInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PersonUsersDeleteDtoInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PersonUsersDeleteDtoInner> get serializer => _$PersonUsersDeleteDtoInnerSerializer();
}

class _$PersonUsersDeleteDtoInnerSerializer implements PrimitiveSerializer<PersonUsersDeleteDtoInner> {
  @override
  final Iterable<Type> types = const [PersonUsersDeleteDtoInner, _$PersonUsersDeleteDtoInner];

  @override
  final String wireName = r'PersonUsersDeleteDtoInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PersonUsersDeleteDtoInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'personId';
    yield serializers.serialize(
      object.personId,
      specifiedType: const FullType(String),
    );
    if (object.sharedById != null) {
      yield r'sharedById';
      yield serializers.serialize(
        object.sharedById,
        specifiedType: const FullType(String),
      );
    }
    yield r'sharedWithId';
    yield serializers.serialize(
      object.sharedWithId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PersonUsersDeleteDtoInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PersonUsersDeleteDtoInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'personId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.personId = valueDes;
          break;
        case r'sharedById':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.sharedById = valueDes;
          break;
        case r'sharedWithId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sharedWithId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PersonUsersDeleteDtoInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PersonUsersDeleteDtoInnerBuilder();
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


