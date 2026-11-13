//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_metadata_key.g.dart';

/// User metadata key
class UserMetadataKey extends EnumClass {

  @BuiltValueEnumConst(wireName: r'preferences')
  static const UserMetadataKey preferences = _$preferences;
  @BuiltValueEnumConst(wireName: r'license')
  static const UserMetadataKey license = _$license;
  @BuiltValueEnumConst(wireName: r'onboarding')
  static const UserMetadataKey onboarding = _$onboarding;

  static Serializer<UserMetadataKey> get serializer => _$userMetadataKeySerializer;

  const UserMetadataKey._(String name): super(name);

  static BuiltSet<UserMetadataKey> get values => _$values;
  static UserMetadataKey valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class UserMetadataKeyMixin = Object with _$UserMetadataKeyMixin;

