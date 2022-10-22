import 'package:handyman_provider_flutter/models/pagination_model.dart';

class TotalEarningResponse {
  List<TotalData>? data;
  Pagination? pagination;

  TotalEarningResponse({this.data, this.pagination});

  factory TotalEarningResponse.fromJson(Map<String, dynamic> json) {
    return TotalEarningResponse(
      data: json['data'] != null ? (json['data'] as List).map((i) => TotalData.fromJson(i)).toList() : null,
      pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class TotalData {
  num? amount;
  String? created_at;
  String? description;
  int? id;
  String? payment_method;

  TotalData({this.amount, this.created_at, this.description, this.id, this.payment_method});

  factory TotalData.fromJson(Map<String, dynamic> json) {
    return TotalData(
      amount: json['amount'],
      created_at: json['created_at'],
      description: json['description'],
      id: json['id'],
      payment_method: json['payment_method'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['created_at'] = this.created_at;
    data['id'] = this.id;
    data['payment_method'] = this.payment_method;
    data['description'] = this.description;
    return data;
  }
}
