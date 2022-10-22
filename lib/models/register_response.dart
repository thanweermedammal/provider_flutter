class RegisterResponse {
  RegisterData? data;
  String? message;

  RegisterResponse({this.data, this.message});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      data: json['data'] != null ? RegisterData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class RegisterData {
  String? api_token;
  String? contact_number;
  String? display_name;
  String? email;
  String? first_name;
  String? last_name;
  String? user_type;
  String? username;
  int? provider_id;
  var status;
  String? address;
  String? uid;
  String? password;

  RegisterData(
      {this.api_token,
      this.contact_number,
      this.display_name,
      this.email,
      this.password,
      this.first_name,
      required this.last_name,
      this.user_type,
      required this.username,
      this.provider_id,
      this.status,
      this.address,
      this.uid});

  factory RegisterData.fromJson(Map<String, dynamic> json) {
    return RegisterData(
      api_token: json['api_token'],
      contact_number: json['contact_number'],
      display_name: json['display_name'],
      email: json['email'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      user_type: json['user_type'],
      username: json['username'],
      provider_id: json['provider_id'],
      status: json['status'],
      address: json['address'],
      uid: json['uid'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['api_token'] = this.api_token;
    data['contact_number'] = this.contact_number;
    data['display_name'] = this.display_name;
    data['email'] = this.email;
    data['first_name'] = this.first_name;
    data['last_name'] = this.last_name;
    data['user_type'] = this.user_type;
    data['username'] = this.username;
    data['provider_id'] = this.provider_id;
    data['status'] = this.status;
    data['address'] = this.address;
    data['uid'] = this.uid;
    return data;
  }
}
