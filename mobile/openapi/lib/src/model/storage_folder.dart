//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'storage_folder.g.dart';

/// Storage folder
class StorageFolder extends EnumClass {

  @BuiltValueEnumConst(wireName: r'encoded-video')
  static const StorageFolder encodedVideo = _$encodedVideo;
  @BuiltValueEnumConst(wireName: r'library')
  static const StorageFolder library_ = _$library_;
  @BuiltValueEnumConst(wireName: r'upload')
  static const StorageFolder upload = _$upload;
  @BuiltValueEnumConst(wireName: r'profile')
  static const StorageFolder profile = _$profile;
  @BuiltValueEnumConst(wireName: r'thumbs')
  static const StorageFolder thumbs = _$thumbs;
  @BuiltValueEnumConst(wireName: r'backups')
  static const StorageFolder backups = _$backups;

  static Serializer<StorageFolder> get serializer => _$storageFolderSerializer;

  const StorageFolder._(String name): super(name);

  static BuiltSet<StorageFolder> get values => _$values;
  static StorageFolder valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class StorageFolderMixin = Object with _$StorageFolderMixin;

