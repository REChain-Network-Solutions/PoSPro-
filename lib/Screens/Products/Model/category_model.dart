

class CategoryModel {
  CategoryModel({
    this.id,
    this.categoryName,
    this.businessId,
    this.variationCapacity,
    this.variationColor,
    this.variationSize,
    this.variationType,
    this.variationWeight,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  CategoryModel.fromJson(dynamic json) {
    id = json['id'];
    categoryName = json['categoryName'];
    businessId = json['business_id'];
    variationCapacity = json['variationCapacity'];
    variationColor = json['variationColor'];
    variationSize = json['variationSize'];
    variationType = json['variationType'];
    variationWeight = json['variationWeight'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  num? id;
  String? categoryName;
  num? businessId;
  bool? variationCapacity;
  bool? variationColor;
  bool? variationSize;
  bool? variationType;
  bool? variationWeight;
  num? status;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['categoryName'] = categoryName;
    map['business_id'] = businessId;
    map['variationCapacity'] = variationCapacity;
    map['variationColor'] = variationColor;
    map['variationSize'] = variationSize;
    map['variationType'] = variationType;
    map['variationWeight'] = variationWeight;
    map['status'] = status;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}


class GetCategoryAndVariationModel {
  GetCategoryAndVariationModel({required this.categoryName, required this.variations});

  final CategoryModel categoryName;
  final List<String> variations;
}
