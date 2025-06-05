import 'package:wallet_app/shared/env.dart';

class TransactionEndpoint {
  const TransactionEndpoint();
  String get recharge => '$apiUrl/transactions/recharge';
  String get sendMoney => '$apiUrl/transactions/send-money';
  String get receivedTransactions =>
      '$apiUrl/transactions/received-transactions';
  String get sentTransactions => '$apiUrl/transactions/sent-transactions';
  String get allTransactions => '$apiUrl/transactions/all-transactions';
}
