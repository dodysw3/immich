//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recently_added_update.g.dart';

/// RecentlyAddedUpdate
///
/// Properties:
/// * [sidebarWeb] - Whether the recently added page appears in the web sidebar
@BuiltValue()
abstract class RecentlyAddedUpdate implements Built<RecentlyAddedUpdate, RecentlyAddedUpdateBuilder> {
  /// Whether the recently added page appears in the web sidebar
  @BuiltValueField(wireName: r'sidebarWeb')
  bool? get sidebarWeb;

  RecentlyAddedUpdate._();

  factory RecentlyAddedUpdate([void updates(RecentlyAddedUpdateBuilder b)]) = _$RecentlyAddedUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecentlyAddedUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecentlyAddedUpdate> get serializer => _$RecentlyAddedUpdateSerializer();
}

class _$RecentlyAddedUpdateSerializer implements PrimitiveSerializer<RecentlyAddedUpdate> {
  @override
  final Iterable<Type> types = const [RecentlyAddedUpdate, _$RecentlyAddedUpdate];

  @override
  final String wireName = r'RecentlyAddedUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecentlyAddedUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.sidebarWeb != null) {
      yield r'sidebarWeb';
      yield serializers.serialize(
        object.sidebarWeb,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RecentlyAddedUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RecentlyAddedUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'sidebarWeb':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.sidebarWeb = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RecentlyAddedUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecentlyAddedUpdateBuilder();
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


