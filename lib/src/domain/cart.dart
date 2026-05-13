import 'identity.dart';

class Cart implements Identity {
  @override
  final String id;
  final String accountId;

  const Cart({required this.id, required this.accountId});

  Map<String, dynamic> toMap() => {
    'id': id,
    'accountId': accountId,
  };

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      id: map['id'] as String,
      accountId: map['accountId'] as String,
    );
  }

  @override
  String toString() => 'Корзина пользователя(id): $accountId (id: $id)';
}