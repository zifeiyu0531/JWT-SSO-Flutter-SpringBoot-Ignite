import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:myapp/model/ResBody.dart';
import 'package:myapp/system/system1.dart';
import 'dart:io';
import 'dart:convert';

import 'package:myapp/util/token.dart';
import 'package:myapp/sign/signup.dart';
import 'package:myapp/util/http.dart';

class Signin extends StatefulWidget {
  @override
  _Signin createState() => new _Signin();
}

class _Signin extends State<Signin> {
  //获取Key用来获取Form表单组件
  GlobalKey<FormState> loginKey = new GlobalKey<FormState>();
  String userName;
  String password;
  bool isShowPassWord = false;
  static TokenStorage tokenStorage = new TokenStorage();
  static BaseOptions options = new BaseOptions(
    headers: {HttpHeaders.acceptHeader: "accept: application/json"},
  );
  Dio dio = new Dio(options);

  void login() {
    var loginForm = loginKey.currentState;
    if (loginForm.validate()) {
      loginForm.save();
      if (userName == null ||
          userName.isEmpty ||
          password == null ||
          password.isEmpty) {
        showDialog<Null>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return new AlertDialog(
              title: new Text('提示'),
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[new Text('用户名&密码不能为空')],
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('确定'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        ).then((val) {});
      } else {
        try {
          var formData = {
            'username': userName,
            'password': password,
          };
          var jsonData = jsonEncode(formData);
          HTTPClient httpPost = new HTTPClient("");
          Future<Response> response =
              httpPost.doPost("http://192.168.1.112:8080/log/login", jsonData);
          response.then((Response response) {
            ResBody resBody = ResBody.fromJson(response.data);
            if (resBody.statuscode == "002") {
              showDialog<Null>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return new AlertDialog(
                    title: new Text('提示'),
                    content: new SingleChildScrollView(
                      child: new ListBody(
                        children: <Widget>[new Text('用户不存在')],
                      ),
                    ),
                    actions: <Widget>[
                      new FlatButton(
                        child: new Text('确定'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              ).then((val) {});
            } else if (resBody.statuscode == "003") {
              showDialog<Null>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return new AlertDialog(
                    title: new Text('提示'),
                    content: new SingleChildScrollView(
                      child: new ListBody(
                        children: <Widget>[new Text('密码错误')],
                      ),
                    ),
                    actions: <Widget>[
                      new FlatButton(
                        child: new Text('确定'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              ).then((val) {});
            } else if (resBody.statuscode == "200") {
              Future<String> token = tokenStorage.setString(resBody.data);
              token.then((String token) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return System1();
                }));
              });
            } else {
              showDialog<Null>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return new AlertDialog(
                    title: new Text('提示'),
                    content: new SingleChildScrollView(
                      child: new ListBody(
                        children: <Widget>[new Text('登录出错，请重试')],
                      ),
                    ),
                    actions: <Widget>[
                      new FlatButton(
                        child: new Text('确定'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              ).then((val) {});
            }
          });
        } catch (e) {
          print(e);
        }
      }
    }
  }

  void signup() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Signup();
    }));
  }

  void showPassWord() {
    setState(() {
      isShowPassWord = !isShowPassWord;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Form表单示例',
      home: new Scaffold(
        body: new Column(
          children: <Widget>[
            new Container(
                padding: EdgeInsets.only(top: 100.0, bottom: 10.0),
                child: new Text(
                  'SSO',
                  style: TextStyle(
                      color: Color.fromARGB(255, 53, 53, 53), fontSize: 50.0),
                )),
            new Container(
              padding: const EdgeInsets.all(16.0),
              child: new Form(
                key: loginKey,
                autovalidate: true,
                child: new Column(
                  children: <Widget>[
                    new Container(
                      decoration: new BoxDecoration(
                          border: new Border(
                              bottom: BorderSide(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  width: 0.5))),
                      child: new TextFormField(
                        decoration: new InputDecoration(
                          labelText: '用户名',
                          labelStyle: new TextStyle(
                              fontSize: 15.0,
                              color: Color.fromARGB(255, 0, 0, 0)),
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.phone,
                        onSaved: (value) {
                          userName = value;
                        },
                        onFieldSubmitted: (value) {},
                      ),
                    ),
                    new Container(
                      decoration: new BoxDecoration(
                          border: new Border(
                              bottom: BorderSide(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  width: 0.5))),
                      child: new TextFormField(
                        decoration: new InputDecoration(
                            labelText: '密码',
                            labelStyle: new TextStyle(
                                fontSize: 15.0,
                                color: Color.fromARGB(255, 93, 93, 93)),
                            border: InputBorder.none,
                            suffixIcon: new IconButton(
                              icon: new Icon(
                                isShowPassWord
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                              onPressed: showPassWord,
                            )),
                        obscureText: !isShowPassWord,
                        onSaved: (value) {
                          password = value;
                        },
                      ),
                    ),
                    new Container(
                      height: 45.0,
                      margin: EdgeInsets.only(top: 40.0),
                      child: new SizedBox.expand(
                        child: new RaisedButton(
                          onPressed: login,
                          color: Color.fromARGB(255, 48, 181, 214),
                          child: new Text(
                            '登录',
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(45.0)),
                        ),
                      ),
                    ),
                    new Container(
                      height: 45.0,
                      margin: EdgeInsets.only(top: 40.0),
                      child: new SizedBox.expand(
                        child: new RaisedButton(
                          onPressed: signup,
                          color: Color.fromARGB(255, 246, 143, 99),
                          child: new Text(
                            '注册',
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(45.0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
