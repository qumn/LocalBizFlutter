import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' as go;

import '../api/login.dart';
import 'package:local_biz/persistent/persistent.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _unameController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _unameController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: "用户名",
                  hintText: "其输入您的用户名",
                ),
                validator: (v) {
                  return v!.trim().isNotEmpty ? null : "用户名不能为空";
                },
              ),
              TextFormField(
                controller: _pwdController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.password),
                  labelText: "密码",
                  hintText: "请输入您的密码",
                ),
                obscureText: true,
                validator: (v) {
                  return v!.trim().isNotEmpty ? null : "密码不能为空";
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 28.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("登录"),
                        ),
                        onPressed: () {
                          // 通过_formKey.currentState 获取FormState后，
                          // 调用validate()方法校验用户名密码是否合法，校验
                          // 通过后再提交数据。
                          if ((_formKey.currentState as FormState).validate()) {
                            final username = _unameController.text;
                            final password = _pwdController.text;
                            login(username, password).then((uuid) {
                              if (uuid == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('密码错误, 请重试')));
                              } else {
                                setToken(uuid).then((v) {
                                  go.GoRouter.of(context).go('/merchant');
                                });
                              }
                            });
                            //验证通过提交数据
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
