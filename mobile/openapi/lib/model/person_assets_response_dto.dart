//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PersonAssetsResponseDto {
  /// Returns a new [PersonAssetsResponseDto] instance.
  PersonAssetsResponseDto({
    this.assets = const [],
    required this.total,
  });

  /// Assets sorted by recognition time
  List<PersonAssetsResponseDtoAssetsInner> assets;

  /// Total number of assets
  ///
  /// Minimum value: 0
  /// Maximum value: 9007199254740991
  int total;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PersonAssetsResponseDto &&
    _deepEquality.equals(other.assets, assets) &&
    other.total == total;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (assets.hashCode) +
    (total.hashCode);

  @override
  String toString() => 'PersonAssetsResponseDto[assets=$assets, total=$total]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'assets'] = this.assets;
      json[r'total'] = this.total;
    return json;
  }

  /// Returns a new [PersonAssetsResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PersonAssetsResponseDto? fromJson(dynamic value) {
    upgradeDto(value, "PersonAssetsResponseDto");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return PersonAssetsResponseDto(
        assets: PersonAssetsResponseDtoAssetsInner.listFromJson(json[r'assets']),
        total: mapValueOfType<int>(json, r'total')!,
      );
    }
    return null;
  }

  static List<PersonAssetsResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PersonAssetsResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PersonAssetsResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PersonAssetsResponseDto> mapFromJson(dynamic json) {
    final map = <String, PersonAssetsResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PersonAssetsResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PersonAssetsResponseDto-objects as value to a dart map
  static Map<String, List<PersonAssetsResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PersonAssetsResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PersonAssetsResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'assets',
    'total',
  };
}

