import 'package:get/instance_manager.dart';
import 'package:wallet_app/controllers/auth_controller.dart';
import 'package:wallet_app/controllers/transaction_controller.dart';

class BindingManager extends Bindings {
  @override
  Future<void> dependencies() async {
    Get.put(AuthController(), tag: 'auth', permanent: true);
    Get.put(TransactionController(), tag: 'transaction', permanent: true);
  }

  static void delete() {}
}
