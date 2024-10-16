class CurrencyModel {
  CurrencyModel({
    this.id,
    this.name,
    this.countryName,
    this.code,
    this.symbol,
    this.position,
    this.status,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
  });

  CurrencyModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    countryName = json['country_name'];
    code = json['code'];
    symbol = json['symbol'];
    position = json['position'];
    status = json['status'];
    isDefault = json['is_default'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  num? id;
  String? name;
  dynamic countryName;
  String? code;
  String? symbol;
  dynamic position;
  bool? status;
  bool? isDefault;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['country_name'] = countryName;
    map['code'] = code;
    map['symbol'] = symbol;
    map['position'] = position;
    map['status'] = status;
    map['is_default'] = isDefault;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}
