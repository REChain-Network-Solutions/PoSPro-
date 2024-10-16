class LogInResponseModel {
  LogInResponseModel({
      this.message, 
      this.data,});

  LogInResponseModel.fromJson(dynamic json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? message;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

class Data {
  Data({
      this.name, 
      this.email, 
      this.isSetupped, 
      this.token,});

  Data.fromJson(dynamic json) {
    name = json['name'];
    email = json['email'];
    isSetupped = json['is_setupped'];
    token = json['token'];
  }
  String? name;
  String? email;
  bool? isSetupped;
  String? token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['email'] = email;
    map['is_setupped'] = isSetupped;
    map['token'] = token;
    return map;
  }

}