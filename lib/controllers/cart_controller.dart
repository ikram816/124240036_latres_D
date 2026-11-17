import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';
import 'auth_controller.dart';

class CartController extends GetxController {
  final Box _cartBox = Hive.box('cartBox');
  final AuthController authController = Get.find<AuthController>();
  var cartItems = <CartItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  void loadCart() {
    final username = authController.currentUsername.value;
    final List<CartItem> items = [];
    for (int i = 0; i < _cartBox.length; i++) {
      final raw = _cartBox.getAt(i);
      if (raw is CartItem) {
        if (raw.username == username) {
          items.add(raw);
        }
      } else if (raw is Map) {
        final item = CartItem.fromMap(raw);
        if (item.username == username) {
          items.add(item);
        }
      }
    }
    cartItems.assignAll(items);
  }

  Future<void> addToCart(Product product, int quantity) async {
    final username = authController.currentUsername.value;

    dynamic existingKey;
    CartItem? existingItem;

    for (var key in _cartBox.keys) {
      final raw = _cartBox.get(key);
      CartItem? item;
      if (raw is CartItem) {
        item = raw;
      } else if (raw is Map) {
        item = CartItem.fromMap(raw);
      }

      if (item != null && item.username == username && item.productId == product.id) {
        existingKey = key;
        existingItem = item;
        break;
      }
    }

    if (existingItem != null && existingKey != null) {
      int newQuantity = existingItem.quantity + quantity;
      if (newQuantity > product.stock) {
        newQuantity = product.stock;
      }
      existingItem.quantity = newQuantity;
      await _cartBox.put(existingKey, existingItem.toMap());
    } else {
      int newQuantity = quantity > product.stock ? product.stock : quantity;
      final newItem = CartItem(
        username: username,
        productId: product.id,
        title: product.title,
        price: product.price,
        thumbnail: product.thumbnail,
        quantity: newQuantity,
      );
      await _cartBox.add(newItem.toMap());
    }

    loadCart();

    // Kembali ke halaman Home
    Get.back();

    // Tampilkan snackbar sukses
    Get.snackbar(
      'Sukses',
      '$quantity ${product.title} masuk ke keranjang!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> removeFromCart(int productId) async {
    final username = authController.currentUsername.value;
    for (var key in _cartBox.keys) {
      final raw = _cartBox.get(key);
      CartItem? item;
      if (raw is CartItem) {
        item = raw;
      } else if (raw is Map) {
        item = CartItem.fromMap(raw);
      }

      if (item != null && item.username == username && item.productId == productId) {
        await _cartBox.delete(key);
        break;
      }
    }
    loadCart();
  }

  double get totalPrice {
    return cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }
}
