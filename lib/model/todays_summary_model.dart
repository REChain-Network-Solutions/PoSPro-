class TodaysSummaryModel {
  TodaysSummaryModel({
      String? message, 
      Data? data,}){
    _message = message;
    _data = data;
}

  TodaysSummaryModel.fromJson(dynamic json) {
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? _message;
  Data? _data;

  String? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

class Data {
  Data({
      num? sales, 
      num? income, 
      num? expense, 
      num? purchase,}){
    _sales = sales;
    _income = income;
    _expense = expense;
    _purchase = purchase;
}

  Data.fromJson(dynamic json) {
    _sales = json['sales'];
    _income = json['income'];
    _expense = json['expense'];
    _purchase = json['purchase'];
  }
  num? _sales;
  num? _income;
  num? _expense;
  num? _purchase;

  num? get sales => _sales;
  num? get income => _income;
  num? get expense => _expense;
  num? get purchase => _purchase;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sales'] = _sales;
    map['income'] = _income;
    map['expense'] = _expense;
    map['purchase'] = _purchase;
    return map;
  }

}