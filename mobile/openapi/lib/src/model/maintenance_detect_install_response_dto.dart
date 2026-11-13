//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/maintenance_detect_install_storage_folder_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'maintenance_detect_install_response_dto.g.dart';

/// MaintenanceDetectInstallResponseDto
///
/// Properties:
/// * [storage] 
@BuiltValue()
abstract class MaintenanceDetectInstallResponseDto implements Built<MaintenanceDetectInstallResponseDto, MaintenanceDetectInstallResponseDtoBuilder> {
  @BuiltValueField(wireName: r'storage')
  BuiltList<MaintenanceDetectInstallStorageFolderDto> get storage;

  MaintenanceDetectInstallResponseDto._();

  factory MaintenanceDetectInstallResponseDto([void updates(MaintenanceDetectInstallResponseDtoBuilder b)]) = _$MaintenanceDetectInstallResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MaintenanceDetectInstallResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MaintenanceDetectInstallResponseDto> get serializer => _$MaintenanceDetectInstallResponseDtoSerializer();
}

class _$MaintenanceDetectInstallResponseDtoSerializer implements PrimitiveSerializer<MaintenanceDetectInstallResponseDto> {
  @override
  final Iterable<Type> types = const [MaintenanceDetectInstallResponseDto, _$MaintenanceDetectInstallResponseDto];

  @override
  final String wireName = r'MaintenanceDetectInstallResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MaintenanceDetectInstallResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'storage';
    yield serializers.serialize(
      object.storage,
      specifiedType: const FullType(BuiltList, [FullType(MaintenanceDetectInstallStorageFolderDto)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MaintenanceDetectInstallResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MaintenanceDetectInstallResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'storage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MaintenanceDetectInstallStorageFolderDto)]),
          ) as BuiltList<MaintenanceDetectInstallStorageFolderDto>;
          result.storage.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MaintenanceDetectInstallResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MaintenanceDetectInstallResponseDtoBuilder();
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


