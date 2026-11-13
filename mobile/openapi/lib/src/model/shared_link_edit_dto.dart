//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'shared_link_edit_dto.g.dart';

/// SharedLinkEditDto
///
/// Properties:
/// * [allowDownload] - Allow downloads
/// * [allowUpload] - Allow uploads
/// * [description] - Link description
/// * [expiresAt] - Expiration date
/// * [password] - Link password
/// * [showMetadata] - Show metadata
/// * [slug] - Custom URL slug
@BuiltValue()
abstract class SharedLinkEditDto implements Built<SharedLinkEditDto, SharedLinkEditDtoBuilder> {
  /// Allow downloads
  @BuiltValueField(wireName: r'allowDownload')
  bool? get allowDownload;

  /// Allow uploads
  @BuiltValueField(wireName: r'allowUpload')
  bool? get allowUpload;

  /// Link description
  @BuiltValueField(wireName: r'description')
  String? get description;

  /// Expiration date
  @BuiltValueField(wireName: r'expiresAt')
  DateTime? get expiresAt;

  /// Link password
  @BuiltValueField(wireName: r'password')
  String? get password;

  /// Show metadata
  @BuiltValueField(wireName: r'showMetadata')
  bool? get showMetadata;

  /// Custom URL slug
  @BuiltValueField(wireName: r'slug')
  String? get slug;

  SharedLinkEditDto._();

  factory SharedLinkEditDto([void updates(SharedLinkEditDtoBuilder b)]) = _$SharedLinkEditDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SharedLinkEditDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SharedLinkEditDto> get serializer => _$SharedLinkEditDtoSerializer();
}

class _$SharedLinkEditDtoSerializer implements PrimitiveSerializer<SharedLinkEditDto> {
  @override
  final Iterable<Type> types = const [SharedLinkEditDto, _$SharedLinkEditDto];

  @override
  final String wireName = r'SharedLinkEditDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SharedLinkEditDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.allowDownload != null) {
      yield r'allowDownload';
      yield serializers.serialize(
        object.allowDownload,
        specifiedType: const FullType(bool),
      );
    }
    if (object.allowUpload != null) {
      yield r'allowUpload';
      yield serializers.serialize(
        object.allowUpload,
        specifiedType: const FullType(bool),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.expiresAt != null) {
      yield r'expiresAt';
      yield serializers.serialize(
        object.expiresAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.password != null) {
      yield r'password';
      yield serializers.serialize(
        object.password,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.showMetadata != null) {
      yield r'showMetadata';
      yield serializers.serialize(
        object.showMetadata,
        specifiedType: const FullType(bool),
      );
    }
    if (object.slug != null) {
      yield r'slug';
      yield serializers.serialize(
        object.slug,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SharedLinkEditDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SharedLinkEditDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'allowDownload':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.allowDownload = valueDes;
          break;
        case r'allowUpload':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.allowUpload = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.expiresAt = valueDes;
          break;
        case r'password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.password = valueDes;
          break;
        case r'showMetadata':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.showMetadata = valueDes;
          break;
        case r'slug':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.slug = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SharedLinkEditDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SharedLinkEditDtoBuilder();
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


