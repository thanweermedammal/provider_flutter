import 'package:handyman_provider_flutter/models/handyman_review_response.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceDetailResponse {
  Provider? provider;
  List<HandymanReview>? ratingData;
  List<ServiceFaq>? serviceFaq;
  ServiceDetail? serviceDetail;

  ServiceDetailResponse({
    this.provider,
    this.serviceDetail,
    this.ratingData,
    this.serviceFaq,
  });

  factory ServiceDetailResponse.fromJson(Map<String, dynamic> json) {
    return ServiceDetailResponse(
      provider: json['provider'] != null ? Provider.fromJson(json['provider']) : null,
      ratingData: json['rating_data'] != null ? (json['rating_data'] as List).map((i) => HandymanReview.fromJson(i)).toList() : null,
      serviceFaq: json['service_faq'] != null ? (json['service_faq'] as List).map((i) => ServiceFaq.fromJson(i)).toList() : null,
      serviceDetail: json['service_detail'] != null ? ServiceDetail.fromJson(json['service_detail']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.ratingData != null) {
      data['rating_data'] = this.ratingData!.map((v) => v.toJson()).toList();
    }
    if (this.serviceFaq != null) {
      data['service_faq'] = this.serviceFaq!.map((v) => v.toJson()).toList();
    }
    if (this.provider != null) {
      data['provider'] = this.provider!.toJson();
    }
    if (this.serviceDetail != null) {
      data['service_detail'] = this.serviceDetail!.toJson();
    }
    return data;
  }
}

class ServiceDetail {
  List<Attachments>? attchments;
  List<String>? imageAttchments;
  int? categoryId;
  String? categoryName;
  String? description;
  num? discount;
  String? duration;
  int? id;
  int? isFavourite;
  int? isFeatured;
  String? name;
  num? price;
  var priceFormat;
  int? providerId;
  String? providerName;
  String? subCategoryName;
  List<ServiceAddressMapping>? serviceAddressMapping;
  var status;
  num? totalRating;
  num? totalReview;
  String? type;

  //Local
  bool get isHourlyService => type.validate() == ServiceTypeHourly;

  ServiceDetail({
    this.attchments,
    this.categoryId,
    this.imageAttchments,
    this.categoryName,
    this.description,
    this.discount,
    this.duration,
    this.id,
    this.isFavourite,
    this.isFeatured,
    this.name,
    this.price,
    this.priceFormat,
    this.providerId,
    this.providerName,
    this.serviceAddressMapping,
    this.status,
    this.totalRating,
    this.totalReview,
    this.type,
    this.subCategoryName,
  });

