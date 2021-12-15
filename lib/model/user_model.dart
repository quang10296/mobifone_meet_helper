class UserModel {
  final int code;
  final String message;
  final DataUser? data;

  UserModel({
    required this.code,
    required this.message,
    this.data,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      data: json['data'],
      message: json['message'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    data['message'] = this.message;
    data['code'] = this.code;
    return data;
  }
}

class DataUser {
  final String? token;
  final UserInfo? userInfo;

  DataUser({
    this.token,
    this.userInfo,
  });

  factory DataUser.fromJson(Map<String, dynamic> json) {
    return DataUser(
      token: json["token"],
      userInfo: json["userinfo"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['userinfo'] = this.userInfo;
    return data;
  }
}

class UserInfo {
  final String? ott_user_id;
  final String? username;
  final String? email;
  final String? create_time;
  final String? phone_number;
  final String? display_name;
  final String? device_info;
  final String? company_name;
  final String? app_name;

  UserInfo(
      {this.ott_user_id,
      this.username,
      this.email,
      this.create_time,
      this.phone_number,
      this.display_name,
      this.device_info,
      this.company_name,
      this.app_name});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      ott_user_id: json["ott_user_id"],
      username: json["username"],
      email: json["email"],
      create_time: json["create_time"],
      phone_number: json["phone_number"],
      display_name: json["display_name"],
      device_info: json["device_info"],
      company_name: json["company_name"],
      app_name: json["app_name"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['ott_user_id'] = this.ott_user_id;
    data['username'] = this.username;
    data['create_time'] = this.create_time;
    data['phone_number'] = this.phone_number;
    data['display_name'] = this.display_name;
    data['device_info'] = this.device_info;
    data['company_name'] = this.company_name;
    data['app_name'] = this.app_name;
    return data;
  }
}

class LicenseModel {
  LicenseModel({
    required this.code,
    required this.data,
    required this.messsage,
  });
  late final int code;
  late final DataToken data;
  late final String messsage;

  LicenseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = DataToken.fromJson(json['data']);
    messsage = json['messsage'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['code'] = code;
    _data['data'] = data.toJson();
    _data['messsage'] = messsage;
    return _data;
  }
}

class DataToken {
  DataToken({
    required this.appToken,
  });
  late final String appToken;

  DataToken.fromJson(Map<String, dynamic> json) {
    appToken = json['app-token'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['app-token'] = appToken;
    return _data;
  }
}
