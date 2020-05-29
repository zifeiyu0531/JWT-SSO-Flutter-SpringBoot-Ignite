import 'dart:io';
import 'package:dio/dio.dart';

class HTTPClient {
  static BaseOptions options = new BaseOptions();
  int serviceType = 0;
  String token;
  Dio dio = new Dio();

  HTTPClient (String token) {
    this.token = token;
    options = BaseOptions(
      headers: {
        HttpHeaders.authorizationHeader: "Bearer " + token,
        "ServiceType": serviceType,
      },
    );
    dio = Dio(options);
  }

  void setServiceType(int serviceType){
    this.serviceType = serviceType;
    options = BaseOptions(
      headers: {
        HttpHeaders.authorizationHeader: "Bearer " + this.token,
        "ServiceType": serviceType
      },
    );
    dio = Dio(options);
  }

  String getHeader(){
    return options.headers.toString();
  }

  Future<Response> doPost (var url, var jsonData) async{
    try{
      Response response = await dio.post(
        url,
        data: jsonData,
      );
      return response;
    }catch (e) {
      print(e);
    }
  }

  Future<Response> doGet (var url) async{
    try{
      Response response = await dio.get(url);
      return response;
    }catch (e) {
      print(e);
    }
  }
}