//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ExternalOcrWriteResponseDto {
  /// Returns a new [ExternalOcrWriteResponseDto] instance.
  ExternalOcrWriteResponseDto({
    required this.searchTextLength,
    required this.written,
  });

  /// Length of generated search text
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int searchTextLength;

  /// Number of records written
  ///
  /// Minimum value: -9007199254740991
  /// Maximum value: 9007199254740991
  int written;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ExternalOcrWriteResponseDto &&
    other.searchTextLength == searchTextLength &&
    other.written == written;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (searchTextLength.hashCode) +
    (written.hashCode);

  @override
  String toString() => 'ExternalOcrWriteResponseDto[searchTextLength=$searchTextLength, written=$written]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'searchTextLength'] = this.searchTextLength;
      json[r'written'] = this.written;
    return json;
  }

  /// Returns a new [ExternalOcrWriteResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ExternalOcrWriteResponseDto? fromJson(dynamic value) {
    upgradeDto(value, "ExternalOcrWriteResponseDto");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return ExternalOcrWriteResponseDto(
        searchTextLength: mapValueOfType<int>(json, r'searchTextLength')!,
        written: mapValueOfType<int>(json, r'written')!,
      );
    }
    return null;
  }

  static List<ExternalOcrWriteResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ExternalOcrWriteResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ExternalOcrWriteResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ExternalOcrWriteResponseDto> mapFromJson(dynamic json) {
    final map = <String, ExternalOcrWriteResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ExternalOcrWriteResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ExternalOcrWriteResponseDto-objects as value to a dart map
  static Map<String, List<ExternalOcrWriteResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ExternalOcrWriteResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ExternalOcrWriteResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'searchTextLength',
    'written',
  };
}

