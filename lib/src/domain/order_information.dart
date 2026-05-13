import 'identity.dart';

class OrderInformation implements Identity {
  @override
  final String id;
  final String orderType;

  const OrderInformation({required this.id, required this.orderType});

  Map<String, dynamic> toMap() => {
    'id': id,
    'orderType': orderType,
  };

  factory OrderInformation.fromMap(Map<String, dynamic> map) {
    return OrderInformation(
      id: map['id'] as String,
      orderType: map['orderType'] as String,
    );
  }

  @override
  String toString() => 'Тип заказа: $orderType (id: $id)';
}