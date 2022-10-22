import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/dashboard_response.dart';
import 'package:handyman_provider_flutter/models/handyman_review_response.dart';
import 'package:handyman_provider_flutter/models/revenue_chart_data.dart';
import 'package:nb_utils/nb_utils.dart';

class HandymanDashBoardResponse {
  Commission? commission;

  List<HandymanReview>? handyman_reviews;
  bool? status;
  num? today_booking;
  num? total_booking;
  num? total_revenue;
  num? upcomming_booking;
  List<Configurations>? configurations;
  List<double>? chartArray;
  List<int>? monthData;
  PrivacyPolicy? privacy_policy;
  PrivacyPolicy? term_conditions;
  String? inquriy_email;
  String? helpline_number;
  List<LanguageOption>? language_option;

  HandymanDashBoardResponse({
    this.commission,
    this.handyman_reviews,
    this.status,
    this.today_booking,
    this.total_booking,
    this.configurations,
    this.total_revenue,
    this.upcomming_booking,
    this.chartArray,
    this.monthData,
    this.privacy_policy,
    this.term_conditions,
    this.inquriy_email,
    this.helpline_number,
    this.language_option,
  });

  HandymanDashBoardResponse.fromJson(Map<String, dynamic> json) {
    commission = json['commission'] != null ? Commission.fromJson(json['commission']) : null;
    configurations = json['configurations'] != null ? (json['configurations'] as List).map((i) => Configurations.fromJson(i)).toList() : null;
    handyman_reviews = json['handyman_reviews'] != null ? (json['handyman_reviews'] as List).map((i) => HandymanReview.fromJson(i)).toList() : null;
    status = json['status'];
    today_booking = json['today_booking'];
    total_booking = json['total_booking'];
    total_revenue = json['total_revenue'];
    upcomming_booking = json['upcomming_booking'];
    privacy_policy = json['privacy_policy'] != null ? PrivacyPolicy.fromJson(json['privacy_policy']) : null;
    term_conditions = json['term_conditions'] != null ? PrivacyPolicy.fromJson(json['term_conditions']) : null;
    inquriy_email = json['inquriy_email'];
    helpline_number = json['helpline_number'];
    List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'July', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'];
    language_option = json['language_option'] != null ? (json['language_option'] as List).map((i) => LanguageOption.fromJson(i)).toList() : null;

    chartArray = [];
    monthData = [];
    Iterable it = json['monthly_revenue']['revenueData'];

    it.forEachIndexed((element, index) {
      if ((element as Map).containsKey('${index + 1}')) {
        chartArray!.add(element[(index + 1).toString()].toString().toDouble());
        monthData!.add(index);
        chartData.add(RevenueChartData(month: months[index], revenue: element[(index + 1).toString()].toString().toDouble()));
      } else {
        chartData.add(RevenueChartData(month: months[index], revenue: 0));
      }
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['today_booking'] = this.today_booking;
    data['total_booking'] = this.total_booking;
    data['total_revenue'] = this.total_revenue;
    if (this.privacy_policy != null) {
      data['privacy_policy'] = this.privacy_policy;
    }
    if (this.term_conditions != null) {
      data['term_conditions'] = this.term_conditions;
    }
    data['inquriy_email'] = this.inquriy_email;
    data['helpline_number'] = this.helpline_number;
    if (this.configurations != null) {
      data['configurations'] = this.configurations!.map((v) => v.toJson()).toList();
    }
    data['upcomming_booking'] = this.upcomming_booking;
    if (this.commission != null) {
      data['commission'] = this.commission!.toJson();
    }

    if (this.handyman_reviews != null) {
      data['handyman_reviews'] = this.handyman_reviews!.map((v) => v.toJson()).toList();
    }

    if (this.language_option != null) {
      data['language_option'] = this.language_option!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Commission {
  int? commission;
  String? created_at;
  String? deleted_at;
  int? id;
  String? name;
  int? status;
  String? type;
  String? updated_at;

  Commission({this.commission, this.created_at, this.deleted_at, this.id, this.name, this.status, this.type, this.updated_at});

  factory Commission.fromJson(Map<String, dynamic> json) {
    return Commission(
      commission: json['commission'],
      created_at: json['created_at'],
      deleted_at: json['deleted_at'],
      id: json['id'],
      name: json['name'],
      status: json['status'],
      type: json['type'],
      updated_at: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commission'] = this.commission;
    data['created_at'] = this.created_at;
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['type'] = this.type;
    data['updated_at'] = this.updated_at;
    data['deleted_at'] = this.deleted_at;
    return data;
  }
}
