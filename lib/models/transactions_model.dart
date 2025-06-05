import 'dart:convert';

class TransactionsModel {
  final bool? success;
  final String? message;
  final Data? data;
  final DateTime? serverTime;

  TransactionsModel({this.success, this.message, this.data, this.serverTime});

  TransactionsModel copyWith({
    bool? success,
    String? message,
    Data? data,
    DateTime? serverTime,
  }) => TransactionsModel(
    success: success ?? this.success,
    message: message ?? this.message,
    data: data ?? this.data,
    serverTime: serverTime ?? this.serverTime,
  );

  factory TransactionsModel.fromRawJson(String str) =>
      TransactionsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TransactionsModel.fromJson(Map<String, dynamic> json) =>
      TransactionsModel(
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
  final List<Transaction>? transactions;
  final int? totalCount;

  Data({this.transactions, this.totalCount});

  Data copyWith({List<Transaction>? transactions, int? totalCount}) => Data(
    transactions: transactions ?? this.transactions,
    totalCount: totalCount ?? this.totalCount,
  );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    transactions:
        json["transactions"] == null
            ? []
            : List<Transaction>.from(
              json["transactions"]!.map((x) => Transaction.fromJson(x)),
            ),
    totalCount: json["total_count"],
  );

  Map<String, dynamic> toJson() => {
    "transactions":
        transactions == null
            ? []
            : List<dynamic>.from(transactions!.map((x) => x.toJson())),
    "total_count": totalCount,
  };
}

class Transaction {
  final int? id;
  final int? amount;
  final String? type;
  final String? status;
  final String? description;
  final Receiver? sender;
  final Receiver? receiver;
  final int? senderId;
  final int? receiverId;
  final DateTime? createdAt;

  Transaction({
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

  Transaction copyWith({
    int? id,
    int? amount,
    String? type,
    String? status,
    String? description,
    Receiver? sender,
    Receiver? receiver,
    int? senderId,
    int? receiverId,
    DateTime? createdAt,
  }) => Transaction(
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

  factory Transaction.fromRawJson(String str) =>
      Transaction.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json["id"],
    amount: json["amount"],
    type: json["type"],
    status: json["status"],
    description: json["description"],
    sender: json["sender"] == null ? null : Receiver.fromJson(json["sender"]),
    receiver:
        json["receiver"] == null ? null : Receiver.fromJson(json["receiver"]),
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

class Receiver {
  final int? id;
  final String? name;
  final String? email;
  final int? walletBalance;

  Receiver({this.id, this.name, this.email, this.walletBalance});

  Receiver copyWith({
    int? id,
    String? name,
    String? email,
    int? walletBalance,
  }) => Receiver(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    walletBalance: walletBalance ?? this.walletBalance,
  );

  factory Receiver.fromRawJson(String str) =>
      Receiver.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Receiver.fromJson(Map<String, dynamic> json) => Receiver(
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
