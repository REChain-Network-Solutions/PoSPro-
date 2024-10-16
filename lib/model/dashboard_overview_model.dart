class DashboardOverviewModel {
  DashboardOverviewModel({
      String? message, 
      Data? data,}){
    _message = message;
    _data = data;
}

  DashboardOverviewModel.fromJson(dynamic json) {
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
      num? totalItems, 
      num? totalCategories, 
      num? totalIncome, 
      num? totalExpense, 
      num? totalDue, 
      num? stockQty, 
      num? totalLoss, 
      num? totalProfit, 
      num? stockValue,
      List<Sales>? sales,
      List<Purchases>? purchases,}){
    _totalItems = totalItems;
    _totalCategories = totalCategories;
    _totalIncome = totalIncome;
    _totalExpense = totalExpense;
    _totalDue = totalDue;
    // _stockQty = stockQty;
    _totalLoss = totalLoss;
    _totalProfit = totalProfit;
    _sales = sales;
    _purchases = purchases;
}

  Data.fromJson(dynamic json) {
    _totalItems = json['total_items'];
    _totalCategories = json['total_categories'];
    _totalIncome = json['total_income'];
    _totalExpense = json['total_expense'];
    _totalDue = json['total_due'];
    // _stockQty = json['stock_qty'];
    _totalLoss = json['total_loss'];
    _totalProfit = json['total_profit'];
    _stockValue = json['stock_value'];
    if (json['sales'] != null) {
      _sales = [];
      json['sales'].forEach((v) {
        _sales?.add(Sales.fromJson(v));
      });
    }
    if (json['purchases'] != null) {
      _purchases = [];
      json['purchases'].forEach((v) {
        _purchases?.add(Purchases.fromJson(v));
      });
    }
  }
  num? _totalItems;
  num? _totalCategories;
  num? _totalIncome;
  num? _totalExpense;
  num? _totalDue;
  // num? _stockQty;
  num? _totalLoss;
  num? _totalProfit;
  num? _stockValue;
  List<Sales>? _sales;
  List<Purchases>? _purchases;

  num? get totalItems => _totalItems;
  num? get totalCategories => _totalCategories;
  num? get totalIncome => _totalIncome;
  num? get totalExpense => _totalExpense;
  num? get totalDue => _totalDue;
  // num? get stockQty => _stockQty;
  num? get totalLoss => _totalLoss;
  num? get totalProfit => _totalProfit;
  num? get stockValue => _stockValue;
  List<Sales>? get sales => _sales;
  List<Purchases>? get purchases => _purchases;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total_items'] = _totalItems;
    map['total_categories'] = _totalCategories;
    map['total_income'] = _totalIncome;
    map['total_expense'] = _totalExpense;
    map['total_due'] = _totalDue;
    // map['stock_qty'] = _stockQty;
    map['total_loss'] = _totalLoss;
    map['total_profit'] = _totalProfit;
    if (_sales != null) {
      map['sales'] = _sales?.map((v) => v.toJson()).toList();
    }
    if (_purchases != null) {
      map['purchases'] = _purchases?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Purchases {
  Purchases({
      String? date, 
      num? amount,}){
    _date = date;
    _amount = amount;
}

  Purchases.fromJson(dynamic json) {
    _date = json['date'];
    _amount = json['amount'];
  }
  String? _date;
  num? _amount;

  String? get date => _date;
  num? get amount => _amount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['date'] = _date;
    map['amount'] = _amount;
    return map;
  }

}

class Sales {
  Sales({
      String? date, 
      num? amount,}){
    _date = date;
    _amount = amount;
}

  Sales.fromJson(dynamic json) {
    _date = json['date'];
    _amount = json['amount'];
  }
  String? _date;
  num? _amount;

  String? get date => _date;
  num? get amount => _amount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['date'] = _date;
    map['amount'] = _amount;
    return map;
  }

}