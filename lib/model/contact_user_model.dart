class ContactUserModel {
  String ottUserId;
  String username;
  String phoneNumber;
  String displayName;

  ContactUserModel(
      {required this.ottUserId,
      required this.username,
      required this.phoneNumber,
      required this.displayName});

  factory ContactUserModel.fromJson(Map<String, dynamic> json) {
    return ContactUserModel(
        ottUserId: json['ott_user_id'],
        username: json['username'],
        phoneNumber: json['phone_number'],
        displayName: json['display_name']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ott_user_id'] = this.ottUserId;
    data['username'] = this.username;
    data['phone_number'] = this.phoneNumber;
    data['display_name'] = this.displayName;
    return data;
  }
}
