//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FaceDetectionTilingMinDimWithFacesConfig {
  /// Returns a new [FaceDetectionTilingMinDimWithFacesConfig] instance.
  FaceDetectionTilingMinDimWithFacesConfig({
    required this.dim,
    required this.faces,
  });

  /// Minimum original image dimension to consider tiling
  ///
  /// Minimum value: 1
  /// Maximum value: 9007199254740991
  int dim;

  /// Minimum pass-1 face count when original dim threshold is met
  ///
  /// Minimum value: 1
  /// Maximum value: 9007199254740991
  int faces;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FaceDetectionTilingMinDimWithFacesConfig &&
    other.dim == dim &&
    other.faces == faces;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (dim.hashCode) +
    (faces.hashCode);

  @override
  String toString() => 'FaceDetectionTilingMinDimWithFacesConfig[dim=$dim, faces=$faces]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'dim'] = this.dim;
      json[r'faces'] = this.faces;
    return json;
  }

  /// Returns a new [FaceDetectionTilingMinDimWithFacesConfig] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FaceDetectionTilingMinDimWithFacesConfig? fromJson(dynamic value) {
    upgradeDto(value, "FaceDetectionTilingMinDimWithFacesConfig");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return FaceDetectionTilingMinDimWithFacesConfig(
        dim: mapValueOfType<int>(json, r'dim')!,
        faces: mapValueOfType<int>(json, r'faces')!,
      );
    }
    return null;
  }

  static List<FaceDetectionTilingMinDimWithFacesConfig> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FaceDetectionTilingMinDimWithFacesConfig>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FaceDetectionTilingMinDimWithFacesConfig.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FaceDetectionTilingMinDimWithFacesConfig> mapFromJson(dynamic json) {
    final map = <String, FaceDetectionTilingMinDimWithFacesConfig>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FaceDetectionTilingMinDimWithFacesConfig.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FaceDetectionTilingMinDimWithFacesConfig-objects as value to a dart map
  static Map<String, List<FaceDetectionTilingMinDimWithFacesConfig>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FaceDetectionTilingMinDimWithFacesConfig>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FaceDetectionTilingMinDimWithFacesConfig.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'dim',
    'faces',
  };
}

