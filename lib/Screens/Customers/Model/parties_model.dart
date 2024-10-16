class Party {
  Party({
    this.id,
    this.name,
    this.businessId,
    this.email,
    this.type,
    this.phone,
    this.due,
    this.address,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Party.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    businessId = json['business_id'];
    email = json['email'];
    type = json['type'];
    phone = json['phone'];
    due = json['due'];
    address = json['address'];
    image = json['image'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  num? id;
  String? name;
  num? businessId;
  String? email;
  String? type;
  String? phone;
  num? due;
  String? address;
  String? image;
  num? status;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['business_id'] = businessId;
    map['email'] = email;
    map['type'] = type;
    map['phone'] = phone;
    map['due'] = due;
    map['address'] = address;
    map['image'] = image;
    map['status'] = status;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}
