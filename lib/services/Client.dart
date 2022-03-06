import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import 'RecordParser.dart';

/// 客户端配置
class ClientConfig {
  final String host;

  final int port;

  ClientConfig(this.host, {this.port = 32167});
}

/// 客户端异常
class ClientException implements Exception {
  final String message;

  ClientException(this.message) {
    Exception(message);
  }
}

/// 客户端
class Client {
  static final Client _singleton = Client._internal();

  factory Client() {
    return _singleton;
  }

  ClientConfig? _config;

  late RecordParser _parser;

  /// 是否已连接
  bool _isConnected = false;

  Socket? _socket;

  /// 昵称
  String? _nickName;

  Client._internal() {
    _parser = RecordParser("\r\n", _onData);
  }

  /// 更新客户端的配置项 TODO 未实现
  Future<bool> update(ClientConfig config) async {
    _config = config;
    if (!_isConnected) {
      return true;
    }
    // 如果已连接, 则断开连接后重连?
    await stop();
    await start();
    return true;
  }

  /// 启动客户端 TODO 未实现
  Future<void> start() async {
    if (null == _config) {
      throw Exception("请先更新客户端配置");
    }
    _socket = await Socket.connect(_config!.host, _config!.port);
    _socket!.listen((data) {
      try {
        _parser.write(data);
      } on Exception {
        _isConnected = false;
      }
    }, onError: () {
      if (kDebugMode) {
        print("socket onError");
      }
      _isConnected = false;
    }, onDone: () {
      if (kDebugMode) {
        print("socket onDone");
      }
      _isConnected = false;
    }, cancelOnError: true);
    _isConnected = true;
    return;
  }

  void updateNickName(String nickName) {}

  void _onData(Uint8List data) {}

  void _sendData(String data) {
    _socket?.write(data);
  }

  /// 停止客户端
  Future<void> stop() async {
    await _socket?.close();
    _socket = null;
  }
}
