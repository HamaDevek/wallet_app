import 'dart:convert';

class TransactionModel {
  final bool? success;
  final String? message;
  final Data? data;
  final DateTime? serverTime;

  TransactionModel({this.success, this.message, this.data, this.serverTime});

  TransactionModel copyWith({
    bool? success,
    String? message,
    Data? data,
    DateTime? serverTime,
  }) => TransactionModel(
    success: success ?? this.success,
    message: message ?? this.message,
    data: data ?? this.data,
    serverTime: serverTime ?? this.serverTime,
  );

  factory TransactionModel.fromRawJson(String str) =>
      TransactionModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
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
  final Transactions? transactions;
  final User? user;
  final int? oldBalance;
  final int? newBalance;
  final int? movedAmount;

  Data({
    this.transactions,
    this.user,
    this.oldBalance,
    this.newBalance,
    this.movedAmount,
  });

  Data copyWith({
    Transactions? transactions,
    User? user,
    int? oldBalance,
    int? newBalance,
    int? movedAmount,
  }) => Data(
    transactions: transactions ?? this.transactions,
    user: user ?? this.user,
    oldBalance: oldBalance ?? this.oldBalance,
    newBalance: newBalance ?? this.newBalance,
    movedAmount: movedAmount ?? this.movedAmount,
  );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    transactions:
        json["transactions"] == null
            ? null
            : Transactions.fromJson(json["transactions"]),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    oldBalance: json["old_balance"],
    newBalance: json["new_balance"],
    movedAmount: json["moved_amount"],
  );

  Map<String, dynamic> toJson() => {
    "transactions": transactions?.toJson(),
    "user": user?.toJson(),
    "old_balance": oldBalance,
    "new_balance": newBalance,
    "moved_amount": movedAmount,
  };
}

class Transactions {
  final int? id;
  final int? amount;
  final String? type;
  final String? status;
  final String? description;
  final User? sender;
  final User? receiver;
  final int? senderId;
  final int? receiverId;
  final DateTime? createdAt;

  Transactions({
    this.id,
    this.amount,
    this.type,
    this.status,
    this.description,
    this.sender,
    this.receiver,
    this.senderId,
    this.receiverId,
    this.createdAt,
  });

  Transactions copyWith({
    int? id,
    int? amount,
    String? type,
    String? status,
    String? description,
    User? sender,
    User? receiver,
    int? senderId,
    int? receiverId,
    DateTime? createdAt,
  }) => Transactions(
    id: id ?? this.id,
    amount: amount ?? this.amount,
    type: type ?? this.type,
    status: status ?? this.status,
    description: description ?? this.description,
    sender: sender ?? this.sender,
    receiver: receiver ?? this.receiver,
    senderId: senderId ?? this.senderId,
    receiverId: receiverId ?? this.receiverId,
    createdAt: createdAt ?? this.createdAt,
  );

  factory Transactions.fromRawJson(String str) =>
      Transactions.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Transactions.fromJson(Map<String, dynamic> json) => Transactions(
    id: json["id"],
    amount: json["amount"],
    type: json["type"],
    status: json["status"],
    description: json["description"],
    sender: json["sender"] == null ? null : User.fromJson(json["sender"]),
    receiver: json["receiver"] == null ? null : User.fromJson(json["receiver"]),
    senderId: json["sender_id"],
    receiverId: json["receiver_id"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "amount": amount,
    "type": type,
    "status": status,
    "description": description,
    "sender": sender?.toJson(),
    "receiver": receiver?.toJson(),
    "sender_id": senderId,
    "receiver_id": receiverId,
    "created_at": createdAt?.toIso8601String(),
  };
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
