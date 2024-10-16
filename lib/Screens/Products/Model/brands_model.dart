class Brand {
  Brand({
    this.id,
    this.businessId,
    this.brandName,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Brand.fromJson(dynamic json) {
    id = json['id'];
    businessId = json['business_id'];
    brandName = json['brandName'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  num? id;
  num? businessId;
  String? brandName;
  num? status;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['business_id'] = businessId;
    map['brandName'] = brandName;
    map['status'] = status;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}
