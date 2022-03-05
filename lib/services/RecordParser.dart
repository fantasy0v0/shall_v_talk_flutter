import 'dart:typed_data';

typedef OnData = void Function(Uint8List data);

/// 解析一场
class ParseException implements Exception {
  final String message;

  ParseException(this.message) {
    Exception(message);
  }
}

class RecordParser {
  /// 分隔符
  final String _delimiter;

  /// 当满足分割条件时, 用来通知的回调函数
  final OnData onData;

  /// 最大长度
  final int maxRecordSize;

  /// 缓存
  late final Uint8List _buffer;

  // 缓存开始的索引位置
  int _start = 0;

  // 当前读索引位置
  int _readPos = 0;

  // 当前缓存结束位置(不包含)
  int _end = 0;

  // 当前分隔符索引位置
  int _delimPos = 0;

  RecordParser(this._delimiter, this.onData, {this.maxRecordSize = 1048576}) {
    _buffer = Uint8List(maxRecordSize);
  }

  RecordParser write(Uint8List data) {
    // 判断剩余空间是否足够
    int remain = _buffer.length - _end;
    if (remain <= data.length) {
      // 判断左移后剩余空间是否足够
      if (remain + _start > data.length) {
        // 足够则进行左移操作
        for (int index = _start; index < _end; index++) {
          _buffer[index - _start] = data[index];
        }
        int offset = _start;
        _start = 0;
        _readPos = _readPos - offset;
        _end = _end - offset;
      } else {
        throw ParseException("当前缓存已超出最大上限");
      }
    }
    // 将消息复制进缓存
    for (int index = 0; index < data.length; index++) {
      _buffer[_end + index] = data[index];
    }
    _end += data.length;
    _handleParsing();
    return this;
  }

  void _handleParsing() {
    notify() {
      // 判断是否需要进行分割
      if (_delimPos == _delimiter.length) {
        // 通知
        onData(_buffer.sublist(_start, _readPos));
        _start = _readPos;
        _delimPos = 0;
      }
    }

    ;
    for (; _readPos < _end; _readPos++) {
      notify();
      int ch = _buffer[_readPos];
      if (ch == _delimiter.codeUnitAt(_delimPos)) {
        _delimPos += 1;
      }
    }
    notify();
  }
}
