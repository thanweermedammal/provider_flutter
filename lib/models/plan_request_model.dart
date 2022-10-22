import 'package:handyman_provider_flutter/models/provider_subscription_model.dart';

class PlanRequestModel {
  int? amount;
  String? description;
  String? duration;
  String? identifier;
  String? other_transaction_detail;
  String? payment_status;
  String? payment_type;
  int? plan_id;
  PlanLimitation? plan_limitation;
  String? plan_type;
  String? title;
  String? txn_id;
  String? type;
  int? user_id;

  PlanRequestModel(
      {this.amount,
      this.description,
      this.duration,
      this.identifier,
      this.other_transaction_detail,
      this.payment_status,
      this.payment_type,
      this.plan_id,
      this.plan_limitation,
      this.plan_type,
      this.title,
      this.txn_id,
      this.type,
      this.user_id});

  factory PlanRequestModel.fromJson(Map<String, dynamic> json) {
    return PlanRequestModel(
      amount: json['amount'],
      description: json['description'],
      duration: json['duration'],
      identifier: json['identifier'],
      other_transaction_detail: json['other_transaction_detail'],
      payment_status: json['payment_status'],
      payment_type: json['payment_type'],
      plan_id: json['plan_id'],
      plan_limitation: json['plan_limitation'] != null ? PlanLimitation.fromJson(json['plan_limitation']) : null,
      plan_type: json['plan_type'],
      title: json['title'],
      txn_id: json['txn_id'],
      type: json['type'],
      user_id: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['description'] = this.description;
    data['duration'] = this.duration;
    data['identifier'] = this.identifier;
    data['other_transaction_detail'] = this.other_transaction_detail;
    data['payment_status'] = this.payment_status;
    data['payment_type'] = this.payment_type;
    data['plan_id'] = this.plan_id;
    data['plan_type'] = this.plan_type;
    data['title'] = this.title;
    data['txn_id'] = this.txn_id;
    data['type'] = this.type;
    data['user_id'] = this.user_id;
    if (this.plan_limitation != null) {
      data['plan_limitation'] = this.plan_limitation!.toJson();
    }
    return data;
  }
}
