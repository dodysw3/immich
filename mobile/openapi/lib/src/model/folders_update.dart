//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'folders_update.g.dart';

/// FoldersUpdate
///
/// Properties:
/// * [enabled] - Whether folders are enabled
/// * [sidebarWeb] - Whether folders appear in web sidebar
@BuiltValue()
abstract class FoldersUpdate implements Built<FoldersUpdate, FoldersUpdateBuilder> {
  /// Whether folders are enabled
  @BuiltValueField(wireName: r'enabled')
  bool? get enabled;

  /// Whether folders appear in web sidebar
  @BuiltValueField(wireName: r'sidebarWeb')
  bool? get sidebarWeb;

  FoldersUpdate._();

  factory FoldersUpdate([void updates(FoldersUpdateBuilder b)]) = _$FoldersUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FoldersUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FoldersUpdate> get serializer => _$FoldersUpdateSerializer();
}

class _$FoldersUpdateSerializer implements PrimitiveSerializer<FoldersUpdate> {
  @override
  final Iterable<Type> types = const [FoldersUpdate, _$FoldersUpdate];

  @override
  final String wireName = r'FoldersUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FoldersUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.enabled != null) {
      yield r'enabled';
      yield serializers.serialize(
        object.enabled,
        specifiedType: const FullType(bool),
      );
    }
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
    FoldersUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FoldersUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.enabled = valueDes;
          break;
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
  FoldersUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FoldersUpdateBuilder();
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


