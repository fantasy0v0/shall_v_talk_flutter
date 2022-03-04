import 'dart:typed_data';

class RecordParser {
  final String delimiter;

  final int maxRecordSize;

  late final List<int> _buffer;

  RecordParser(this.delimiter, {this.maxRecordSize = 1048576}) {
    _buffer = List.filled(maxRecordSize * 2, 0, growable: false);
  }

  void write(Uint8List data) {
    _buffer.addAll(data);
    _handleParsing();
  }

  void _handleParsing() {}
}
