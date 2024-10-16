class SubscriptionPlanModel {
  SubscriptionPlanModel({
    this.id,
    this.subscriptionName,
    this.duration,
    this.offerPrice,
    this.subscriptionPrice,
    this.status,
    this.createdAt,
    this.updatedAt,});

  SubscriptionPlanModel.fromJson(dynamic json) {
    id = json['id'];
    subscriptionName = json['subscriptionName'];
    duration = json['duration'];
    offerPrice = json['offerPrice'];
    subscriptionPrice = json['subscriptionPrice'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  num? id;
  String? subscriptionName;
  num? duration;
  num? offerPrice;
  num? subscriptionPrice;
  num? status;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['subscriptionName'] = subscriptionName;
    map['duration'] = duration;
    map['offerPrice'] = offerPrice;
    map['subscriptionPrice'] = subscriptionPrice;
    map['status'] = status;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}