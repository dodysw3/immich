//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FaceDetectionTilingConfig {
  /// Returns a new [FaceDetectionTilingConfig] instance.
  FaceDetectionTilingConfig({
    required this.enabled,
    required this.maxTiles,
    required this.tileOverlap,
    required this.tileSize,
    required this.triggers,
  });

  /// Enable tiled face detection for large/group photos
  bool enabled;

  /// Maximum number of tiles before downscaling
  ///
  /// Minimum value: 1
  /// Maximum value: 9007199254740991
  int maxTiles;

  /// Overlap ratio between adjacent tiles
  ///
  /// Minimum value: 0
  /// Maximum value: 0.9
  double tileOverlap;

  /// Tile size in pixels for tiled detection
  ///
  /// Minimum value: 128
  /// Maximum value: 9007199254740991
  int tileSize;

  FaceDetectionTilingTriggersConfig triggers;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FaceDetectionTilingConfig &&
    other.enabled == enabled &&
    other.maxTiles == maxTiles &&
    other.tileOverlap == tileOverlap &&
    other.tileSize == tileSize &&
    other.triggers == triggers;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (enabled.hashCode) +
    (maxTiles.hashCode) +
    (tileOverlap.hashCode) +
    (tileSize.hashCode) +
    (triggers.hashCode);

  @override
  String toString() => 'FaceDetectionTilingConfig[enabled=$enabled, maxTiles=$maxTiles, tileOverlap=$tileOverlap, tileSize=$tileSize, triggers=$triggers]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'enabled'] = this.enabled;
      json[r'maxTiles'] = this.maxTiles;
      json[r'tileOverlap'] = this.tileOverlap;
      json[r'tileSize'] = this.tileSize;
      json[r'triggers'] = this.triggers;
    return json;
  }

  /// Returns a new [FaceDetectionTilingConfig] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FaceDetectionTilingConfig? fromJson(dynamic value) {
    upgradeDto(value, "FaceDetectionTilingConfig");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return FaceDetectionTilingConfig(
        enabled: mapValueOfType<bool>(json, r'enabled')!,
        maxTiles: mapValueOfType<int>(json, r'maxTiles')!,
        tileOverlap: (mapValueOfType<num>(json, r'tileOverlap')!).toDouble(),
        tileSize: mapValueOfType<int>(json, r'tileSize')!,
        triggers: FaceDetectionTilingTriggersConfig.fromJson(json[r'triggers'])!,
      );
    }
    return null;
  }

  static List<FaceDetectionTilingConfig> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FaceDetectionTilingConfig>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FaceDetectionTilingConfig.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FaceDetectionTilingConfig> mapFromJson(dynamic json) {
    final map = <String, FaceDetectionTilingConfig>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FaceDetectionTilingConfig.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FaceDetectionTilingConfig-objects as value to a dart map
  static Map<String, List<FaceDetectionTilingConfig>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FaceDetectionTilingConfig>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FaceDetectionTilingConfig.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'enabled',
    'maxTiles',
    'tileOverlap',
    'tileSize',
    'triggers',
  };
}

