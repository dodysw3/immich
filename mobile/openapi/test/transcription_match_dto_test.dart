import 'package:test/test.dart';
import 'package:openapi/openapi.dart';

// tests for TranscriptionMatchDto
void main() {
  final instance = TranscriptionMatchDtoBuilder();
  // TODO add properties to the builder and call build()

  group(TranscriptionMatchDto, () {
    // TranscriptionMatchDtoComponents components
    test('to test the property `components`', () async {
      // TODO
    });

    // int endMs
    test('to test the property `endMs`', () async {
      // TODO
    });

    // int firstSegment
    test('to test the property `firstSegment`', () async {
      // TODO
    });

    // int lastSegment
    test('to test the property `lastSegment`', () async {
      // TODO
    });

    // Opaque passage id (used for moment retrieval and frame resolution)
    // String passageId
    test('to test the property `passageId`', () async {
      // TODO
    });

    // Source transcript content revision
    // String revision
    test('to test the property `revision`', () async {
      // TODO
    });

    // Source transcription run identity
    // String runKey
    test('to test the property `runKey`', () async {
      // TODO
    });

    // Normalized within-tier score
    // double score
    test('to test the property `score`', () async {
      // TODO
    });

    // Original transcript text of the passage
    // String snippet
    test('to test the property `snippet`', () async {
      // TODO
    });

    // Matched text spans within the snippet (never HTML)
    // BuiltList<TranscriptionSearchSpanDto> spans
    test('to test the property `spans`', () async {
      // TODO
    });

    // Match moment: the start of the first matched segment (segment precision, not word alignment)
    // int startMs
    test('to test the property `startMs`', () async {
      // TODO
    });

    // String tier
    test('to test the property `tier`', () async {
      // TODO
    });

    // Contributing segment range (first:last)
    // String windowId
    test('to test the property `windowId`', () async {
      // TODO
    });

  });
}
