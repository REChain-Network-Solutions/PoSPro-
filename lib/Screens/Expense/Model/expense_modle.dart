class Expense {
  Expense({
      this.id, 
      this.account, 
      this.amount, 
      this.expenseCategoryId, 
      this.userId, 
      this.businessId, 
      this.expanseFor, 
      this.paymentType, 
      this.referenceNo, 
      this.note, 
      this.expenseDate, 
      this.createdAt, 
      this.updatedAt, 
      this.category,});

  Expense.fromJson(dynamic json) {
    id = json['id'];
    account = json['account'];
    amount = json['amount'];
    expenseCategoryId = json['expense_category_id'];
    userId = json['user_id'];
    businessId = json['business_id'];
    expanseFor = json['expanseFor'];
    paymentType = json['paymentType'];
    referenceNo = json['referenceNo'];
    note = json['note'];
    expenseDate = json['expenseDate'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    category = json['category'] != null ? Category.fromJson(json['category']) : null;
  }
  num? id;
  dynamic account;
  num? amount;
  num? expenseCategoryId;
  num? userId;
  num? businessId;
  String? expanseFor;
  String? paymentType;
  String? referenceNo;
  String? note;
  String? expenseDate;
  String? createdAt;
  String? updatedAt;
  Category? category;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['account'] = account;
    map['amount'] = amount;
    map['expense_category_id'] = expenseCategoryId;
    map['user_id'] = userId;
    map['business_id'] = businessId;
    map['expanseFor'] = expanseFor;
    map['paymentType'] = paymentType;
    map['referenceNo'] = referenceNo;
    map['note'] = note;
    map['expenseDate'] = expenseDate;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (category != null) {
      map['category'] = category?.toJson();
    }
    return map;
  }

}

class Category {
  Category({
      this.id, 
      this.categoryName,});

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