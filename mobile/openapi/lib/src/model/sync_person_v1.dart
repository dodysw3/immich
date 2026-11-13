//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_person_v1.g.dart';

/// SyncPersonV1
///
/// Properties:
/// * [birthDate] - Birth date
/// * [color] - Color
/// * [createdAt] - Created at
/// * [faceAssetId] - Face asset ID
/// * [id] - Person ID
/// * [isFavorite] - Is favorite
/// * [isHidden] - Is hidden
/// * [name] - Person name
/// * [ownerId] - Owner ID
/// * [updatedAt] - Updated at
@BuiltValue()
abstract class SyncPersonV1 implements Built<SyncPersonV1, SyncPersonV1Builder> {
  /// Birth date
  @BuiltValueField(wireName: r'birthDate')
  DateTime? get birthDate;

  /// Color
  @BuiltValueField(wireName: r'color')
  String? get color;

  /// Created at
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  /// Face asset ID
  @BuiltValueField(wireName: r'faceAssetId')
  String? get faceAssetId;

  /// Person ID
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Is favorite
  @BuiltValueField(wireName: r'isFavorite')
  bool get isFavorite;

  /// Is hidden
  @BuiltValueField(wireName: r'isHidden')
  bool get isHidden;

  /// Person name
  @BuiltValueField(wireName: r'name')
  String get name;

  /// Owner ID
  @BuiltValueField(wireName: r'ownerId')
  String get ownerId;

  /// Updated at
  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  SyncPersonV1._();

  factory SyncPersonV1([void updates(SyncPersonV1Builder b)]) = _$SyncPersonV1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncPersonV1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncPersonV1> get serializer => _$SyncPersonV1Serializer();
}

class _$SyncPersonV1Serializer implements PrimitiveSerializer<SyncPersonV1> {
  @override
  final Iterable<Type> types = const [SyncPersonV1, _$SyncPersonV1];

  @override
  final String wireName = r'SyncPersonV1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncPersonV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'birthDate';
    yield object.birthDate == null ? null : serializers.serialize(
      object.birthDate,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'color';
    yield object.color == null ? null : serializers.serialize(
      object.color,
      specifiedType: const FullType.nullable(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'faceAssetId';
    yield object.faceAssetId == null ? null : serializers.serialize(
      object.faceAssetId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'isFavorite';
    yield serializers.serialize(
      object.isFavorite,
      specifiedType: const FullType(bool),
    );
    yield r'isHidden';
    yield serializers.serialize(
      object.isHidden,
      specifiedType: const FullType(bool),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'ownerId';
    yield serializers.serialize(
      object.ownerId,
      specifiedType: const FullType(String),
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
    SyncPersonV1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncPersonV1Builder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'birthDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
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
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'faceAssetId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.faceAssetId = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'isFavorite':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isFavorite = valueDes;
          break;
        case r'isHidden':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isHidden = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'ownerId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ownerId = valueDes;
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
  SyncPersonV1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncPersonV1Builder();
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


