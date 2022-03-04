import 'package:flutter/material.dart';

/// 登录页面
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;

  String? _nickName;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // 构建表单
    Form form = Form(
        autovalidateMode: AutovalidateMode.always,
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: size.width,
              // 固定大小
              height: size.height / 2,
              // 固定大小
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              color: Colors.lightBlue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Shall We Talk?",
                      style: TextStyle(fontSize: 32, color: Colors.white))
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Column(
                children: [
                  buildTextFormField("昵称",
                      initialValue: _nickName, onSaved: onUpdateNickName),
                  ElevatedButton(
                    child: const Text("进入"),
                    onPressed: doLogin,
                  )
                ],
              ),
            ),
          ],
        ));

    return Scaffold(
        appBar: AppBar(title: const Text("登录")),
        body: SingleChildScrollView(
          child: Container(
            child: form,
          ),
        ));
  }

  // 更新昵称
  void onUpdateNickName(String? value) {
    if (null != value) {
      setState(() {
        _nickName = value;
      });
    }
  }

  // 字段校验
  String? _validate(String? value) {
    if (null == value || value.isEmpty) {
      return '请输入';
    }
    if (value.length < 5) {
      return '请检查内容是否正确';
    }
    return null;
  }

  // 构建TextFormField
  TextFormField buildTextFormField(String labelText,
      {String? initialValue,
      Widget? suffixIcon,
      FormFieldSetter<String?>? onSaved,
      bool obscureText = false}) {
    return TextFormField(
      initialValue: initialValue,
      enabled: !_loading,
      validator: _validate,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
          contentPadding: const EdgeInsets.all(14)),
      obscureText: obscureText,
      onSaved: onSaved,
    );
  }

  void doLogin() {
    if (_loading) return;
    var currentState = _formKey.currentState;
    if (null == currentState) {
      return;
    }

    if (!currentState.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });
    currentState.save();
  }
}
