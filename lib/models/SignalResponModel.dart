class SignalResponModel {
  final int r;
  final DataResponModel data;
  final String? error;

  SignalResponModel({
    required this.r,
    required this.data,
    this.error
  });

  factory SignalResponModel.fromJson(Map<dynamic, dynamic> json) {
    return SignalResponModel(
      r: json['r'],
      data: json['data'],
      error: json['error']
    );
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['r'] = this.r;
    data['data'] = this.data;
    data['error'] = this.error;
    return data;
  }

}

class DataResponModel {
  final String request_id;
  final String? room_id;
  final String? from_user;
  final String? from_user_socket;
  final String? to_user_socket;
  final String? to_user;
  final bool? is_hotline;

  DataResponModel({
    required this.request_id,
    this.room_id,
    this.from_user,
    this.from_user_socket,
    this.to_user_socket,
    this.is_hotline,
    this.to_user
  });

  factory DataResponModel.fromJson(Map<dynamic, dynamic> json) {
    return DataResponModel(
        request_id: json['request_id'],
        room_id: json['room_id'],
        from_user: json['from_user'],
        to_user: json['to_user'],
        from_user_socket: json['from_user_socket'],
        to_user_socket: json['to_user_socket'],
        is_hotline: json['is_hotline']
    );
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['request_id'] = this.request_id;
    data['room_id'] = this.room_id;
    data['from_user'] = this.from_user;
    data['to_user'] = this.to_user;
    data['from_user_socket'] = this.from_user_socket;
    data['to_user_socket'] = this.to_user_socket;
    data['is_hotline'] = this.is_hotline;
    return data;
  }
}