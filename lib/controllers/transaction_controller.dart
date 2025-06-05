import 'dart:convert';
import 'package:get/get.dart';
import 'package:wallet_app/api/endpoint_helper.dart';
import 'package:wallet_app/api/http_helper.dart';
import 'package:wallet_app/controllers/auth_controller.dart';
import 'package:wallet_app/models/transactions_model.dart';
import 'package:wallet_app/models/user_model.dart';

class TransactionController extends GetxController {
  static TransactionController get to =>
      Get.find<TransactionController>(tag: 'transaction');

  RxBool isLoading = false.obs;
  Rx<UserModel?> user = Rx<UserModel?>(null);
  RxList<TransactionsModel> transactions = RxList<TransactionsModel>([]);
  RxList<TransactionsModel> receivedTransactions = RxList<TransactionsModel>(
    [],
  );
  RxList<TransactionsModel> sentTransactions = RxList<TransactionsModel>([]);

  Future<bool> recharge({required double amount}) async {
    isLoading.value = true;
    try {
      final response = await HttpHelper.instance.post(
        EndpointHelper.transactions.recharge,
        body: {'amount': amount},
      );
      print('Recharge response: ${response.body}');
      if (response.statusCode == 200) {
        await AuthController.to.me();
        return true;
      } else {
        print('Recharge failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Recharge error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to parse transaction responses
  List<TransactionsModel> _parseTransactionResponse(dynamic responseBody) {
    try {
      // Handle both string and already parsed responses
      dynamic responseData = responseBody;

      // If response.body is a string, parse it
      if (responseData is String) {
        responseData = json.decode(responseData);
      }

      print('Parsed response data type: ${responseData.runtimeType}');
      print('Parsed response data: $responseData');

      // If the response is directly a TransactionModel format
      if (responseData is Map<String, dynamic>) {
        // Single TransactionModel response
        return [TransactionsModel.fromJson(responseData)];
      } else if (responseData is List) {
        // List of TransactionsModel responses
        return responseData
            .map((e) {
              try {
                if (e is String) {
                  return TransactionsModel.fromRawJson(e);
                } else if (e is Map<String, dynamic>) {
                  return TransactionsModel.fromJson(e);
                } else {
                  print('Unexpected transaction item type: ${e.runtimeType}');
                  return null;
                }
              } catch (parseError) {
                print('Error parsing individual transaction: $parseError');
                print('Transaction data: $e');
                return null;
              }
            })
            .where((transaction) => transaction != null)
            .cast<TransactionsModel>()
            .toList();
      } else {
        print('Unexpected response format: ${responseData.runtimeType}');
        return [];
      }
    } catch (e) {
      print('Error in _parseTransactionResponse: $e');
      return [];
    }
  }

  // Fixed getAllTransactions method
  Future<void> getAllTransactions() async {
    isLoading.value = true;
    try {
      final response = await HttpHelper.instance.get(
        EndpointHelper.transactions.allTransactions,
      );

      print('Get all transactions response status: ${response.statusCode}');
      print('Get all transactions response body: ${response.body}');

      if (response.statusCode == 200) {
        List<TransactionsModel> transactions = _parseTransactionResponse(
          response.body,
        );
        this.transactions.value = transactions;
        print('Successfully fetched ${this.transactions.length} transactions');
      } else {
        print(
          'Failed to fetch all transactions: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error fetching all transactions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Fixed getSentTransactions method
  Future<void> getSentTransactions() async {
    isLoading.value = true;
    try {
      final response = await HttpHelper.instance.get(
        EndpointHelper.transactions.sentTransactions,
      );

      print('Get sent transactions response status: ${response.statusCode}');
      print('Get sent transactions response body: ${response.body}');

      if (response.statusCode == 200) {
        List<TransactionsModel> transactions = _parseTransactionResponse(
          response.body,
        );
        this.sentTransactions.value = transactions;
        print(
          'Successfully fetched ${this.sentTransactions.length} sent transactions',
        );
      } else {
        print(
          'Failed to fetch sent transactions: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error fetching sent transactions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Fixed getReceivedTransactions method
  Future<void> getReceivedTransactions() async {
    isLoading.value = true;
    try {
      final response = await HttpHelper.instance.get(
        EndpointHelper.transactions.receivedTransactions,
      );

      print(
        'Get received transactions response status: ${response.statusCode}',
      );
      print('Get received transactions response body: ${response.body}');

      if (response.statusCode == 200) {
        List<TransactionsModel> transactions = _parseTransactionResponse(
          response.body,
        );
        this.receivedTransactions.value = transactions;
        print(
          'Successfully fetched ${this.receivedTransactions.length} received transactions',
        );
      } else {
        print(
          'Failed to fetch received transactions: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error fetching received transactions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Fixed sendMoney method
  Future<bool> sendMoney({
    required String email,
    required double amount,
    String? description,
  }) async {
    isLoading.value = true;
    try {
      final body = {'recipient_email': email, 'amount': amount};

      if (description != null && description.isNotEmpty) {
        body['description'] = description;
      }

      final response = await HttpHelper.instance.post(
        EndpointHelper.transactions.sendMoney,
        body: body,
      );

      print('Send money response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        // Refresh user data and transactions
        await AuthController.to.me();
        await getSentTransactions();
        await getReceivedTransactions();
        return true;
      } else {
        print('Send money failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Send money error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
