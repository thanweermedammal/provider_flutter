import 'dart:convert';

import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/provider_subscription_model.dart';
import 'package:handyman_provider_flutter/models/service_model.dart';
import 'package:nb_utils/nb_utils.dart';

import 'revenue_chart_data.dart';

class DashboardResponse {
  bool? status;
  int? totalBooking;
  int? total_service;
  int? total_handyman;
  int? is_subscribed;
  List<Service>? service;
  List<Category>? category;
  List<Handyman>? handyman;
  num? totalRevenue;
  List<double>? chartArray;
  List<int>? monthData;
  Commission? commission;
  ProviderSubscriptionModel? subscription;
  List<Configurations>? configurations;
  List<PaymentSetting>? paymentSettings;
  String? earningType;
  List<LanguageOption>? language_option;

  List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'July', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'];

  //Local
  bool? isPlanAboutToExpire;
  bool? userNeverPurchasedPlan;
  bool? isPlanExpired;
  PrivacyPolicy? privacy_policy;
  PrivacyPolicy? term_conditions;
  String? inquriy_email;
  String? helpline_number;
  ProviderWallet? providerWallet;

  DashboardResponse({
    this.chartArray,
    this.monthData,
    this.status,
    this.totalBooking,
    this.service,
    this.category,
    this.total_service,
    this.total_handyman,
    this.is_subscribed,
    this.paymentSettings,
    this.handyman,
    this.totalRevenue,
    this.configurations,
    this.commission,
    this.subscription,
    this.earningType,
    this.privacy_policy,
    this.term_conditions,
    this.inquriy_email,
    this.helpline_number,
    this.providerWallet,
    this.language_option,
  });

  DashboardResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalBooking = json['total_booking'];
    totalRevenue = json['total_revenue'];
    total_service = json['total_service'];
    total_handyman = json['total_handyman'];
    is_subscribed = json['is_subscribed'] ?? 0;
    subscription = json['subscription'] != null ? ProviderSubscriptionModel.fromJson(json['subscription']) : null;
    commission = json['commission'] != null ? Commission.fromJson(json['commission']) : null;
    configurations = json['configurations'] != null ? (json['configurations'] as List).map((i) => Configurations.fromJson(i)).toList() : null;
    paymentSettings = json['payment_settings'] != null ? (json['payment_settings'] as List).map((i) => PaymentSetting.fromJson(i)).toList() : null;
    privacy_policy = json['privacy_policy'] != null ? PrivacyPolicy.fromJson(json['privacy_policy']) : null;
    term_conditions = json['term_conditions'] != null ? PrivacyPolicy.fromJson(json['term_conditions']) : null;
    inquriy_email = json['inquriy_email'];
    helpline_number = json['helpline_number'];
    if (json['service'] != null) {
      service = [];
      json['service'].forEach((v) {
        service!.add(new Service.fromJson(v));
      });
    }
    if (json['category'] != null) {
      category = [];
      json['category'].forEach((v) {
        category!.add(new Category.fromJson(v));
      });
    }
    if (json['handyman'] != null) {
      handyman = [];
      json['handyman'].forEach((v) {
        handyman!.add(new Handyman.fromJson(v));
      });
    }

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

    isPlanAboutToExpire = is_subscribed == 1;
    userNeverPurchasedPlan = is_subscribed == 0 && subscription == null;
    isPlanExpired = is_subscribed == 0 && subscription != null;
    earningType = json['earning_type'];
    providerWallet = json['provider_wallet'] != null ? ProviderWallet.fromJson(json['provider_wallet']) : null;

