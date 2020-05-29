import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:myapp/sign/signin.dart';
import 'package:myapp/model/ResBody.dart';
import 'package:myapp/util/token.dart';
import 'package:myapp/util/http.dart';
import 'system1.dart';

class System2 extends StatefulWidget {
  @override
  _System2 createState() => new _System2();
}

class _System2 extends State<System2> {
  bool isAccess = false;
  int serviceType = 2;
  static TokenStorage tokenStorage = new TokenStorage();

  void change() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return System1();
    }));
  }

  void getAccess() {
    Future<String> token = tokenStorage.getString();
    token.then((String token) {
      HTTPClient httpGet = new HTTPClient(token);
      httpGet.setServiceType(serviceType);
      Future<Response> response =
          httpGet.doGet("http://192.168.1.112:8080/secure/user");
      response.then((Response response) {
        ResBody resBody = ResBody.fromJson(response.data);
        if (resBody.statuscode == "001") {
          showDialog<Null>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return new AlertDialog(
                title: new Text('提示'),
                content: new SingleChildScrollView(
                  child: new ListBody(
                    children: <Widget>[new Text('尚未登录或Token已失效，前往登录页面')],
                  ),
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text('确定'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Signin();
                      }));
                    },
                  ),
                ],
              );
            },
          ).then((val) {});
        } else {
          if (resBody.message == "1") {
            showDialog<Null>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return new AlertDialog(
                  title: new Text('System1'),
                  content: new SingleChildScrollView(
                    child: new ListBody(
                      children: <Widget>[
                        new Text('√您有权使用此服务',
                            style: TextStyle(
                                color: Color.fromARGB(255, 141, 197, 132),
                                fontSize: 30.0))
                      ],
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
            showDialog<Null>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return new AlertDialog(
                  title: new Text('System2'),
                  content: new SingleChildScrollView(
                    child: new ListBody(
                      children: <Widget>[
                        new Text('×您无权使用此服务',
                            style: TextStyle(
                                color: Color.fromARGB(255, 246, 143, 99),
                                fontSize: 30.0))
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text('确定'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return System1();
                        }));
                      },
                    ),
                  ],
                );
              },
            ).then((val) {});
          }
        }
      });
    });
  }

  void logout() {
    tokenStorage.setString("null");
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Signin();
    }));
  }

  @override
  Widget build(BuildContext context) {
    getAccess();
    return MaterialApp(
        title: 'System1',
        home: new Scaffold(
            body: new Column(children: <Widget>[
          new Container(
              padding: EdgeInsets.only(top: 100.0, bottom: 10.0),
              child: new Text(
                'System2',
                style: TextStyle(
                    color: Color.fromARGB(255, 53, 53, 53), fontSize: 50.0),
              )),
          new Container(
              padding: EdgeInsets.only(top: 100.0, bottom: 10.0),
              child: new Text(
                '此Microservice只有权限为ADMIN的用户才能使用',
                style: TextStyle(
                    color: Color.fromARGB(255, 53, 53, 53), fontSize: 20.0),
                textAlign: TextAlign.center,
              )),
          new Container(
            height: 45.0,
            margin: EdgeInsets.only(top: 100.0),
            child: new SizedBox.expand(
              child: new RaisedButton(
                onPressed: change,
                color: Color.fromARGB(255, 48, 181, 214),
                child: new Text(
                  '转入System1',
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
            margin: EdgeInsets.only(top: 20.0),
            child: new SizedBox.expand(
              child: new RaisedButton(
                onPressed: logout,
                color: Color.fromARGB(255, 246, 143, 99),
                child: new Text(
                  '注销用户',
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Color.fromARGB(255, 255, 255, 255)),
                ),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(45.0)),
              ),
            ),
          ),
        ])));
  }
}
