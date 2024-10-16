class Banner {
  Banner({
    this.id,
    this.imageUrl,
    this.status,
    this.createdAt,
    this.updatedAt,});

  Banner.fromJson(dynamic json) {
    id = json['id'];
    imageUrl = json['imageUrl'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  num? id;
  String? imageUrl;
  num? status;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['imageUrl'] = imageUrl;
    map['status'] = status;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}