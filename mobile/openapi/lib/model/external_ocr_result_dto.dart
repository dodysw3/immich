//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ExternalOcrResultDto {
  /// Returns a new [ExternalOcrResultDto] instance.
  ExternalOcrResultDto({
    this.language,
    this.lines = const [],
    required this.mode,
    required this.model,
    required this.modelRevision,
    required this.processedAt,
    required this.provider,
    this.searchText,
    required this.sourceChecksum,
  });

  /// Language hint
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? language;

  /// OCR result lines
  List<ExternalOcrLineDto> lines;

  /// OCR write mode
  ExternalOcrResultDtoModeEnum mode;

  /// Model family/name
  String model;

  /// Model revision for reprocessing control
  String modelRevision;

  /// External OCR completion timestamp (ISO 8601)
  String processedAt;

  /// External OCR provider identifier
  String provider;

  /// Pre-tokenized search text
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? searchText;

  /// SHA256 of original source bytes
  String sourceChecksum;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ExternalOcrResultDto &&
    other.language == language &&
    _deepEquality.equals(other.lines, lines) &&
    other.mode == mode &&
    other.model == model &&
    other.modelRevision == modelRevision &&
    other.processedAt == processedAt &&
    other.provider == provider &&
    other.searchText == searchText &&
    other.sourceChecksum == sourceChecksum;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (language == null ? 0 : language!.hashCode) +
    (lines.hashCode) +
    (mode.hashCode) +
    (model.hashCode) +
    (modelRevision.hashCode) +
    (processedAt.hashCode) +
    (provider.hashCode) +
    (searchText == null ? 0 : searchText!.hashCode) +
    (sourceChecksum.hashCode);

  @override
  String toString() => 'ExternalOcrResultDto[language=$language, lines=$lines, mode=$mode, model=$model, modelRevision=$modelRevision, processedAt=$processedAt, provider=$provider, searchText=$searchText, sourceChecksum=$sourceChecksum]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.language != null) {
      json[r'language'] = this.language;
    } else {
    //  json[r'language'] = null;
    }
      json[r'lines'] = this.lines;
      json[r'mode'] = this.mode;
      json[r'model'] = this.model;
      json[r'modelRevision'] = this.modelRevision;
      json[r'processedAt'] = this.processedAt;
      json[r'provider'] = this.provider;
    if (this.searchText != null) {
      json[r'searchText'] = this.searchText;
    } else {
    //  json[r'searchText'] = null;
    }
      json[r'sourceChecksum'] = this.sourceChecksum;
    return json;
  }

  /// Returns a new [ExternalOcrResultDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ExternalOcrResultDto? fromJson(dynamic value) {
    upgradeDto(value, "ExternalOcrResultDto");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return ExternalOcrResultDto(
        language: mapValueOfType<String>(json, r'language'),
        lines: ExternalOcrLineDto.listFromJson(json[r'lines']),
        mode: ExternalOcrResultDtoModeEnum.fromJson(json[r'mode'])!,
        model: mapValueOfType<String>(json, r'model')!,
        modelRevision: mapValueOfType<String>(json, r'modelRevision')!,
        processedAt: mapValueOfType<String>(json, r'processedAt')!,
        provider: mapValueOfType<String>(json, r'provider')!,
        searchText: mapValueOfType<String>(json, r'searchText'),
        sourceChecksum: mapValueOfType<String>(json, r'sourceChecksum')!,
      );
    }
    return null;
  }

  static List<ExternalOcrResultDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ExternalOcrResultDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ExternalOcrResultDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ExternalOcrResultDto> mapFromJson(dynamic json) {
    final map = <String, ExternalOcrResultDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ExternalOcrResultDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ExternalOcrResultDto-objects as value to a dart map
  static Map<String, List<ExternalOcrResultDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ExternalOcrResultDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ExternalOcrResultDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'lines',
    'mode',
    'model',
    'modelRevision',
    'processedAt',
    'provider',
    'sourceChecksum',
  };
}

/// OCR write mode
class ExternalOcrResultDtoModeEnum {
  /// Instantiate a new enum with the provided [value].
  const ExternalOcrResultDtoModeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const replace = ExternalOcrResultDtoModeEnum._(r'replace');
  static const merge = ExternalOcrResultDtoModeEnum._(r'merge');

  /// List of all possible values in this [enum][ExternalOcrResultDtoModeEnum].
  static const values = <ExternalOcrResultDtoModeEnum>[
    replace,
    merge,
  ];

  static ExternalOcrResultDtoModeEnum? fromJson(dynamic value) => ExternalOcrResultDtoModeEnumTypeTransformer().decode(value);

  static List<ExternalOcrResultDtoModeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ExternalOcrResultDtoModeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ExternalOcrResultDtoModeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ExternalOcrResultDtoModeEnum] to String,
/// and [decode] dynamic data back to [ExternalOcrResultDtoModeEnum].
class ExternalOcrResultDtoModeEnumTypeTransformer {
  factory ExternalOcrResultDtoModeEnumTypeTransformer() => _instance ??= const ExternalOcrResultDtoModeEnumTypeTransformer._();

  const ExternalOcrResultDtoModeEnumTypeTransformer._();

  String encode(ExternalOcrResultDtoModeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a ExternalOcrResultDtoModeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ExternalOcrResultDtoModeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'replace': return ExternalOcrResultDtoModeEnum.replace;
        case r'merge': return ExternalOcrResultDtoModeEnum.merge;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [ExternalOcrResultDtoModeEnumTypeTransformer] instance.
  static ExternalOcrResultDtoModeEnumTypeTransformer? _instance;
}


