import 'identity.dart';

class CartTechnique implements Identity {
  @override
  final String id;
  final String cartId;
  final String techniqueId;

  const CartTechnique({
    required this.id,
    required this.cartId,
    required this.techniqueId,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'cartId': cartId,
    'techniqueId': techniqueId,
  };

  factory CartTechnique.fromMap(Map<String, dynamic> map) {
    return CartTechnique(
      id: map['id'] as String,
      cartId: map['cartId'] as String,
      techniqueId: map['techniqueId'] as String,
    );
  }

  @override
  String toString() => 'Связь: Корзина($cartId) <-> Техника($techniqueId) (id: $id)';
}