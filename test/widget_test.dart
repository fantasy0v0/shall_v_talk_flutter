// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:shall_v_talk_flutter/services/RecordParser.dart';

void main() {
  test("RecordParserTest00", () {
    int count = 0;
    String? message;
    RecordParser parser = RecordParser("\r\n", (data) {
      message = utf8.decode(data);
      count += 1;
    });

    String expectMessage = "{test}\r\n";
    Uint8List data =
        Uint8List.fromList(expectMessage.runes.map((e) => e).toList());
    parser.write(data);
    expect(message, expectMessage, reason: "没有正确解析出消息");
    expect(count, 1, reason: "应该只有一条消息");
  });

  test("RecordParserTest01", () {
    String expectMessage = "{test}\r\n";
    Uint8List data =
        Uint8List.fromList(expectMessage.runes.map((e) => e).toList());

    int count = 0;
    RecordParser parser = RecordParser("\r\n", (data) {
      count += 1;
    }, maxRecordSize: expectMessage.length * 2 - 1);

    parser.write(data).write(data);
    expect(count, 2, reason: "应该分割了2条消息");
  });

  test("RecordParserTest02", () {
    String expectMessage = "{test}";
    Uint8List data =
        Uint8List.fromList(expectMessage.runes.map((e) => e).toList());

    int count = 0;
    RecordParser parser = RecordParser("\r\n", (data) {
      count += 1;
    }, maxRecordSize: expectMessage.length * 2 - 1);
    parser.write(data);

    try {
      parser.write(data);
      expect(true, false, reason: "错误的流程");
    } on ParseException catch (e) {
      expect(e.message, "当前缓存已超出最大上限");
    }
    expect(count, 0, reason: "应该没有消息被解析");
  });

  /*testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });*/
}
