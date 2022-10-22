import 'package:handyman_provider_flutter/models/booking_list_response.dart';
import 'package:handyman_provider_flutter/models/service_model.dart';
import 'package:handyman_provider_flutter/models/user_data.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class BookingDetailResponse {
  BookingDetail? bookingDetail;
  Service? service;
  UserData? customer;
  List<BookingActivity>? bookingActivity;
  List<RatingData>? ratingData;
  ProviderData? providerData;
  List<UserData>? handymanData;
  CouponData? couponData;
  List<Taxes>? taxes;
  List<ServiceProof>? serviceProof;

  // List<Null>? handymanData;

  BookingDetailResponse({
    this.bookingDetail,
    this.service,
    this.customer,
    this.bookingActivity,
    this.ratingData,
    this.providerData,
    this.handymanData,
    this.couponData,
    this.taxes,
    this.serviceProof,
  });

  BookingDetailResponse.fromJson(Map<String, dynamic> json) {
    bookingDetail = json['booking_detail'] != null ? new BookingDetail.fromJson(json['booking_detail']) : null;
    service = json['service'] != null ? new Service.fromJson(json['service']) : null;
    customer = json['customer'] != null ? new UserData.fromJson(json['customer']) : null;
    if (json['booking_activity'] != null) {
      bookingActivity = [];
      json['booking_activity'].forEach((v) {
        bookingActivity!.add(new BookingActivity.fromJson(v));
      });
    }
    providerData = json['provider_data'] != null ? new ProviderData.fromJson(json['provider_data']) : null;
    if (json['rating_data'] != null) {
      ratingData = [];
      json['rating_data'].forEach((v) {
        ratingData!.add(new RatingData.fromJson(v));
      });
    }
    couponData = json['coupon_data'] != null ? new CouponData.fromJson(json['coupon_data']) : null;

    if (json['handyman_data'] != null) {
      handymanData = [];
      json['handyman_data'].forEach((v) {
        handymanData!.add(new UserData.fromJson(v));
      });
    }
    if (json['service_proof'] != null) {
      serviceProof = [];
      json['service_proof'].forEach((v) {
        serviceProof!.add(new ServiceProof.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bookingDetail != null) {
      data['booking_detail'] = this.bookingDetail!.toJson();
    }
    if (this.service != null) {
      data['service'] = this.service!.toJson();
    }
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    if (this.bookingActivity != null) {
      data['booking_activity'] = this.bookingActivity!.map((v) => v.toJson()).toList();
    }
    if (this.ratingData != null) {
      data['rating_data'] = this.ratingData!.map((v) => v.toJson()).toList();
    }
    if (this.couponData != null) {
      data['coupon_data'] = this.couponData!.toJson();
    }
    if (this.providerData != null) {
      data['provider_data'] = this.providerData!.toJson();
    }
    if (this.handymanData != null) {
      data['handyman_data'] = this.handymanData!.map((v) => v.toJson()).toList();
    }
    if (this.serviceProof != null) {
      data['service_proof'] = this.serviceProof!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CouponData {
  int? booking_id;
  String? code;
  String? created_at;
  String? deleted_at;
  int? discount;
  String? discount_type;
  int? id;
  String? updated_at;
  num? totalCalculatedValue;

  CouponData({this.booking_id, this.code, this.created_at, this.deleted_at, this.discount, this.discount_type, this.id, this.updated_at, this.totalCalculatedValue});

  factory CouponData.fromJson(Map<String, dynamic> json) {
    return CouponData(
      booking_id: json['booking_id'],
      code: json['code'],
      created_at: json['created_at'],
      deleted_at: json['deleted_at'],
      discount: json['discount'],
      discount_type: json['discount_type'],
      id: json['id'],
      updated_at: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.booking_id;
    data['code'] = this.code;
    data['created_at'] = this.created_at;
    data['discount'] = this.discount;
    data['deleted_at'] = this.deleted_at;
    data['discount_type'] = this.discount_type;
    data['id'] = this.id;
    data['updated_at'] = this.updated_at;
    return data;
  }
}

class BookingDetail {
  int? id;
  String? address;
  int? customerId;
  int? serviceId;
  int? providerId;
  num? price;
  int? quantity;
  String? type;
  num? discount;
  String? status;
  String? statusLabel;
  String? description;
  String? providerName;
  String? customerName;
  String? serviceName;
  String? paymentStatus;
  String? paymentMethod;
  int? totalReview;
  num? totalRating;
  int? isCancelled;
  String? reason;
  String? date;
  String? startAt;
  String? endAt;
  String? durationDiff;
  int? paymentId;
  int? booking_address_id;
  List<Taxes>? taxes;
  num? totalAmount;

  bool get isHourlyService => type.validate() == ServiceTypeHourly;

  BookingDetail({
    this.id,
    this.address,
    this.customerId,
    this.serviceId,
    this.providerId,
    this.price,
    this.quantity,
    this.type,
    this.discount,
    this.status,
    this.statusLabel,
    this.description,
    this.providerName,
    this.customerName,
    this.serviceName,
    this.paymentStatus,
    this.paymentMethod,
    this.totalReview,
    this.totalRating,
    this.isCancelled,
    this.reason,
    this.date,
    this.startAt,
    this.endAt,
    this.durationDiff,
    this.paymentId,
    this.taxes,
    this.booking_address_id,
    this.totalAmount,
  });

  BookingDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    customerId = json['customer_id'];
    serviceId = json['service_id'];
    providerId = json['provider_id'];
    price = json['price'];
    quantity = json['quantity'];
    type = json['type'];
    discount = json['discount'];
    status = json['status'];
    statusLabel = json['status_label'];
    description = json['description'];
    providerName = json['provider_name'];
    customerName = json['customer_name'];
    serviceName = json['service_name'];
    paymentStatus = json['payment_status'];
    paymentMethod = json['payment_method'];
    totalReview = json['total_review'];
    totalRating = json['total_rating'];
    isCancelled = json['is_cancelled'];
    reason = json['reason'];
    date = json['date'];
    startAt = json['start_at'];
    taxes = json['taxes'] != null ? (json['taxes'] as List).map((i) => Taxes.fromJson(i)).toList() : null;
    endAt = json['end_at'];
    durationDiff = json['duration_diff'];
    paymentId = json['payment_id'];
    booking_address_id = json['booking_address_id'];
    totalAmount = json['total_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address'] = this.address;
    data['customer_id'] = this.customerId;
    data['service_id'] = this.serviceId;
    data['provider_id'] = this.providerId;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['type'] = this.type;
    data['discount'] = this.discount;
    data['status'] = this.status;
    data['status_label'] = this.statusLabel;
    data['description'] = this.description;
    data['provider_name'] = this.providerName;
    data['customer_name'] = this.customerName;
    data['service_name'] = this.serviceName;
    data['payment_status'] = this.paymentStatus;
    data['payment_method'] = this.paymentMethod;
    data['total_review'] = this.totalReview;
    data['total_rating'] = this.totalRating;
    data['is_cancelled'] = this.isCancelled;
    data['reason'] = this.reason;
    if (this.taxes != null) {
      data['taxes'] = this.taxes!.map((v) => v.toJson()).toList();
    }
    data['date'] = this.date;
    data['start_at'] = this.startAt;
    data['end_at'] = this.endAt;
    data['duration_diff'] = this.durationDiff;
    data['payment_id'] = this.paymentId;
    data['booking_address_id'] = this.booking_address_id;
    data['total_amount'] = this.totalAmount;
    return data;
  }
}

class Customer {
  int? id;
  String? firstName;
  String? lastName;
  String? username;
  int? providerId;
  int? status;

  // String? description;
  String? userType;
  String? email;
  String? contactNumber;
  int? countryId;
  int? stateId;
  int? cityId;
  String? cityName;
  String? address;
  int? providertypeId;
  String? providertype;
  int? isFeatured;
  String? displayName;
  String? createdAt;
  String? updatedAt;
  String? profileImage;

  Customer(
      {this.id,
      this.firstName,
      this.lastName,
      this.username,
      this.providerId,
      this.status,
      // this.description,
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
      this.profileImage});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    username = json['username'];
    providerId = json['provider_id'];
    status = json['status'];
    // description = json['description'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['username'] = this.username;
    data['provider_id'] = this.providerId;
    data['status'] = this.status;
    // data['description'] = this.description;
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
    return data;
  }
}

class BookingActivity {
  int? id;
  int? bookingId;
  String? datetime;
  String? activityType;
  String? activityMessage;
  String? activityData;
  String? createdAt;
  String? updatedAt;

  BookingActivity({this.id, this.bookingId, this.datetime, this.activityType, this.activityMessage, this.activityData, this.createdAt, this.updatedAt});

  BookingActivity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['booking_id'];
    datetime = json['datetime'];
    activityType = json['activity_type'];
    activityMessage = json['activity_message'];
    activityData = json['activity_data'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['booking_id'] = this.bookingId;
    data['datetime'] = this.datetime;
    data['activity_type'] = this.activityType;
    data['activity_message'] = this.activityMessage;
    data['activity_data'] = this.activityData;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class RatingData {
  int? id;
  num? rating;
  String? review;
  int? serviceId;
  int? bookingId;
  String? createdAt;
  String? customerName;
  String? profileImage;

  RatingData({this.id, this.rating, this.review, this.serviceId, this.bookingId, this.createdAt, this.customerName, this.profileImage});

  RatingData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rating = json['rating'];
    review = json['review'];
    serviceId = json['service_id'];
    bookingId = json['booking_id'];
    createdAt = json['created_at'];
    customerName = json['customer_name'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['service_id'] = this.serviceId;
    data['booking_id'] = this.bookingId;
    data['created_at'] = this.createdAt;
    data['customer_name'] = this.customerName;
    data['profile_image'] = this.profileImage;
    return data;
  }
}

class ProviderData {
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
  int? providertypeId;
  String? providertype;
  int? isFeatured;
  String? displayName;
  String? createdAt;
  String? updatedAt;
  String? profileImage;
  String? timeZone;
  String? lastNotificationSeen;

  //String? handyman_rating;

  ProviderData({
    this.id,
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
    this.lastNotificationSeen,
    /*this.handyman_rating*/
  });

  ProviderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    username = json['username'];
    providerId = json['provider_id'];
    status = json['status'];
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
    lastNotificationSeen = json['last_notification_seen'];
    //handyman_rating = json['handyman_rating'];
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
    data['last_notification_seen'] = this.lastNotificationSeen;
    // data['handyman_rating'] = this.handyman_rating;
    return data;
  }
}

class HandymanData {
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
  int? providertypeId;
  String? providertype;
  int? isFeatured;
  String? displayName;
  String? createdAt;
  String? updatedAt;
  String? profileImage;
  String? timeZone;
  String? lastNotificationSeen;
  int? handyman_rating;

  HandymanData(
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
      this.lastNotificationSeen,
      this.handyman_rating});

  HandymanData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    username = json['username'];
    providerId = json['provider_id'];
    status = json['status'];
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
    lastNotificationSeen = json['last_notification_seen'];
    handyman_rating = json['handyman_rating'];
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
    data['last_notification_seen'] = this.lastNotificationSeen;
    data['handyman_rating'] = this.handyman_rating;
    return data;
  }
}

class ServiceProof {
  int? id;
  String? title;
  String? description;
  int? serviceId;
  int? bookingId;
  int? userId;
  String? handymanName;
  String? serviceName;
  List<String>? attachments;

  ServiceProof({
    this.id,
    this.title,
    this.description,
    this.serviceId,
    this.bookingId,
    this.userId,
    this.handymanName,
    this.serviceName,
    this.attachments,
  });

  ServiceProof.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    serviceId = json['service_id'];
    bookingId = json['booking_id'];
    userId = json['user_id'];
    handymanName = json['handyman_name'];
    serviceName = json['service_name'];
    attachments = json['attachments'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['service_id'] = this.serviceId;
    data['booking_id'] = this.bookingId;
    data['user_id'] = this.userId;
    data['handyman_name'] = this.handymanName;
    data['service_name'] = this.serviceName;
    data['attachments'] = this.attachments;
    return data;
  }
}
