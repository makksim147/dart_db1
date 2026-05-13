import 'identity.dart';

class Order implements Identity {
  @override
  final String id;
  final bool hasCredit;
  final double totalPrice;
  final String cartId;
  final String addressId;
  final String infoId;
  final DateTime orderDate;

  const Order({
    required this.id,
    required this.hasCredit,
    required this.totalPrice,
    required this.cartId,
    required this.addressId,
    required this.infoId,
    required this.orderDate,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'hasCredit': hasCredit ? 1 : 0,
    'totalPrice': totalPrice,
    'cartId': cartId,
    'addressId': addressId,
    'infoId': infoId,
    'orderDate': orderDate.toIso8601String(),
  };

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as String,
      hasCredit: (map['hasCredit'] as int) == 1,
      totalPrice: map['totalPrice'] as double,
      cartId: map['cartId'] as String,
      addressId: map['addressId'] as String,
      infoId: map['infoId'] as String,
      orderDate: DateTime.parse(map['orderDate'] as String),
    );
  }

  @override
  String toString() => 
      'Заказ | Дата: ${orderDate.toLocal()} | Итого: $totalPrice ₽ | Кредит: $hasCredit | Корзина: $cartId | Адрес: $addressId | Инфо: $infoId (id: $id)';
}