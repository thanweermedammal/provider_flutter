import 'package:handyman_provider_flutter/models/service_detail_response.dart';

class HandymanReview {
  List<Attachments>? attchments;
  num? booking_id;
  String? created_at;
  num? customer_id;
  String? customer_name;
  num? id;
  String? customer_profile_image;
  num? rating;
  String? review;
  num? service_id;
  String? service_name;
  num? handyman_id;
  String? handyman_name;
  String? handyman_profile_image;
  String? profile_image;

  HandymanReview({
    this.attchments,
    this.profile_image,
    this.service_name,
    this.booking_id,
    this.created_at,
    this.customer_id,
    this.customer_name,
    this.customer_profile_image,
    this.handyman_id,
    this.handyman_name,
    this.handyman_profile_image,
    this.id,
    this.rating,
    this.review,
    this.service_id,
  });

  factory HandymanReview.fromJson(Map<String, dynamic> json) {
    return HandymanReview(
      attchments: json['attchments_array'] != null ? (json['attchments_array'] as List).map((i) => Attachments.fromJson(i)).toList() : null,
      booking_id: json['booking_id'],
      created_at: json['created_at'],
      customer_id: json['customer_id'],
      customer_name: json['customer_name'],
      customer_profile_image: json['customer_profile_image'],
      handyman_id: json['handyman_id'],
      handyman_name: json['handyman_name'],
      handyman_profile_image: json['handyman_profile_image'],
      id: json['id'],
      rating: json['rating'],
      review: json['review'],
      service_id: json['service_id'],
      profile_image: json['profile_image'],
      service_name: json['service_name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.booking_id;
    data['created_at'] = this.created_at;
    data['customer_id'] = this.customer_id;
    data['customer_name'] = this.customer_name;
    data['customer_profile_image'] = this.customer_profile_image;
    data['handyman_id'] = this.handyman_id;
    data['handyman_name'] = this.handyman_name;
    data['handyman_profile_image'] = this.handyman_profile_image;
    data['id'] = this.id;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['service_id'] = this.service_id;
    data['service_name'] = this.service_name;
    data['profile_image'] = this.profile_image;
    if (this.attchments != null) {
      data['attchments_array'] = this.attchments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
