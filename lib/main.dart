import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/auth_controller.dart';
import 'models/cart_model.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive untuk Flutter
  await Hive.initFlutter();

  // Daftarkan CartItemAdapter jika belum terdaftar
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(CartItemAdapter());
  }

  // Buka box 'cartBox'
  await Hive.openBox('cartBox');

  // Cek sesi login di SharedPreferences (Auto-Login)
  final authController = Get.put(AuthController());
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final String? savedUsername = prefs.getString('username');

  if (isLoggedIn && savedUsername != null && savedUsername.isNotEmpty) {
    authController.currentUsername.value = savedUsername;
    authController.isLoggedIn.value = true;
  }

  final String initialRoute = isLoggedIn ? AppRoutes.main : AppRoutes.login;

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, this.initialRoute = AppRoutes.login});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Toko Awikwok',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF2196F3),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2196F3),
          primary: const Color(0xFF2196F3),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2196F3),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
      ),
      initialRoute: initialRoute,
      getPages: AppPages.pages,
    );
  }
}
