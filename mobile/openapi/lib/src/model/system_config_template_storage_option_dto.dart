//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'system_config_template_storage_option_dto.g.dart';

/// SystemConfigTemplateStorageOptionDto
///
/// Properties:
/// * [dayOptions] - Available day format options for storage template
/// * [hourOptions] - Available hour format options for storage template
/// * [minuteOptions] - Available minute format options for storage template
/// * [monthOptions] - Available month format options for storage template
/// * [presetOptions] - Available preset template options
/// * [secondOptions] - Available second format options for storage template
/// * [weekOptions] - Available week format options for storage template
/// * [yearOptions] - Available year format options for storage template
@BuiltValue()
abstract class SystemConfigTemplateStorageOptionDto implements Built<SystemConfigTemplateStorageOptionDto, SystemConfigTemplateStorageOptionDtoBuilder> {
  /// Available day format options for storage template
  @BuiltValueField(wireName: r'dayOptions')
  BuiltList<String> get dayOptions;

  /// Available hour format options for storage template
  @BuiltValueField(wireName: r'hourOptions')
  BuiltList<String> get hourOptions;

  /// Available minute format options for storage template
  @BuiltValueField(wireName: r'minuteOptions')
  BuiltList<String> get minuteOptions;

  /// Available month format options for storage template
  @BuiltValueField(wireName: r'monthOptions')
  BuiltList<String> get monthOptions;

  /// Available preset template options
  @BuiltValueField(wireName: r'presetOptions')
  BuiltList<String> get presetOptions;

  /// Available second format options for storage template
  @BuiltValueField(wireName: r'secondOptions')
  BuiltList<String> get secondOptions;

  /// Available week format options for storage template
  @BuiltValueField(wireName: r'weekOptions')
  BuiltList<String> get weekOptions;

  /// Available year format options for storage template
  @BuiltValueField(wireName: r'yearOptions')
  BuiltList<String> get yearOptions;

  SystemConfigTemplateStorageOptionDto._();

  factory SystemConfigTemplateStorageOptionDto([void updates(SystemConfigTemplateStorageOptionDtoBuilder b)]) = _$SystemConfigTemplateStorageOptionDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SystemConfigTemplateStorageOptionDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SystemConfigTemplateStorageOptionDto> get serializer => _$SystemConfigTemplateStorageOptionDtoSerializer();
}

class _$SystemConfigTemplateStorageOptionDtoSerializer implements PrimitiveSerializer<SystemConfigTemplateStorageOptionDto> {
  @override
  final Iterable<Type> types = const [SystemConfigTemplateStorageOptionDto, _$SystemConfigTemplateStorageOptionDto];

  @override
  final String wireName = r'SystemConfigTemplateStorageOptionDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SystemConfigTemplateStorageOptionDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'dayOptions';
    yield serializers.serialize(
      object.dayOptions,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'hourOptions';
    yield serializers.serialize(
      object.hourOptions,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'minuteOptions';
    yield serializers.serialize(
      object.minuteOptions,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'monthOptions';
    yield serializers.serialize(
      object.monthOptions,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'presetOptions';
    yield serializers.serialize(
      object.presetOptions,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'secondOptions';
    yield serializers.serialize(
      object.secondOptions,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'weekOptions';
    yield serializers.serialize(
      object.weekOptions,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'yearOptions';
    yield serializers.serialize(
      object.yearOptions,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SystemConfigTemplateStorageOptionDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SystemConfigTemplateStorageOptionDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'dayOptions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.dayOptions.replace(valueDes);
          break;
        case r'hourOptions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.hourOptions.replace(valueDes);
          break;
        case r'minuteOptions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.minuteOptions.replace(valueDes);
          break;
        case r'monthOptions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.monthOptions.replace(valueDes);
          break;
        case r'presetOptions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.presetOptions.replace(valueDes);
          break;
        case r'secondOptions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.secondOptions.replace(valueDes);
          break;
        case r'weekOptions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.weekOptions.replace(valueDes);
          break;
        case r'yearOptions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.yearOptions.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SystemConfigTemplateStorageOptionDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SystemConfigTemplateStorageOptionDtoBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


