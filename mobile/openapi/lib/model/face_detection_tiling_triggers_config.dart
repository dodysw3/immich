//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FaceDetectionTilingTriggersConfig {
  /// Returns a new [FaceDetectionTilingTriggersConfig] instance.
  FaceDetectionTilingTriggersConfig({
    required this.minDimWithFaces,
    required this.minPass1Faces,
  });

  FaceDetectionTilingMinDimWithFacesConfig minDimWithFaces;

  /// Minimum pass-1 face count to trigger tiling
  ///
  /// Minimum value: 1
  /// Maximum value: 9007199254740991
  int minPass1Faces;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FaceDetectionTilingTriggersConfig &&
    other.minDimWithFaces == minDimWithFaces &&
    other.minPass1Faces == minPass1Faces;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (minDimWithFaces.hashCode) +
    (minPass1Faces.hashCode);

  @override
  String toString() => 'FaceDetectionTilingTriggersConfig[minDimWithFaces=$minDimWithFaces, minPass1Faces=$minPass1Faces]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'minDimWithFaces'] = this.minDimWithFaces;
      json[r'minPass1Faces'] = this.minPass1Faces;
    return json;
  }

  /// Returns a new [FaceDetectionTilingTriggersConfig] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FaceDetectionTilingTriggersConfig? fromJson(dynamic value) {
    upgradeDto(value, "FaceDetectionTilingTriggersConfig");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return FaceDetectionTilingTriggersConfig(
        minDimWithFaces: FaceDetectionTilingMinDimWithFacesConfig.fromJson(json[r'minDimWithFaces'])!,
        minPass1Faces: mapValueOfType<int>(json, r'minPass1Faces')!,
      );
    }
    return null;
  }

  static List<FaceDetectionTilingTriggersConfig> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FaceDetectionTilingTriggersConfig>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FaceDetectionTilingTriggersConfig.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FaceDetectionTilingTriggersConfig> mapFromJson(dynamic json) {
    final map = <String, FaceDetectionTilingTriggersConfig>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FaceDetectionTilingTriggersConfig.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FaceDetectionTilingTriggersConfig-objects as value to a dart map
  static Map<String, List<FaceDetectionTilingTriggersConfig>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FaceDetectionTilingTriggersConfig>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FaceDetectionTilingTriggersConfig.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'minDimWithFaces',
    'minPass1Faces',
  };
}

