class ProductModel {
  ProductModel({
    this.id,
    this.productName,
    this.businessId,
    this.unitId,
    this.brandId,
    this.categoryId,
    this.productCode,
    this.productPicture,
    this.productDealerPrice,
    this.productPurchasePrice,
    this.productSalePrice,
    this.productWholeSalePrice,
    this.productStock,
    this.productDiscount,
    this.size,
    this.type,
    this.color,
    this.weight,
    this.capacity,
    this.productManufacturer,
    this.createdAt,
    this.updatedAt,
    this.unit,
    this.brand,
    this.category,
  });

  ProductModel.fromJson(dynamic json) {
    id = json['id'];
    productName = json['productName'];
    businessId = json['business_id'];
    unitId = json['unit_id'];
    brandId = json['brand_id'];
    categoryId = json['category_id'];
    productCode = json['productCode'];
    productPicture = json['productPicture'];
    productDealerPrice = json['productDealerPrice'];
    productPurchasePrice = json['productPurchasePrice'];
    productSalePrice = json['productSalePrice'];
    productWholeSalePrice = json['productWholeSalePrice'];
    productStock = json['productStock'];
    productDiscount = json['productDiscount'];
    size = json['size'];
    type = json['type'];
    color = json['color'];
    weight = json['weight'];
    capacity = json['capacity'];
    productManufacturer = json['productManufacturer'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    unit = json['unit'] != null ? Unit.fromJson(json['unit']) : null;
    brand = json['brand'] != null ? Brand.fromJson(json['brand']) : null;
    category = json['category'] != null ? Category.fromJson(json['category']) : null;
  }
  num? id;
  String? productName;
  num? businessId;
  num? unitId;
  num? brandId;
  num? categoryId;
  String? productCode;
  String? productPicture;
  num? productDealerPrice;
  num? productPurchasePrice;
  num? productSalePrice;
  num? productWholeSalePrice;
  num? productStock;
  num? productDiscount;
  String? size;
  String? type;
  String? color;
  String? weight;
  String? capacity;
  String? productManufacturer;
  String? createdAt;
  String? updatedAt;
  Unit? unit;
  Brand? brand;
  Category? category;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['productName'] = productName;
    map['business_id'] = businessId;
    map['unit_id'] = unitId;
    map['brand_id'] = brandId;
    map['category_id'] = categoryId;
    map['productCode'] = productCode;
    map['productPicture'] = productPicture;
    map['productDealerPrice'] = productDealerPrice;
    map['productPurchasePrice'] = productPurchasePrice;
    map['productSalePrice'] = productSalePrice;
    map['productWholeSalePrice'] = productWholeSalePrice;
    map['productStock'] = productStock;
    map['productDiscount'] = productDiscount;
    map['size'] = size;
    map['type'] = type;
    map['color'] = color;
    map['weight'] = weight;
    map['capacity'] = capacity;
    map['productManufacturer'] = productManufacturer;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (unit != null) {
      map['unit'] = unit?.toJson();
    }
    if (brand != null) {
      map['brand'] = brand?.toJson();
    }
    if (category != null) {
      map['category'] = category?.toJson();
    }
    return map;
  }
}

class Category {
  Category({
    this.id,
    this.categoryName,
  });

  Category.fromJson(dynamic json) {
    id = json['id'];
    categoryName = json['categoryName'];
  }
  num? id;
  String? categoryName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['categoryName'] = categoryName;
    return map;
  }
}

class Brand {
  Brand({
    this.id,
    this.brandName,
  });

  Brand.fromJson(dynamic json) {
    id = json['id'];
    brandName = json['brandName'];
  }
  num? id;
  String? brandName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['brandName'] = brandName;
    return map;
  }
}

class Unit {
  Unit({
    this.id,
    this.unitName,
  });

  Unit.fromJson(dynamic json) {
    id = json['id'];
    unitName = json['unitName'];
  }
  num? id;
  String? unitName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['unitName'] = unitName;
    return map;
  }
}
