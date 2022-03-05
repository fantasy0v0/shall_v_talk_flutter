import 'dart:io';
import 'dart:typed_data';

/// 客户端配置
class ClientConfig {
  final String host;

  final int port;

  ClientConfig(this.host, {this.port = 32167});
}

/// 客户端
class Client {
  static final Client _singleton = Client._internal();

  factory Client() {
    return _singleton;
  }

  late ClientConfig? _config;

  /// 是否已连接
  bool _IsConnected = false;

  Socket? _socket;

  /// 昵称
  String? _nickName;

  Client._internal() {}

  /// 更新客户端的配置项 TODO 未实现
  Future<bool> update(ClientConfig config) async {
    if (!_IsConnected) {
      _config = config;
      return true;
    }
    // 如果已连接, 则断开连接后重连?
    return false;
  }

  /// 启动客户端 TODO 未实现
  Future<void> start() async {
    if (null == _config) {
      throw Exception("请先更新客户端配置");
    }
    _socket = await Socket.connect(_config!.host, _config!.port);
    _socket!
        .listen(_onData, onError: () {}, onDone: () {}, cancelOnError: true);
    _IsConnected = true;
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
