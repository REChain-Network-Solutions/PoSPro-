class ExpenseCategory {
  ExpenseCategory({
    this.id,
    this.categoryName,
    this.businessId,
    this.categoryDescription,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  ExpenseCategory.fromJson(dynamic json) {
    id = json['id'];
    categoryName = json['categoryName'];
    businessId = json['business_id'];
    categoryDescription = json['categoryDescription'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  num? id;
  String? categoryName;
  num? businessId;
  String? categoryDescription;
  bool? status;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['categoryName'] = categoryName;
    map['business_id'] = businessId;
    map['categoryDescription'] = categoryDescription;
    map['status'] = status;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}
