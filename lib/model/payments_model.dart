import 'dart:convert';

PaymentsListModel PaymentsListFromJson(String str) =>
    PaymentsListModel.fromJson(json.decode(str));

class PaymentsListModel {
  bool status;
  String message;
  List<PaymentsData> data;

  PaymentsListModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PaymentsListModel.fromJson(Map<String, dynamic> json) =>
      PaymentsListModel(
        status: json['status'],
        message: json['message'],
        data: List<PaymentsData>.from(
            json['data'].map((x) => PaymentsData.fromJson(x))),
      );
}

class PaymentsData {
  String module;
  String id;
  String userId;
  String username;
  String price;
  String paymentGateway;
  String paymentDetail;
  String statusId;
  String datetime;

  PaymentsData({
    required this.module,
    required this.id,
    required this.userId,
    required this.username,
    required this.price,
    required this.paymentGateway,
    required this.paymentDetail,
    required this.statusId,
    required this.datetime,
  });

  factory PaymentsData.fromJson(Map<String, dynamic> json) =>
      PaymentsData(
        module: json['module'],
        id: json['id'],
        userId: json['user_id'],
        username: json['username'],
        price: json['price'],
        paymentGateway: json['payment_gateway'],
        paymentDetail: json['payment_detail'],
        statusId: json['status_id'],
        datetime: json['datetime'],
      );
}