    // providerWallet = json['provider_wallet'] != null ? (json['provider_wallet'] as List).map((i) => ProviderWallet.fromJson(i)).toList() : null;
    language_option = json['language_option'] != null ? (json['language_option'] as List).map((i) => LanguageOption.fromJson(i)).toList() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['total_booking'] = this.totalBooking;
    data['is_subscribed'] = this.is_subscribed;
    data['total_service'] = this.total_service;
    if (this.privacy_policy != null) {
      data['privacy_policy'] = this.privacy_policy;
    }
    if (this.term_conditions != null) {
      data['term_conditions'] = this.term_conditions;
    }
    data['inquriy_email'] = this.inquriy_email;
    data['helpline_number'] = this.helpline_number;
    if (this.commission != null) {
      data['commission'] = this.commission!.toJson();
    }
    if (this.subscription != null) {
      data['subscription'] = this.subscription!.toJson();
    }
    if (this.configurations != null) {
      data['configurations'] = this.configurations!.map((v) => v.toJson()).toList();
    }
    data['total_handyman'] = this.total_handyman;
    if (this.service != null) {
      data['service'] = this.service!.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['category'] = this.category!.map((v) => v.toJson()).toList();
    }
    if (this.paymentSettings != null) {
      data['payment_settings'] = this.paymentSettings!.map((v) => v.toJson()).toList();
    }
    if (this.handyman != null) {
      data['handyman'] = this.handyman!.map((v) => v.toJson()).toList();
    }
    data['total_revenue'] = this.totalRevenue;
    data['earning_type'] = this.earningType;
    if (this.providerWallet != null) {
      data['provider_wallet'] = this.providerWallet!.toJson();
    }

