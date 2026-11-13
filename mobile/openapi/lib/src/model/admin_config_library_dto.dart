//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/admin_config_library_scan_dto.dart';
import 'package:openapi/src/model/admin_config_library_watch_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_config_library_dto.g.dart';

/// AdminConfigLibraryDto
///
/// Properties:
/// * [scan] 
/// * [watch] 
@BuiltValue()
abstract class AdminConfigLibraryDto implements Built<AdminConfigLibraryDto, AdminConfigLibraryDtoBuilder> {
  @BuiltValueField(wireName: r'scan')
  AdminConfigLibraryScanDto get scan;

  @BuiltValueField(wireName: r'watch')
  AdminConfigLibraryWatchDto get watch;

  AdminConfigLibraryDto._();

  factory AdminConfigLibraryDto([void updates(AdminConfigLibraryDtoBuilder b)]) = _$AdminConfigLibraryDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConfigLibraryDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConfigLibraryDto> get serializer => _$AdminConfigLibraryDtoSerializer();
}

class _$AdminConfigLibraryDtoSerializer implements PrimitiveSerializer<AdminConfigLibraryDto> {
  @override
  final Iterable<Type> types = const [AdminConfigLibraryDto, _$AdminConfigLibraryDto];

  @override
  final String wireName = r'AdminConfigLibraryDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConfigLibraryDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'scan';
    yield serializers.serialize(
      object.scan,
      specifiedType: const FullType(AdminConfigLibraryScanDto),
    );
    yield r'watch';
    yield serializers.serialize(
      object.watch,
      specifiedType: const FullType(AdminConfigLibraryWatchDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConfigLibraryDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminConfigLibraryDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'scan':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigLibraryScanDto),
          ) as AdminConfigLibraryScanDto;
          result.scan.replace(valueDes);
          break;
        case r'watch':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminConfigLibraryWatchDto),
          ) as AdminConfigLibraryWatchDto;
          result.watch.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminConfigLibraryDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConfigLibraryDtoBuilder();
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


