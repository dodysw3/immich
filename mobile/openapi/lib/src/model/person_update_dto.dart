//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'person_update_dto.g.dart';

/// PersonUpdateDto
///
/// Properties:
/// * [birthDate] - Person date of birth
/// * [color] - Person color (hex)
/// * [featureFaceAssetId] - Asset ID used for feature face thumbnail
/// * [isFavorite] - Mark as favorite
/// * [isHidden] - Person visibility (hidden)
/// * [name] - Person name
/// * [userId] - Restrict the update to the person record of this User ID
@BuiltValue()
abstract class PersonUpdateDto implements Built<PersonUpdateDto, PersonUpdateDtoBuilder> {
  /// Person date of birth
  @BuiltValueField(wireName: r'birthDate')
  Date? get birthDate;

  /// Person color (hex)
  @BuiltValueField(wireName: r'color')
  String? get color;

  /// Asset ID used for feature face thumbnail
  @BuiltValueField(wireName: r'featureFaceAssetId')
  String? get featureFaceAssetId;

  /// Mark as favorite
  @BuiltValueField(wireName: r'isFavorite')
  bool? get isFavorite;

  /// Person visibility (hidden)
  @BuiltValueField(wireName: r'isHidden')
  bool? get isHidden;

  /// Person name
  @BuiltValueField(wireName: r'name')
  String? get name;

  /// Restrict the update to the person record of this User ID
  @BuiltValueField(wireName: r'userId')
  String? get userId;

  PersonUpdateDto._();

  factory PersonUpdateDto([void updates(PersonUpdateDtoBuilder b)]) = _$PersonUpdateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PersonUpdateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PersonUpdateDto> get serializer => _$PersonUpdateDtoSerializer();
}

class _$PersonUpdateDtoSerializer implements PrimitiveSerializer<PersonUpdateDto> {
  @override
  final Iterable<Type> types = const [PersonUpdateDto, _$PersonUpdateDto];

  @override
  final String wireName = r'PersonUpdateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PersonUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.birthDate != null) {
      yield r'birthDate';
      yield serializers.serialize(
        object.birthDate,
        specifiedType: const FullType.nullable(Date),
      );
    }
    if (object.color != null) {
      yield r'color';
      yield serializers.serialize(
        object.color,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.featureFaceAssetId != null) {
      yield r'featureFaceAssetId';
      yield serializers.serialize(
        object.featureFaceAssetId,
        specifiedType: const FullType(String),
      );
    }
    if (object.isFavorite != null) {
      yield r'isFavorite';
      yield serializers.serialize(
        object.isFavorite,
        specifiedType: const FullType(bool),
      );
    }
    if (object.isHidden != null) {
      yield r'isHidden';
      yield serializers.serialize(
        object.isHidden,
        specifiedType: const FullType(bool),
      );
    }
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.userId != null) {
      yield r'userId';
      yield serializers.serialize(
        object.userId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PersonUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PersonUpdateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'birthDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.birthDate = valueDes;
          break;
        case r'color':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.color = valueDes;
          break;
        case r'featureFaceAssetId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.featureFaceAssetId = valueDes;
          break;
        case r'isFavorite':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isFavorite = valueDes;
          break;
        case r'isHidden':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isHidden = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'userId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.userId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PersonUpdateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PersonUpdateDtoBuilder();
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


