class BusinessInformation {
  BusinessInformation({
    this.id,
    this.planSubscribeId,
    this.businessCategoryId,
    this.companyName,
    this.willExpire,
    this.address,
    this.phoneNumber,
    this.pictureUrl,
    this.language,
    this.subscriptionDate,
    this.remainingShopBalance,
    this.shopOpeningBalance,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.enrolledPlan,
    this.user,
  });

  BusinessInformation.fromJson(dynamic json) {
    id = json['id'];
    planSubscribeId = json['plan_subscribe_id'];
    businessCategoryId = json['business_category_id'];
    companyName = json['companyName'];
    willExpire = json['will_expire'];
    address = json['address'];
    phoneNumber = json['phoneNumber'];
    pictureUrl = json['pictureUrl'];
    language = json['language'];
    subscriptionDate = json['subscriptionDate'];
    remainingShopBalance = json['remainingShopBalance'];
    shopOpeningBalance = json['shopOpeningBalance'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    category = json['category'] != null ? Category.fromJson(json['category']) : null;
    enrolledPlan = json['enrolled_plan'] != null ? EnrolledPlan.fromJson(json['enrolled_plan']) : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  num? id;
  num? planSubscribeId;
  num? businessCategoryId;
  String? companyName;
  dynamic willExpire;
  String? address;
  String? phoneNumber;
  String? pictureUrl;
  String? language;
  String? subscriptionDate;
  num? remainingShopBalance;
  num? shopOpeningBalance;
  String? createdAt;
  String? updatedAt;
  Category? category;
  EnrolledPlan? enrolledPlan;
  User? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['plan_subscribe_id'] = planSubscribeId;
    map['business_category_id'] = businessCategoryId;
    map['companyName'] = companyName;
    map['will_expire'] = willExpire;
    map['address'] = address;
    map['phoneNumber'] = phoneNumber;
    map['pictureUrl'] = pictureUrl;
    map['language'] = language;
    map['subscriptionDate'] = subscriptionDate;
    map['remainingShopBalance'] = remainingShopBalance;
    map['shopOpeningBalance'] = shopOpeningBalance;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (category != null) {
      map['category'] = category?.toJson();
    }
    if (enrolledPlan != null) {
      map['enrolled_plan'] = enrolledPlan?.toJson();
    }
    if (user != null) {
      map['user'] = user?.toJson();
    }
    return map;
  }
}

class User {
  User({
    this.id,
    this.name,
    this.role,
    this.visibility,
    this.lang,
    this.email,
  });

  User.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    role = json['role'];
    visibility = json['visibility'] != null ? Visibility.fromJson(json['visibility']) : null;
    lang = json['lang'];
    email = json['email'];
  }
  num? id;
  String? name;
  String? role;
  Visibility? visibility;
  dynamic lang;
  String? email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['role'] = role;
    map['email'] = email;
    if (visibility != null) {
      map['visibility'] = visibility?.toJson();
    }
    map['lang'] = lang;
    return map;
  }
}

class Visibility {
  Visibility({
    this.addExpensePermission,
    this.dueListPermission,
    this.lossProfitPermission,
    this.partiesPermission,
    this.productPermission,
    this.profileEditPermission,
    this.purchaseListPermission,
    this.purchasePermission,
    this.reportsPermission,
    this.salePermission,
    this.salesListPermission,
    this.stockPermission,
  });

  Visibility.fromJson(dynamic json) {
    addExpensePermission = json['addExpensePermission'];
    dueListPermission = json['dueListPermission'];
    lossProfitPermission = json['lossProfitPermission'];
    partiesPermission = json['partiesPermission'];
    productPermission = json['productPermission'];
    profileEditPermission = json['profileEditPermission'];
    purchaseListPermission = json['purchaseListPermission'];
    purchasePermission = json['purchasePermission'];
    reportsPermission = json['reportsPermission'];
    salePermission = json['salePermission'];
    salesListPermission = json['salesListPermission'];
    stockPermission = json['stockPermission'];
  }
  bool? addExpensePermission;
  bool? dueListPermission;
  bool? lossProfitPermission;
  bool? partiesPermission;
  bool? productPermission;
  bool? profileEditPermission;
  bool? purchaseListPermission;
  bool? purchasePermission;
  bool? reportsPermission;
  bool? salePermission;
  bool? salesListPermission;
  bool? stockPermission;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['addExpensePermission'] = addExpensePermission;
    map['dueListPermission'] = dueListPermission;
    map['lossProfitPermission'] = lossProfitPermission;
    map['partiesPermission'] = partiesPermission;
    map['productPermission'] = productPermission;
    map['profileEditPermission'] = profileEditPermission;
    map['purchaseListPermission'] = purchaseListPermission;
    map['purchasePermission'] = purchasePermission;
    map['reportsPermission'] = reportsPermission;
    map['salePermission'] = salePermission;
    map['salesListPermission'] = salesListPermission;
    map['stockPermission'] = stockPermission;
    return map;
  }
}

class EnrolledPlan {
  EnrolledPlan({
    this.id,
    this.planId,
    this.businessId,
    this.price,
    this.duration,
    this.plan,
  });

  EnrolledPlan.fromJson(dynamic json) {
    id = json['id'];
    planId = json['plan_id'];
    businessId = json['business_id'];
    price = json['price'];
    duration = json['duration'];
    plan = json['plan'] != null ? Plan.fromJson(json['plan']) : null;
  }
  num? id;
  num? planId;
  num? businessId;
  num? price;
  num? duration;
  Plan? plan;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['plan_id'] = planId;
    map['business_id'] = businessId;
    map['price'] = price;
    map['duration'] = duration;
    if (plan != null) {
      map['plan'] = plan?.toJson();
    }
    return map;
  }
}

class Plan {
  Plan({
    this.id,
    this.subscriptionName,
  });

  Plan.fromJson(dynamic json) {
    id = json['id'];
    subscriptionName = json['subscriptionName'];
  }
  num? id;
  String? subscriptionName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['subscriptionName'] = subscriptionName;
    return map;
  }
}

class Category {
  Category({
    this.id,
    this.name,
  });

  Category.fromJson(dynamic json) {
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
