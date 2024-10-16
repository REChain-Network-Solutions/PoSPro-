class PurchaseTransaction {
  PurchaseTransaction({
    this.id,
    this.partyId,
    this.businessId,
    this.userId,
    this.discountAmount,
    this.dueAmount,
    this.paidAmount,
    this.totalAmount,
    this.invoiceNumber,
    this.isPaid,
    this.paymentType,
    this.purchaseDate,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.party,
    this.details,
  });

  PurchaseTransaction.fromJson(dynamic json) {
    id = json['id'];
    partyId = json['party_id'];
    businessId = json['business_id'];
    userId = json['user_id'];
    discountAmount = json['discountAmount'];
    dueAmount = json['dueAmount'];
    paidAmount = json['paidAmount'];
    totalAmount = json['totalAmount'];
    invoiceNumber = json['invoiceNumber'];
    isPaid = json['isPaid'];
    paymentType = json['paymentType'];
    purchaseDate = json['purchaseDate'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    party = json['party'] != null ? Party.fromJson(json['party']) : null;
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details?.add(Details.fromJson(v));
      });
    }
  }
  num? id;
  num? partyId;
  num? businessId;
  num? userId;
  num? discountAmount;
  num? dueAmount;
  num? paidAmount;
  num? totalAmount;
  String? invoiceNumber;
  bool? isPaid;
  String? paymentType;
  String? purchaseDate;
  String? createdAt;
  String? updatedAt;
  User? user;
  Party? party;
  List<Details>? details;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['party_id'] = partyId;
    map['business_id'] = businessId;
    map['user_id'] = userId;
    map['discountAmount'] = discountAmount;
    map['dueAmount'] = dueAmount;
    map['paidAmount'] = paidAmount;
    map['totalAmount'] = totalAmount;
    map['invoiceNumber'] = invoiceNumber;
    map['isPaid'] = isPaid;
    map['paymentType'] = paymentType;
    map['purchaseDate'] = purchaseDate;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    if (party != null) {
      map['party'] = party?.toJson();
    }
    if (details != null) {
      map['details'] = details?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Details {
  Details({
    this.id,
    this.purchaseId,
    this.productId,
    this.productPurchasePrice,
    this.quantities,
    this.product,
  });

  Details.fromJson(dynamic json) {
    id = json['id'];
    purchaseId = json['purchase_id'];
    productId = json['product_id'];
    productPurchasePrice = json['productPurchasePrice'];
    quantities = json['quantities'];
    product = json['product'] != null ? Product.fromJson(json['product']) : null;
  }
  num? id;
  num? purchaseId;
  num? productId;
  num? productPurchasePrice;
  num? quantities;
  Product? product;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['purchase_id'] = purchaseId;
    map['product_id'] = productId;
    map['productPurchasePrice'] = productPurchasePrice;
    map['quantities'] = quantities;
    if (product != null) {
      map['product'] = product?.toJson();
    }
    return map;
  }
}

class Product {
  Product({
    this.id,
    this.productName,
    this.categoryId,
    this.category,
  });

  Product.fromJson(dynamic json) {
    id = json['id'];
    productName = json['productName'];
    categoryId = json['category_id'];
    category = json['category'] != null ? Category.fromJson(json['category']) : null;
  }
  num? id;
  String? productName;
  num? categoryId;
  Category? category;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['productName'] = productName;
    map['category_id'] = categoryId;
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

class Party {
  Party({
    this.id,
    this.name,
    this.email,
    this.phone,
  });

  Party.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
  }
  num? id;
  String? name;
  String? email;
  String? phone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['phone'] = phone;
    return map;
  }
}

class User {
  User({
    this.id,
    this.name,
  });

  User.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  num? id;
  dynamic name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}
