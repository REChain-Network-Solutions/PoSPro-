class PaypalInfoModel {
  PaypalInfoModel({
    required this.paypalClientId,
    required this.paypalClientSecret,
  });

  String paypalClientId, paypalClientSecret;

  PaypalInfoModel.fromJson(Map<dynamic, dynamic> json)
      : paypalClientId = json['paypalClientId'],
        paypalClientSecret = json['paypalClientSecret'];

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'paypalClientId': paypalClientId,
        'paypalClientSecret': paypalClientSecret,
      };
}
