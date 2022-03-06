import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/Client.dart';

Future<ClientConfig?> showConfigDialog(BuildContext context) {
  return showDialog<ClientConfig?>(
      context: context,
      builder: (_) {
        return const _LoginConfig();
      });
}

class _LoginConfig extends StatefulWidget {
  const _LoginConfig({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginConfigState();
  }
}

class _LoginConfigState extends State<_LoginConfig> {
  final _formKey = GlobalKey<FormState>();

  String? _ip;

  String? _port;

  @override
  void initState() {
    super.initState();
    init() async {
      final prefs = await SharedPreferences.getInstance();
      _ip = prefs.getString("_ip");
      _port = prefs.getString("_port");
      setState(() {
        _ip = _ip ?? "127.0.0.1";
        _port = _port ?? "32167";
      });
    }

    init();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (null != _ip && null != _port) {
      children.add(Form(
          key: _formKey,
          child: Padding(
              padding: const EdgeInsets.all(7),
              child: Column(children: [
                buildTextFormField("地址", _ip),
                buildTextFormField("端口", _port),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                      child: const Text("取消"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    ElevatedButton(
                      child: const Text("确定"),
                      onPressed: () {},
                    )
                  ],
                )
              ]))));
    }
    return SimpleDialog(title: const Text("服务端设置"), children: children);
  }

  Widget buildTextFormField(String labelText, String? initialValue) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
          initialValue: initialValue,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: labelText,
              contentPadding: const EdgeInsets.all(7))),
    );
  }
}
