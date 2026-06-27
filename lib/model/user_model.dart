
class UserModel {
  UserModel({
    this.status,
    this.message,
    this.data,
  });

  UserModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? status;
  String? message;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class Data {
  Data({
    this.token,
    this.userStatus,
    this.firstname,
    this.lastname,
    this.email,
    this.isVendor,
    this.profileAvatar,
    this.phoneNumber,
  });

  Data.fromJson(dynamic json) {
    token = json['token'];
    userStatus = json['user_status'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    isVendor = json['is_vendor'];
    phoneNumber = json['PhoneNumber'];
    profileAvatar = json['profile_avatar'] ?? json['profile_image'];
  }

  String? token;
  String? userStatus;
  String? firstname;
  String? lastname;
  String? email;
  String? isVendor;
  String? profileAvatar;
  String? phoneNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = token;
    map['user_status'] = userStatus;
    map['firstname'] = firstname;
    map['lastname'] = lastname;
    map['email'] = email;
    map['is_vendor'] = isVendor;
    map['profile_avatar'] = profileAvatar;
    map['PhoneNumber'] = phoneNumber;
    return map;
  }
}
