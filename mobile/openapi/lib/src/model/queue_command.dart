//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'queue_command.g.dart';

/// Queue command to execute
class QueueCommand extends EnumClass {

  @BuiltValueEnumConst(wireName: r'start')
  static const QueueCommand start = _$start;
  @BuiltValueEnumConst(wireName: r'pause')
  static const QueueCommand pause = _$pause;
  @BuiltValueEnumConst(wireName: r'resume')
  static const QueueCommand resume = _$resume;
  @BuiltValueEnumConst(wireName: r'empty')
  static const QueueCommand empty = _$empty;
  @BuiltValueEnumConst(wireName: r'clear-failed')
  static const QueueCommand clearFailed = _$clearFailed;

  static Serializer<QueueCommand> get serializer => _$queueCommandSerializer;

  const QueueCommand._(String name): super(name);

  static BuiltSet<QueueCommand> get values => _$values;
  static QueueCommand valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class QueueCommandMixin = Object with _$QueueCommandMixin;

