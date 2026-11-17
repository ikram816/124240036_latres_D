import 'package:hive/hive.dart';

class CartItem {
  final String username;
  final int productId;
  final String title;
  final double price;
  final String thumbnail;
  int quantity;

  CartItem({
    required this.username,
    required this.productId,
    required this.title,
    required this.price,
    required this.thumbnail,
    this.quantity = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'productId': productId,
      'title': title,
      'price': price,
      'thumbnail': thumbnail,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<dynamic, dynamic> map) {
    return CartItem(
      username: map['username'] as String? ?? '',
      productId: (map['productId'] as num?)?.toInt() ?? 0,
      title: map['title'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      thumbnail: map['thumbnail'] as String? ?? '',
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
    );
  }

  double get totalPrice => price * quantity;
}

class CartItemAdapter extends TypeAdapter<CartItem> {
  @override
  final int typeId = 0;

  @override
  CartItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartItem(
      username: fields[0] as String,
      productId: fields[1] as int,
      title: fields[2] as String,
      price: (fields[3] as num).toDouble(),
      thumbnail: fields[4] as String,
      quantity: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CartItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.thumbnail)
      ..writeByte(5)
      ..write(obj.quantity);
  }
}
