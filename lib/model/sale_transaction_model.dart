

class SalesTransaction {
  SalesTransaction({
    this.id,
    this.businessId,
    this.partyId,
    this.userId,
    this.discountAmount,
    this.dueAmount,
    this.isPaid,
    this.vatAmount,
    this.vatPercent,
    this.paidAmount,
    this.totalAmount,
    this.paymentType,
    this.invoiceNumber,
    this.saleDate,
    this.createdAt,
    this.updatedAt,
    this.detailsSumLossProfit,
    this.user,
    this.party,
    this.details,
    this.meta,
  });

  SalesTransaction.fromJson(dynamic json) {
    id = json['id'];
    businessId = json['business_id'];
    partyId = json['party_id'];
    userId = json['user_id'];
    discountAmount = json['discountAmount'];
    dueAmount = json['dueAmount'];
    isPaid = json['isPaid'];
    vatAmount = json['vat_amount'];
    vatPercent = json['vat_percent'];
    paidAmount = json['paidAmount'];
    totalAmount = json['totalAmount'];
    paymentType = json['paymentType'];
    invoiceNumber = json['invoiceNumber'];
    saleDate = json['saleDate'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    detailsSumLossProfit = json['lossProfit'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    party = json['party'] != null ? SalesParty.fromJson(json['party']) : SalesParty(name: 'Guest', type: 'Guest');
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details?.add(SalesDetails.fromJson(v));
      });
    }
  }
  num? id;
  num? businessId;
  num? partyId;
  num? userId;
  num? discountAmount;
  num? dueAmount;
  bool? isPaid;
  num? vatAmount;
  num? vatPercent;
  num? paidAmount;
  num? totalAmount;
  String? paymentType;
  String? invoiceNumber;
  String? saleDate;
  String? createdAt;
  String? updatedAt;
  num? detailsSumLossProfit;
  User? user;
  SalesParty? party;
  Meta? meta;
  List<SalesDetails>? details;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['business_id'] = businessId;
    map['party_id'] = partyId;
    map['user_id'] = userId;
    map['discountAmount'] = discountAmount;
    map['dueAmount'] = dueAmount;
    map['isPaid'] = isPaid;
    map['vat_amount'] = vatAmount;
    map['vat_percent'] = vatPercent;
    map['paidAmount'] = paidAmount;
    map['totalAmount'] = totalAmount;
    map['paymentType'] = paymentType;
    map['invoiceNumber'] = invoiceNumber;
    map['saleDate'] = saleDate;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['details_sum_loss_profit'] = detailsSumLossProfit;
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

class SalesDetails {
  SalesDetails({
    this.id,
    this.saleId,
    this.productId,
    this.price,
    this.lossProfit,
    this.quantities,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  SalesDetails.fromJson(dynamic json) {
    id = json['id'];
    saleId = json['sale_id'];
    productId = json['product_id'];
    price = json['price'];
    lossProfit = json['lossProfit'];
    quantities = json['quantities'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product = json['product'] != null ? SalesProduct.fromJson(json['product']) : null;
  }
  num? id;
  num? saleId;
  num? productId;
  num? price;
  num? lossProfit;
  num? quantities;
  dynamic createdAt;
  dynamic updatedAt;
  SalesProduct? product;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['sale_id'] = saleId;
    map['product_id'] = productId;
    map['price'] = price;
    map['lossProfit'] = lossProfit;
    map['quantities'] = quantities;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (product != null) {
      map['product'] = product?.toJson();
    }
    return map;
  }
}

class SalesProduct {
  SalesProduct({
    this.id,
    this.productName,
    this.categoryId,
    this.category,
  });

  SalesProduct.fromJson(dynamic json) {
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

class SalesParty {
  SalesParty({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.type,
  });

  SalesParty.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    type = json['type'];
  }
  num? id;
  String? name;
  dynamic email;
  String? phone;
  String? type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['phone'] = phone;
    map['type'] = type;
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
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}

class Meta {
  Meta({
    this.customerPhone,
  });

  Meta.fromJson(dynamic json) {
    customerPhone = json['customer_phone'];
  }
  String? customerPhone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['customer_phone'] = customerPhone;
    return map;
  }
}
