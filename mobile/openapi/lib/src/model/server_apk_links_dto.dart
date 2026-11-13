//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'server_apk_links_dto.g.dart';

/// ServerApkLinksDto
///
/// Properties:
/// * [arm64v8a] - APK download link for ARM64 v8a architecture
/// * [armeabiv7a] - APK download link for ARM EABI v7a architecture
/// * [universal] - APK download link for universal architecture
/// * [x8664] - APK download link for x86_64 architecture
@BuiltValue()
abstract class ServerApkLinksDto implements Built<ServerApkLinksDto, ServerApkLinksDtoBuilder> {
  /// APK download link for ARM64 v8a architecture
  @BuiltValueField(wireName: r'arm64v8a')
  String get arm64v8a;

  /// APK download link for ARM EABI v7a architecture
  @BuiltValueField(wireName: r'armeabiv7a')
  String get armeabiv7a;

  /// APK download link for universal architecture
  @BuiltValueField(wireName: r'universal')
  String get universal;

  /// APK download link for x86_64 architecture
  @BuiltValueField(wireName: r'x86_64')
  String get x8664;

  ServerApkLinksDto._();

  factory ServerApkLinksDto([void updates(ServerApkLinksDtoBuilder b)]) = _$ServerApkLinksDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ServerApkLinksDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ServerApkLinksDto> get serializer => _$ServerApkLinksDtoSerializer();
}

class _$ServerApkLinksDtoSerializer implements PrimitiveSerializer<ServerApkLinksDto> {
  @override
  final Iterable<Type> types = const [ServerApkLinksDto, _$ServerApkLinksDto];

  @override
  final String wireName = r'ServerApkLinksDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ServerApkLinksDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'arm64v8a';
    yield serializers.serialize(
      object.arm64v8a,
      specifiedType: const FullType(String),
    );
    yield r'armeabiv7a';
    yield serializers.serialize(
      object.armeabiv7a,
      specifiedType: const FullType(String),
    );
    yield r'universal';
    yield serializers.serialize(
      object.universal,
      specifiedType: const FullType(String),
    );
    yield r'x86_64';
    yield serializers.serialize(
      object.x8664,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ServerApkLinksDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ServerApkLinksDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'arm64v8a':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.arm64v8a = valueDes;
          break;
        case r'armeabiv7a':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.armeabiv7a = valueDes;
          break;
        case r'universal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.universal = valueDes;
          break;
        case r'x86_64':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.x8664 = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ServerApkLinksDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ServerApkLinksDtoBuilder();
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


