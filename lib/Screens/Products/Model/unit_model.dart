class Unit {
  Unit({
    this.id,
    this.unitName,
    this.businessId,
    this.status,
    this.createdAt,
    this.updatedAt,});

  Unit.fromJson(dynamic json) {
    id = json['id'];
    unitName = json['unitName'];
    businessId = json['business_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  num? id;
  String? unitName;
  num? businessId;
  num? status;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['unitName'] = unitName;
    map['business_id'] = businessId;
    map['status'] = status;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}