//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ExternalOcrLineDto {
  /// Returns a new [ExternalOcrLineDto] instance.
  ExternalOcrLineDto({
    required this.boxScore,
    required this.text,
    required this.textScore,
    required this.x1,
    required this.x2,
    required this.x3,
    required this.x4,
    required this.y1,
    required this.y2,
    required this.y3,
    required this.y4,
  });

  /// Detection confidence
  ///
  /// Minimum value: 0
  /// Maximum value: 1
  num boxScore;

  /// Recognized text
  String text;

  /// Text recognition confidence
  ///
  /// Minimum value: 0
  /// Maximum value: 1
  num textScore;

  /// Bounding box x1
  ///
  /// Minimum value: 0
  /// Maximum value: 1
  num x1;

  /// Bounding box x2
  ///
  /// Minimum value: 0
  /// Maximum value: 1
  num x2;

  /// Bounding box x3
  ///
  /// Minimum value: 0
  /// Maximum value: 1
  num x3;

  /// Bounding box x4
  ///
  /// Minimum value: 0
  /// Maximum value: 1
  num x4;

  /// Bounding box y1
  ///
  /// Minimum value: 0
  /// Maximum value: 1
  num y1;

  /// Bounding box y2
  ///
  /// Minimum value: 0
  /// Maximum value: 1
  num y2;

  /// Bounding box y3
  ///
  /// Minimum value: 0
  /// Maximum value: 1
  num y3;

  /// Bounding box y4
  ///
  /// Minimum value: 0
  /// Maximum value: 1
  num y4;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ExternalOcrLineDto &&
    other.boxScore == boxScore &&
    other.text == text &&
    other.textScore == textScore &&
    other.x1 == x1 &&
    other.x2 == x2 &&
    other.x3 == x3 &&
    other.x4 == x4 &&
    other.y1 == y1 &&
    other.y2 == y2 &&
    other.y3 == y3 &&
    other.y4 == y4;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (boxScore.hashCode) +
    (text.hashCode) +
    (textScore.hashCode) +
    (x1.hashCode) +
    (x2.hashCode) +
    (x3.hashCode) +
    (x4.hashCode) +
    (y1.hashCode) +
    (y2.hashCode) +
    (y3.hashCode) +
    (y4.hashCode);

  @override
  String toString() => 'ExternalOcrLineDto[boxScore=$boxScore, text=$text, textScore=$textScore, x1=$x1, x2=$x2, x3=$x3, x4=$x4, y1=$y1, y2=$y2, y3=$y3, y4=$y4]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'boxScore'] = this.boxScore;
      json[r'text'] = this.text;
      json[r'textScore'] = this.textScore;
      json[r'x1'] = this.x1;
      json[r'x2'] = this.x2;
      json[r'x3'] = this.x3;
      json[r'x4'] = this.x4;
      json[r'y1'] = this.y1;
      json[r'y2'] = this.y2;
      json[r'y3'] = this.y3;
      json[r'y4'] = this.y4;
    return json;
  }

  /// Returns a new [ExternalOcrLineDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ExternalOcrLineDto? fromJson(dynamic value) {
    upgradeDto(value, "ExternalOcrLineDto");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return ExternalOcrLineDto(
        boxScore: num.parse('${json[r'boxScore']}'),
        text: mapValueOfType<String>(json, r'text')!,
        textScore: num.parse('${json[r'textScore']}'),
        x1: num.parse('${json[r'x1']}'),
        x2: num.parse('${json[r'x2']}'),
        x3: num.parse('${json[r'x3']}'),
        x4: num.parse('${json[r'x4']}'),
        y1: num.parse('${json[r'y1']}'),
        y2: num.parse('${json[r'y2']}'),
        y3: num.parse('${json[r'y3']}'),
        y4: num.parse('${json[r'y4']}'),
      );
    }
    return null;
  }

  static List<ExternalOcrLineDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ExternalOcrLineDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ExternalOcrLineDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ExternalOcrLineDto> mapFromJson(dynamic json) {
    final map = <String, ExternalOcrLineDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ExternalOcrLineDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ExternalOcrLineDto-objects as value to a dart map
  static Map<String, List<ExternalOcrLineDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ExternalOcrLineDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ExternalOcrLineDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'boxScore',
    'text',
    'textScore',
    'x1',
    'x2',
    'x3',
    'x4',
    'y1',
    'y2',
    'y3',
    'y4',
  };
}

