//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recently_matched_item_dto.g.dart';

/// RecentlyMatchedItemDto
///
/// Properties:
/// * [assetId] - Asset ID of the matched face
/// * [personId] - Person ID the face was matched to
/// * [personName] - Person name, empty when the person is unnamed
/// * [recognizedAt] - When this asset-person pair was last matched by recognition
@BuiltValue()
abstract class RecentlyMatchedItemDto implements Built<RecentlyMatchedItemDto, RecentlyMatchedItemDtoBuilder> {
  /// Asset ID of the matched face
  @BuiltValueField(wireName: r'assetId')
  String get assetId;

  /// Person ID the face was matched to
  @BuiltValueField(wireName: r'personId')
  String get personId;

  /// Person name, empty when the person is unnamed
  @BuiltValueField(wireName: r'personName')
  String get personName;

  /// When this asset-person pair was last matched by recognition
  @BuiltValueField(wireName: r'recognizedAt')
  DateTime get recognizedAt;

  RecentlyMatchedItemDto._();

  factory RecentlyMatchedItemDto([void updates(RecentlyMatchedItemDtoBuilder b)]) = _$RecentlyMatchedItemDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecentlyMatchedItemDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecentlyMatchedItemDto> get serializer => _$RecentlyMatchedItemDtoSerializer();
}

class _$RecentlyMatchedItemDtoSerializer implements PrimitiveSerializer<RecentlyMatchedItemDto> {
  @override
  final Iterable<Type> types = const [RecentlyMatchedItemDto, _$RecentlyMatchedItemDto];

  @override
  final String wireName = r'RecentlyMatchedItemDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecentlyMatchedItemDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assetId';
    yield serializers.serialize(
      object.assetId,
      specifiedType: const FullType(String),
    );
    yield r'personId';
    yield serializers.serialize(
      object.personId,
      specifiedType: const FullType(String),
    );
    yield r'personName';
    yield serializers.serialize(
      object.personName,
      specifiedType: const FullType(String),
    );
    yield r'recognizedAt';
    yield serializers.serialize(
      object.recognizedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RecentlyMatchedItemDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RecentlyMatchedItemDtoBuilder result,
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
        case r'personId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.personId = valueDes;
          break;
        case r'personName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.personName = valueDes;
          break;
        case r'recognizedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.recognizedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RecentlyMatchedItemDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecentlyMatchedItemDtoBuilder();
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


