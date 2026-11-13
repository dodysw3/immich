//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/admin_config_tiling_triggers_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_tiling_dto.g.dart';

/// AdminConfigTilingDto
///
/// Properties:
/// * [enabled] - Enable tiled face detection for large/group photos
/// * [maxTiles] - Maximum number of tiles before downscaling
/// * [tileOverlap] - Overlap ratio between adjacent tiles
/// * [tileSize] - Tile size in pixels for tiled detection
/// * [triggers] 
@BuiltValue()
abstract class AdminConfigTilingDto implements Built<AdminConfigTilingDto, AdminConfigTilingDtoBuilder> {
  /// Enable tiled face detection for large/group photos
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  /// Maximum number of tiles before downscaling
  @BuiltValueField(wireName: r'maxTiles')
  int get maxTiles;

  /// Overlap ratio between adjacent tiles
  @BuiltValueField(wireName: r'tileOverlap')
  double get tileOverlap;

  /// Tile size in pixels for tiled detection
  @BuiltValueField(wireName: r'tileSize')
  int get tileSize;

  @BuiltValueField(wireName: r'triggers')
  AdminConfigTilingTriggersDto get triggers;

  AdminConfigTilingDto._();

  factory AdminConfigTilingDto([void updates(AdminConfigTilingDtoBuilder b)]) = _$AdminConfigTilingDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigTilingDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigTilingDto> get serializer => _$AdminConfigTilingDtoSerializer();
}

class _$AdminConfigTilingDtoSerializer implements PrimitiveSerializer<AdminConfigTilingDto> {
  @override
  final Iterable<Type> types = const [AdminConfigTilingDto, _$AdminConfigTilingDto];

  @override
  final String wireName = r'AdminConfigTilingDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigTilingDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'maxTiles';
    yield serializers.serialize(
      object.maxTiles,
      specifiedType: const FullType(int),
    );
    yield r'tileOverlap';
    yield serializers.serialize(
      object.tileOverlap,
      specifiedType: const FullType(double),
    );
    yield r'tileSize';
    yield serializers.serialize(
      object.tileSize,
      specifiedType: const FullType(int),
    );
    yield r'triggers';
    yield serializers.serialize(
      object.triggers,
      specifiedType: const FullType(AdminConfigTilingTriggersDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigTilingDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigTilingDtoBuilder result,
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
        case r'maxTiles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.maxTiles = valueDes;
          break;
        case r'tileOverlap':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.tileOverlap = valueDes;
          break;
        case r'tileSize':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.tileSize = valueDes;
          break;
        case r'triggers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigTilingTriggersDto),
          ) as AdminConfigTilingTriggersDto;
          result.triggers.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigTilingDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigTilingDtoBuilder();
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


