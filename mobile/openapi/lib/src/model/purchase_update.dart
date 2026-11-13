//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'purchase_update.g.dart';

/// PurchaseUpdate
///
/// Properties:
/// * [hideBuyButtonUntil] - Date until which to hide buy button
/// * [showSupportBadge] - Whether to show support badge
@BuiltValue()
abstract class PurchaseUpdate implements Built<PurchaseUpdate, PurchaseUpdateBuilder> {
  /// Date until which to hide buy button
  @BuiltValueField(wireName: r'hideBuyButtonUntil')
  String? get hideBuyButtonUntil;

  /// Whether to show support badge
  @BuiltValueField(wireName: r'showSupportBadge')
  bool? get showSupportBadge;

  PurchaseUpdate._();

  factory PurchaseUpdate([void updates(PurchaseUpdateBuilder b)]) = _$PurchaseUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PurchaseUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PurchaseUpdate> get serializer => _$PurchaseUpdateSerializer();
}

class _$PurchaseUpdateSerializer implements PrimitiveSerializer<PurchaseUpdate> {
  @override
  final Iterable<Type> types = const [PurchaseUpdate, _$PurchaseUpdate];

  @override
  final String wireName = r'PurchaseUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PurchaseUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.hideBuyButtonUntil != null) {
      yield r'hideBuyButtonUntil';
      yield serializers.serialize(
        object.hideBuyButtonUntil,
        specifiedType: const FullType(String),
      );
    }
    if (object.showSupportBadge != null) {
      yield r'showSupportBadge';
      yield serializers.serialize(
        object.showSupportBadge,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PurchaseUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PurchaseUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'hideBuyButtonUntil':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.hideBuyButtonUntil = valueDes;
          break;
        case r'showSupportBadge':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.showSupportBadge = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PurchaseUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PurchaseUpdateBuilder();
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


