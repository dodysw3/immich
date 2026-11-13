//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/storage_folder.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'maintenance_detect_install_storage_folder_dto.g.dart';

/// MaintenanceDetectInstallStorageFolderDto
///
/// Properties:
/// * [files] - Number of files in the folder
/// * [folder] 
/// * [readable] - Whether the folder is readable
/// * [writable] - Whether the folder is writable
@BuiltValue()
abstract class MaintenanceDetectInstallStorageFolderDto implements Built<MaintenanceDetectInstallStorageFolderDto, MaintenanceDetectInstallStorageFolderDtoBuilder> {
  /// Number of files in the folder
  @BuiltValueField(wireName: r'files')
  int get files;

  @BuiltValueField(wireName: r'folder')
  StorageFolder get folder;
  // enum folderEnum {  encoded-video,  library,  upload,  profile,  thumbs,  backups,  };

  /// Whether the folder is readable
  @BuiltValueField(wireName: r'readable')
  bool get readable;

  /// Whether the folder is writable
  @BuiltValueField(wireName: r'writable')
  bool get writable;

  MaintenanceDetectInstallStorageFolderDto._();

  factory MaintenanceDetectInstallStorageFolderDto([void updates(MaintenanceDetectInstallStorageFolderDtoBuilder b)]) = _$MaintenanceDetectInstallStorageFolderDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MaintenanceDetectInstallStorageFolderDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MaintenanceDetectInstallStorageFolderDto> get serializer => _$MaintenanceDetectInstallStorageFolderDtoSerializer();
}

class _$MaintenanceDetectInstallStorageFolderDtoSerializer implements PrimitiveSerializer<MaintenanceDetectInstallStorageFolderDto> {
  @override
  final Iterable<Type> types = const [MaintenanceDetectInstallStorageFolderDto, _$MaintenanceDetectInstallStorageFolderDto];

  @override
  final String wireName = r'MaintenanceDetectInstallStorageFolderDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MaintenanceDetectInstallStorageFolderDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'files';
    yield serializers.serialize(
      object.files,
      specifiedType: const FullType(int),
    );
    yield r'folder';
    yield serializers.serialize(
      object.folder,
      specifiedType: const FullType(StorageFolder),
    );
    yield r'readable';
    yield serializers.serialize(
      object.readable,
      specifiedType: const FullType(bool),
    );
    yield r'writable';
    yield serializers.serialize(
      object.writable,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MaintenanceDetectInstallStorageFolderDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MaintenanceDetectInstallStorageFolderDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'files':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.files = valueDes;
          break;
        case r'folder':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(StorageFolder),
          ) as StorageFolder;
          result.folder = valueDes;
          break;
        case r'readable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.readable = valueDes;
          break;
        case r'writable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.writable = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MaintenanceDetectInstallStorageFolderDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MaintenanceDetectInstallStorageFolderDtoBuilder();
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


