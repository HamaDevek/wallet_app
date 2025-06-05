import 'dart:convert';

class UserModel {
  final bool? success;
  final String? message;
  final Data? data;
  final DateTime? serverTime;

  UserModel({this.success, this.message, this.data, this.serverTime});

  UserModel copyWith({
    bool? success,
    String? message,
    Data? data,
    DateTime? serverTime,
  }) => UserModel(
    success: success ?? this.success,
    message: message ?? this.message,
    data: data ?? this.data,
    serverTime: serverTime ?? this.serverTime,
  );

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    serverTime:
        json["server_time"] == null
            ? null
            : DateTime.parse(json["server_time"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
    "server_time": serverTime?.toIso8601String(),
  };
}

class Data {
  final User? user;
  final String? token;

  Data({this.user, this.token});

  Data copyWith({User? user, String? token}) =>
      Data(user: user ?? this.user, token: token ?? this.token);

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {"user": user?.toJson(), "token": token};
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final int? walletBalance;

  User({this.id, this.name, this.email, this.walletBalance});

  User copyWith({int? id, String? name, String? email, int? walletBalance}) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        walletBalance: walletBalance ?? this.walletBalance,
      );

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    walletBalance: json["wallet_balance"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "wallet_balance": walletBalance,
  };
}
