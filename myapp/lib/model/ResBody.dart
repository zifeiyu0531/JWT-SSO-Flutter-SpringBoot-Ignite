class ResBody {
  String message;
  String statuscode;
  String data;

  ResBody({
    this.message,
    this.statuscode,
    this.data,
  });

  factory ResBody.fromJson(Map<String, dynamic> json) {
    return ResBody(message: json['message'], statuscode: json['statuscode'], data: json['data']);
  }
}