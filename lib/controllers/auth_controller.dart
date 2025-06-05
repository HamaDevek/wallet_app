import 'package:get/get.dart';
import 'package:wallet_app/api/endpoint_helper.dart';
import 'package:wallet_app/api/http_helper.dart';
import 'package:wallet_app/controllers/transaction_controller.dart';
import 'package:wallet_app/models/user_model.dart';
import 'package:wallet_app/pages/app_page.dart';
import 'package:wallet_app/utils/shared_preferences_helper.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find<AuthController>(tag: 'auth');
  var isLoggedIn = false; // default to false
  RxBool isLoading = false.obs;
  Rx<UserModel?> user = Rx<UserModel?>(null);
  Future<bool> login({required String email, required String password}) async {
    isLoading.value = true;
    try {
      final response = await HttpHelper.instance.post(
        EndpointHelper.auth.login,
        body: {'email': email, 'password': password},
      );
      print('Login response: ${response.body}');
      if (response.statusCode == 200) {
        isLoggedIn = true;
        UserModel user = UserModel.fromRawJson(response.body);
        SharedPreferencesHelper.save(user.toJson(), 'auth_user');
        this.user.value = user;
        print('Login successful: ${user.toJson()}');
        return true;
      } else {
        print('Login failed: ${response.body}');
        isLoggedIn = false;
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      isLoggedIn = false;
      isLoading.value = false;
      return false;
    } finally {
      isLoggedIn = false;
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    try {
      final response = await HttpHelper.instance.delete(
        EndpointHelper.auth.logout,
      );
      if (response.statusCode == 200) {
        isLoggedIn = false;
        user.value = null;
        SharedPreferencesHelper.remove('auth_user');
        Get.offAllNamed(AppPage.routeName);
        print('Logout successful');
      } else {
        print('Logout failed: ${response.body}');
      }
    } catch (e) {
      print('Logout error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    final response = await HttpHelper.instance.post(
      EndpointHelper.auth.register,
      body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      },
    );

    try {
      if (response.statusCode == 201) {
        isLoggedIn = true;
        UserModel user = UserModel.fromRawJson(response.body);
        this.user.value = user;
        SharedPreferencesHelper.save(user.toJson(), 'auth_user');
        print('Login successful: ${user.toJson()}');
        return true;
      } else {
        print('Login failed: ${response.body}');
        isLoggedIn = false;
        return false;
      }
    } catch (e) {
      print('Registration error: $e');
      isLoading.value = false;
      isLoggedIn = false;
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> me() async {
    isLoading.value = true;
    try {
      final response = await HttpHelper.instance.get(EndpointHelper.auth.me);
      if (response.statusCode == 200) {
        isLoggedIn = true;
        UserModel user = UserModel.fromRawJson(response.body);
        this.user.value = user;
        SharedPreferencesHelper.save(user.toJson(), 'auth_user');
        print('Login successful: ${user.toJson()}');
        TransactionController.to.getAllTransactions();
      } else {
        print('Login failed: ${response.body}');
        isLoggedIn = false;
        logout();
      }
    } catch (e) {
      print('Login error: $e');
      isLoggedIn = false;
      isLoading.value = false;
    } finally {
      isLoggedIn = false;
      isLoading.value = false;
    }
  }

  // set UserModel from SharedPreferences
  Future<void> setUserFromSharedPreferences() async {
    Map<dynamic, dynamic>? userMap = SharedPreferencesHelper.getMap(
      'auth_user',
    );
    if (userMap != null) {
      user.value = UserModel.fromJson(Map<String, dynamic>.from(userMap));
      isLoggedIn = true;
    } else {
      user.value = null;
      isLoggedIn = false;
    }
    me();
  }
}