  factory ServiceDetail.fromJson(Map<String, dynamic> json) {
    return ServiceDetail(
      imageAttchments: json['attchments'] != null ? List<String>.from(json['attchments']) : null,
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      description: json['description'],
      discount: json['discount'],
      duration: json['duration'],
      id: json['id'],
      isFavourite: json['is_favourite'],
      isFeatured: json['is_featured'],
      name: json['name'],
      price: json['price'],
      priceFormat: json['price_format'],
      providerId: json['provider_id'],
      providerName: json['provider_name'],
      serviceAddressMapping: json['service_address_mapping'] != null ? (json['service_address_mapping'] as List).map((i) => ServiceAddressMapping.fromJson(i)).toList() : null,
      attchments: json['attchments_array'] != null ? (json['attchments_array'] as List).map((i) => Attachments.fromJson(i)).toList() : null,
      status: json['status'],
      totalRating: json['total_rating'],
      totalReview: json['total_review'],
      type: json['type'],
      subCategoryName: json['subcategory_name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['description'] = this.description;
    data['duration'] = this.duration;
    data['id'] = this.id;
    data['is_favourite'] = this.isFavourite;
    data['is_featured'] = this.isFeatured;
    data['name'] = this.name;
    data['price'] = this.price;
    data['price_format'] = this.priceFormat;
    data['provider_id'] = this.providerId;
    data['status'] = this.status;
    data['total_rating'] = this.totalRating;
    data['total_review'] = this.totalReview;
    data['type'] = this.type;
    data['subcategory_name'] = this.subCategoryName;
    if (this.imageAttchments != null) {
      data['attchments'] = this.imageAttchments;
    }
    if (this.discount != null) {
      data['discount'] = this.discount;
    }
    if (this.providerName != null) {
      data['provider_name'] = this.providerName;
    }
    if (this.serviceAddressMapping != null) {
      data['service_address_mapping'] = this.serviceAddressMapping!.map((v) => v.toJson()).toList();
    }
    if (this.attchments != null) {
      data['attchments_array'] = this.attchments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attachments {
  int? id;
  String? url;

  Attachments({this.id, this.url});

  factory Attachments.fromJson(Map<String, dynamic> json) {
    return Attachments(
      id: json['id'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    return data;
  }
}

class ServiceAddressMapping {
  String? createdAt;
  int? id;
  int? providerAddressId;
  ProviderAddressMapping? providerAddressMapping;
  int? serviceId;
  String? updatedAt;

  ServiceAddressMapping({this.createdAt, this.id, this.providerAddressId, this.providerAddressMapping, this.serviceId, this.updatedAt});

  factory ServiceAddressMapping.fromJson(Map<String, dynamic> json) {
    return ServiceAddressMapping(
      createdAt: json['created_at'],
      id: json['id'],
      providerAddressId: json['provider_address_id'],
      providerAddressMapping: json['provider_address_mapping'] != null ? ProviderAddressMapping.fromJson(json['provider_address_mapping']) : null,
      serviceId: json['service_id'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['provider_address_id'] = this.providerAddressId;
    data['service_id'] = this.serviceId;
    if (this.createdAt != null) {
      data['created_at'] = this.createdAt;
    }
    if (this.providerAddressMapping != null) {
      data['provider_address_mapping'] = this.providerAddressMapping!.toJson();
    }
    if (this.updatedAt != null) {
      data['updated_at'] = this.updatedAt;
    }
    return data;
  }
}

class ProviderAddressMapping {
  String? address;
  String? createdAt;
  int? id;
  String? latitude;
  String? longitude;
  int? providerId;
  var status;
  String? updatedAt;

  ProviderAddressMapping({this.address, this.createdAt, this.id, this.latitude, this.longitude, this.providerId, this.status, this.updatedAt});

  factory ProviderAddressMapping.fromJson(Map<String, dynamic> json) {
    return ProviderAddressMapping(
      address: json['address'],
      createdAt: json['created_at'],
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      providerId: json['provider_id'],
      status: json['status'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['provider_id'] = this.providerId;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Provider {
  String? address;
  int? cityId;
  String? cityName;
  String? contactNumber;
  int? countryId;
  String? createdAt;
  String? description;
  String? displayName;
  String? email;
  String? firstName;
  int? id;
  int? isFeatured;
  String? lastName;
  String? lastNotificationSeen;
  String? loginType;
  String? profileImage;
  var providerId;
  String? providerType;
  var providerTypeId;
  var serviceAddressId;
  int? stateId;
  int? status;
  String? timeZone;
  var uid;
  String? updatedAt;
  String? userType;
  String? username;

  Provider({
    this.address,
    this.cityId,
    this.cityName,
    this.contactNumber,
    this.countryId,
    this.createdAt,
    this.description,
    this.displayName,
    this.email,
    this.firstName,
    this.id,
    this.isFeatured,
    this.lastName,
    this.lastNotificationSeen,
    this.loginType,
    this.profileImage,
    this.providerId,
    this.providerType,
    this.providerTypeId,
    this.serviceAddressId,
    this.stateId,
    this.status,
    this.timeZone,
    this.uid,
    this.updatedAt,
    this.userType,
    this.username,
  });

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      address: json['address'],
      cityId: json['city_id'],
      cityName: json['city_name'],
      contactNumber: json['contact_number'],
      countryId: json['country_id'],
      createdAt: json['created_at'],
      description: json['description'],
      displayName: json['display_name'],
      email: json['email'],
      firstName: json['first_name'],
      id: json['id'],
      isFeatured: json['is_featured'],
      lastName: json['last_name'],
      lastNotificationSeen: json['last_notification_seen'],
      loginType: json['login_type'],
      profileImage: json['profile_image'],
      providerId: json['provider_id'],
      providerType: json['providertype'],
      providerTypeId: json['providertype_id'],
      serviceAddressId: json['service_address_id'],
      stateId: json['state_id'],
      status: json['status'],
      timeZone: json['time_zone'],
      uid: json['uid'],
      updatedAt: json['updated_at'],
      userType: json['user_type'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['city_id'] = this.cityId;
    data['city_name'] = this.cityName;
    data['contact_number'] = this.contactNumber;
    data['country_id'] = this.countryId;
    data['created_at'] = this.createdAt;
    data['display_name'] = this.displayName;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['id'] = this.id;
    data['is_featured'] = this.isFeatured;
    data['last_name'] = this.lastName;
    data['last_notification_seen'] = this.lastNotificationSeen;
    data['profile_image'] = this.profileImage;
    data['providertype'] = this.providerType;
    data['providertype_id'] = this.providerTypeId;
    data['state_id'] = this.stateId;
    data['status'] = this.status;
    data['time_zone'] = this.timeZone;
    data['updated_at'] = this.updatedAt;
    data['user_type'] = this.userType;
    data['username'] = this.username;
    if (this.description != null) {
      data['description'] = this.description;
    }
    if (this.loginType != null) {
      data['login_type'] = this.loginType;
    }
    if (this.providerId != null) {
      data['provider_id'] = this.providerId;
    }
    if (this.serviceAddressId != null) {
      data['service_address_id'] = this.serviceAddressId.toJson();
    }
    if (this.uid != null) {
      data['uid'] = this.uid.toJson();
    }
    return data;
  }
}

class ServiceFaq {
  String? created_at;
  String? description;
  int? id;
  int? service_id;
  int? status;
  String? title;
  String? updated_at;

  ServiceFaq({this.created_at, this.description, this.id, this.service_id, this.status, this.title, this.updated_at});

  factory ServiceFaq.fromJson(Map<String, dynamic> json) {
    return ServiceFaq(
      created_at: json['created_at'],
      description: json['description'],
      id: json['id'],
      service_id: json['service_id'],
      status: json['status'],
      title: json['title'],
      updated_at: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.created_at;
    data['description'] = this.description;
    data['id'] = this.id;
    data['service_id'] = this.service_id;
    data['status'] = this.status;
    data['title'] = this.title;
    data['updated_at'] = this.updated_at;
    return data;
  }
}
