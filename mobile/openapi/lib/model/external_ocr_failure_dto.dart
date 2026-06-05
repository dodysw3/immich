//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ExternalOcrFailureDto {
  /// Returns a new [ExternalOcrFailureDto] instance.
  ExternalOcrFailureDto({
    required this.provider,
    required this.reason,
    required this.retriable,
    required this.retryCount,
  });

  /// External OCR provider identifier
  String provider;

  /// Failure reason
  String reason;

  /// Whether the failure is retriable
  bool retriable;

  /// Number of retries attempted
  ///
  /// Minimum value: 0
  /// Maximum value: 9007199254740991
  int retryCount;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ExternalOcrFailureDto &&
    other.provider == provider &&
    other.reason == reason &&
    other.retriable == retriable &&
    other.retryCount == retryCount;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (provider.hashCode) +
    (reason.hashCode) +
    (retriable.hashCode) +
    (retryCount.hashCode);

  @override
  String toString() => 'ExternalOcrFailureDto[provider=$provider, reason=$reason, retriable=$retriable, retryCount=$retryCount]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'provider'] = this.provider;
      json[r'reason'] = this.reason;
      json[r'retriable'] = this.retriable;
      json[r'retryCount'] = this.retryCount;
    return json;
  }

  /// Returns a new [ExternalOcrFailureDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ExternalOcrFailureDto? fromJson(dynamic value) {
    upgradeDto(value, "ExternalOcrFailureDto");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return ExternalOcrFailureDto(
        provider: mapValueOfType<String>(json, r'provider')!,
        reason: mapValueOfType<String>(json, r'reason')!,
        retriable: mapValueOfType<bool>(json, r'retriable')!,
        retryCount: mapValueOfType<int>(json, r'retryCount')!,
      );
    }
    return null;
  }

  static List<ExternalOcrFailureDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ExternalOcrFailureDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ExternalOcrFailureDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ExternalOcrFailureDto> mapFromJson(dynamic json) {
    final map = <String, ExternalOcrFailureDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ExternalOcrFailureDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ExternalOcrFailureDto-objects as value to a dart map
  static Map<String, List<ExternalOcrFailureDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ExternalOcrFailureDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ExternalOcrFailureDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'provider',
    'reason',
    'retriable',
    'retryCount',
  };
}

