import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoggedIn = false.obs;
  var currentUsername = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('isLoggedIn') ?? false;
    final savedUsername = prefs.getString('username') ?? '';
    if (loggedIn && savedUsername.isNotEmpty) {
      currentUsername.value = savedUsername;
      isLoggedIn.value = true;
    } else {
      isLoggedIn.value = false;
      currentUsername.value = '';
    }
  }

  Future<void> login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    // Validasi: username tidak boleh kosong dan password harus '124240036'
    if (username.isEmpty || password != '124240036') {
      Get.snackbar(
        'Login Gagal',
        'Username tidak boleh kosong dan Password harus 124240036',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // Simpan ke SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setBool('isLoggedIn', true);

    currentUsername.value = username;
    isLoggedIn.value = true;

    usernameController.clear();
    passwordController.clear();

    Get.offAllNamed(AppRoutes.main);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('username');

    currentUsername.value = '';
    isLoggedIn.value = false;

    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
