//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'folders_response.g.dart';

/// FoldersResponse
///
/// Properties:
/// * [enabled] - Whether folders are enabled
/// * [sidebarWeb] - Whether folders appear in web sidebar
@BuiltValue()
abstract class FoldersResponse implements Built<FoldersResponse, FoldersResponseBuilder> {
  /// Whether folders are enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  /// Whether folders appear in web sidebar
  @BuiltValueField(wireName: r'sidebarWeb')
  bool get sidebarWeb;

  FoldersResponse._();

  factory FoldersResponse([void updates(FoldersResponseBuilder b)]) = _$FoldersResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FoldersResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FoldersResponse> get serializer => _$FoldersResponseSerializer();
}

class _$FoldersResponseSerializer implements PrimitiveSerializer<FoldersResponse> {
  @override
  final Iterable<Type> types = const [FoldersResponse, _$FoldersResponse];

  @override
  final String wireName = r'FoldersResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FoldersResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'sidebarWeb';
    yield serializers.serialize(
      object.sidebarWeb,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FoldersResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FoldersResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'sidebarWeb':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
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
  FoldersResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FoldersResponseBuilder();
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


