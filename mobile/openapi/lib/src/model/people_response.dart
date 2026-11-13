//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/person_update_strategy.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'people_response.g.dart';

/// PeopleResponse
///
/// Properties:
/// * [enabled] - Whether people are enabled
/// * [minimumFaces] - People face threshold
/// * [sidebarWeb] - Whether people appear in web sidebar
/// * [updateStrategy] 
@BuiltValue()
abstract class PeopleResponse implements Built<PeopleResponse, PeopleResponseBuilder> {
  /// Whether people are enabled
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  /// People face threshold
  @BuiltValueField(wireName: r'minimumFaces')
  int? get minimumFaces;

  /// Whether people appear in web sidebar
  @BuiltValueField(wireName: r'sidebarWeb')
  bool get sidebarWeb;

  @BuiltValueField(wireName: r'updateStrategy')
  PersonUpdateStrategy get updateStrategy;
  // enum updateStrategyEnum {  self,  everyone,  };

  PeopleResponse._();

  factory PeopleResponse([void updates(PeopleResponseBuilder b)]) = _$PeopleResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PeopleResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PeopleResponse> get serializer => _$PeopleResponseSerializer();
}

class _$PeopleResponseSerializer implements PrimitiveSerializer<PeopleResponse> {
  @override
  final Iterable<Type> types = const [PeopleResponse, _$PeopleResponse];

  @override
  final String wireName = r'PeopleResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PeopleResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    if (object.minimumFaces != null) {
      yield r'minimumFaces';
      yield serializers.serialize(
        object.minimumFaces,
        specifiedType: const FullType(int),
      );
    }
    yield r'sidebarWeb';
    yield serializers.serialize(
      object.sidebarWeb,
      specifiedType: const FullType(bool),
    );
    yield r'updateStrategy';
    yield serializers.serialize(
      object.updateStrategy,
      specifiedType: const FullType(PersonUpdateStrategy),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PeopleResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PeopleResponseBuilder result,
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
        case r'minimumFaces':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.minimumFaces = valueDes;
          break;
        case r'sidebarWeb':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.sidebarWeb = valueDes;
          break;
        case r'updateStrategy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PersonUpdateStrategy),
          ) as PersonUpdateStrategy;
          result.updateStrategy = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PeopleResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PeopleResponseBuilder();
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


