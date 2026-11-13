//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'o_auth_token_endpoint_auth_method.g.dart';

/// OAuth token endpoint auth method
class OAuthTokenEndpointAuthMethod extends EnumClass {

  @BuiltValueEnumConst(wireName: r'client_secret_post')
  static const OAuthTokenEndpointAuthMethod clientSecretPost = _$clientSecretPost;
  @BuiltValueEnumConst(wireName: r'client_secret_basic')
  static const OAuthTokenEndpointAuthMethod clientSecretBasic = _$clientSecretBasic;

  static Serializer<OAuthTokenEndpointAuthMethod> get serializer => _$oAuthTokenEndpointAuthMethodSerializer;

  const OAuthTokenEndpointAuthMethod._(String name): super(name);

  static BuiltSet<OAuthTokenEndpointAuthMethod> get values => _$values;
  static OAuthTokenEndpointAuthMethod valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class OAuthTokenEndpointAuthMethodMixin = Object with _$OAuthTokenEndpointAuthMethodMixin;