    if (this.language_option != null) {
      data['language_option'] = this.language_option!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class PrivacyPolicy {
  int? id;
  String? key;
  String? type;
  String? value;

  PrivacyPolicy({this.id, this.key, this.type, this.value});

  factory PrivacyPolicy.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicy(
      id: json['id'],
      key: json['key'],
      type: json['type'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['key'] = this.key;
    data['type'] = this.type;
    data['value'] = this.value;
    return data;
  }
}

class LiveValue {
  String? stripe_url;
  String? stripe_key;
  String? stripe_publickey;
  String? razor_url;
  String? razor_key;
  String? razor_secret;
  String? flutterwave_public;
  String? flutterwave_secret;
  String? flutterwave_encryption;
  String? paystack_public;

  LiveValue(
      {this.stripe_url,
      this.stripe_key,
      this.stripe_publickey,
      this.razor_url,
      this.razor_key,
      this.razor_secret,
      this.flutterwave_public,
      this.flutterwave_secret,
      this.flutterwave_encryption,
      this.paystack_public});

  factory LiveValue.fromJson(Map<String, dynamic> json) {
    return LiveValue(
      stripe_url: json['stripe_url'],
      stripe_key: json['stripe_key'],
      stripe_publickey: json['stripe_publickey'],
      razor_url: json['razor_url'],
      razor_key: json['razor_key'],
      razor_secret: json['razor_secret'],
      flutterwave_public: json['flutterwave_public'],
      flutterwave_secret: json['flutterwave_secret'],
      flutterwave_encryption: json['flutterwave_encryption'],
      paystack_public: json['paystack_public'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stripe_url'] = this.stripe_url;
    data['stripe_key'] = this.stripe_key;
    data['stripe_publickey'] = this.stripe_publickey;
    data['razor_url'] = this.razor_url;
    data['razor_key'] = this.razor_key;
    data['razor_secret'] = this.razor_secret;
    data['flutterwave_public'] = this.flutterwave_public;
    data['flutterwave_secret'] = this.flutterwave_secret;
    data['flutterwave_encryption'] = this.flutterwave_encryption;
    data['paystack_public'] = this.paystack_public;
    return data;
  }
}

class PaymentSetting {
  int? id;
  int? is_test;
  LiveValue? live_value;
  int? status;
  String? title;
  String? type;
  LiveValue? test_value;

  PaymentSetting({this.id, this.is_test, this.live_value, this.status, this.title, this.type, this.test_value});

  static String encode(List<PaymentSetting> paymentList) {
    return json.encode(paymentList.map<Map<String, dynamic>>((payment) => payment.toJson()).toList());
  }

  static List<PaymentSetting> decode(String musics) {
    return (json.decode(musics) as List<dynamic>).map<PaymentSetting>((item) => PaymentSetting.fromJson(item)).toList();
  }

  factory PaymentSetting.fromJson(Map<String, dynamic> json) {
    return PaymentSetting(
      id: json['id'],
      is_test: json['is_test'],
      live_value: json['live_value'] != null ? LiveValue.fromJson(json['live_value']) : null,
      status: json['status'],
      title: json['title'],
      type: json['type'],
      test_value: json['value'] != null ? LiveValue.fromJson(json['value']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['is_test'] = this.is_test;
    data['status'] = this.status;
    data['title'] = this.title;
    data['type'] = this.type;
    if (this.live_value != null) {
      data['live_value'] = this.live_value?.toJson();
    }
    if (this.test_value != null) {
      data['value'] = this.test_value?.toJson();
    }
    return data;
  }
}

class ServiceAddressMapping {
  int? id;
  int? serviceId;
  int? providerAddressId;
  String? createdAt;
  String? updatedAt;
  ProviderAddressMapping? providerAddressMapping;

  ServiceAddressMapping({this.id, this.serviceId, this.providerAddressId, this.createdAt, this.updatedAt, this.providerAddressMapping});

  ServiceAddressMapping.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceId = json['service_id'];
    providerAddressId = json['provider_address_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    providerAddressMapping = json['provider_address_mapping'] != null ? new ProviderAddressMapping.fromJson(json['provider_address_mapping']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['service_id'] = this.serviceId;
    data['provider_address_id'] = this.providerAddressId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.providerAddressMapping != null) {
      data['provider_address_mapping'] = this.providerAddressMapping!.toJson();
    }
    return data;
  }
}

class ProviderAddressMapping {
  int? id;
  int? providerId;
  String? address;
  String? latitude;
  String? longitude;
  int? status;
  String? createdAt;
  String? updatedAt;

  ProviderAddressMapping({this.id, this.providerId, this.address, this.latitude, this.longitude, this.status, this.createdAt, this.updatedAt});

  ProviderAddressMapping.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    providerId = json['provider_id'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['provider_id'] = this.providerId;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Category {
  int? id;
  String? name;
  int? status;
  String? description;
  int? isFeatured;
  String? color;
  String? categoryImage;

  Category({this.id, this.name, this.status, this.description, this.isFeatured, this.color, this.categoryImage});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    description = json['description'];
    isFeatured = json['is_featured'];
    color = json['color'];
    categoryImage = json['category_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['description'] = this.description;
    data['is_featured'] = this.isFeatured;
    data['color'] = this.color;
    data['category_image'] = this.categoryImage;
    return data;
  }
}

class Handyman {
  int? id;
  String? firstName;
  String? lastName;
  String? username;
  int? providerId;
  int? status;
  String? description;
  String? userType;
  String? email;
  String? contactNumber;
  int? countryId;
  int? stateId;
  int? cityId;
  String? cityName;
  String? address;
  var providertypeId;
  var providertype;
  int? isFeatured;
  String? displayName;
  String? createdAt;
  String? updatedAt;
  String? profileImage;
  String? timeZone;
  String? uid;
  String? loginType;
  int? serviceAddressId;
  String? lastNotificationSeen;

  //Local
  bool isActive = false;

  Handyman(
      {this.id,
      this.firstName,
      this.lastName,
      this.username,
      this.providerId,
      this.status,
      this.description,
      this.userType,
      this.email,
      this.contactNumber,
      this.countryId,
      this.stateId,
      this.cityId,
      this.cityName,
      this.address,
      this.providertypeId,
      this.providertype,
      this.isFeatured,
      this.displayName,
      this.createdAt,
      this.updatedAt,
      this.profileImage,
      this.timeZone,
      this.uid,
      this.loginType,
      this.serviceAddressId,
      this.lastNotificationSeen});

  Handyman.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    username = json['username'];
    providerId = json['provider_id'];
    status = json['status'];
    isActive = status.validate() == 1;
    description = json['description'];
    userType = json['user_type'];
    email = json['email'];
    contactNumber = json['contact_number'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    cityName = json['city_name'];
    address = json['address'];
    providertypeId = json['providertype_id'];
    providertype = json['providertype'];
    isFeatured = json['is_featured'];
    displayName = json['display_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    profileImage = json['profile_image'];
    timeZone = json['time_zone'];
    uid = json['uid'];
    loginType = json['login_type'];
    serviceAddressId = json['service_address_id'];
    lastNotificationSeen = json['last_notification_seen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['username'] = this.username;
    data['provider_id'] = this.providerId;
    data['status'] = this.status;
    data['description'] = this.description;
    data['user_type'] = this.userType;
    data['email'] = this.email;
    data['contact_number'] = this.contactNumber;
    data['country_id'] = this.countryId;
    data['state_id'] = this.stateId;
    data['city_id'] = this.cityId;
    data['city_name'] = this.cityName;
    data['address'] = this.address;
    data['providertype_id'] = this.providertypeId;
    data['providertype'] = this.providertype;
    data['is_featured'] = this.isFeatured;
    data['display_name'] = this.displayName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['profile_image'] = this.profileImage;
    data['time_zone'] = this.timeZone;
    data['uid'] = this.uid;
    data['login_type'] = this.loginType;
    data['service_address_id'] = this.serviceAddressId;
    data['last_notification_seen'] = this.lastNotificationSeen;
    return data;
  }
}

class MonthlyRevenue {
  List<RevenueData>? revenueData;

  MonthlyRevenue({this.revenueData});

  MonthlyRevenue.fromJson(Map<String, dynamic> json) {
    if (json['revenueData'] != null) {
      revenueData = [];
      json['revenueData'].forEach((v) {
        revenueData!.add(new RevenueData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.revenueData != null) {
      data['revenueData'] = this.revenueData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RevenueData {
  var i;

  RevenueData({this.i});

  RevenueData.fromJson(Map<String, dynamic> json) {
    for (int i = 1; i <= 12; i++) {
      i = json['$i'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    for (int i = 1; i <= 12; i++) {
      data['$i'] = this.i;
    }
    return data;
  }
}

class Configurations {
  Country? country;
  int? id;
  String? key;
  String? type;
  String? value;

  Configurations({this.country, this.id, this.key, this.type, this.value});

  factory Configurations.fromJson(Map<String, dynamic> json) {
    return Configurations(
      country: json['country'] != null ? Country.fromJson(json['country']) : null,
      id: json['id'],
      key: json['key'],
      type: json['type'],
      value: json['value'] != null ? json['value'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['key'] = this.key;
    data['type'] = this.type;
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    if (this.value != null) {
      data['value'] = this.value;
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

class Country {
  int? id;
  String? code;
  String? name;
  int? dialCode;
  String? currencyName;
  String? symbol;
  String? currencyCode;

  Country({this.id, this.code, this.name, this.dialCode, this.currencyName, this.symbol, this.currencyCode});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    dialCode = json['dial_code'];
    currencyName = json['currency_name'];
    symbol = json['symbol'];
    currencyCode = json['currency_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['dial_code'] = this.dialCode;
    data['currency_name'] = this.currencyName;
    data['symbol'] = this.symbol;
    data['currency_code'] = this.currencyCode;
    return data;
  }
}

class ProviderWallet {
  int? id;
  String? title;
  int? userId;
  int? amount;
  int? status;
  String? createdAt;
  String? updatedAt;

  ProviderWallet(this.id, this.title, this.userId, this.amount, this.status, this.createdAt, this.updatedAt);

  ProviderWallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    userId = json['user_id'];
    amount = json['amount'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['user_id'] = this.userId;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class LanguageOption {
  String? flag_image;
  String? id;
  String? title;

  LanguageOption({this.flag_image, this.id, this.title});

  factory LanguageOption.fromJson(Map<String, dynamic> json) {
    return LanguageOption(
      flag_image: json['flag_image'],
      id: json['id'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flag_image'] = this.flag_image;
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }
}
