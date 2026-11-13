//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_job_name.g.dart';

/// Job name
class AssetJobName extends EnumClass {

  @BuiltValueEnumConst(wireName: r'scan-video-faces')
  static const AssetJobName scanVideoFaces = _$scanVideoFaces;
  @BuiltValueEnumConst(wireName: r'refresh-faces')
  static const AssetJobName refreshFaces = _$refreshFaces;
  @BuiltValueEnumConst(wireName: r'refresh-metadata')
  static const AssetJobName refreshMetadata = _$refreshMetadata;
  @BuiltValueEnumConst(wireName: r'regenerate-thumbnail')
  static const AssetJobName regenerateThumbnail = _$regenerateThumbnail;
  @BuiltValueEnumConst(wireName: r'interpret-image')
  static const AssetJobName interpretImage = _$interpretImage;
  @BuiltValueEnumConst(wireName: r'interpret-image-public')
  static const AssetJobName interpretImagePublic = _$interpretImagePublic;
  @BuiltValueEnumConst(wireName: r'caption-video')
  static const AssetJobName captionVideo = _$captionVideo;
  @BuiltValueEnumConst(wireName: r'transcode-video')
  static const AssetJobName transcodeVideo = _$transcodeVideo;

  static Serializer<AssetJobName> get serializer => _$assetJobNameSerializer;

  const AssetJobName._(String name): super(name);

  static BuiltSet<AssetJobName> get values => _$values;
  static AssetJobName valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class AssetJobNameMixin = Object with _$AssetJobNameMixin;

