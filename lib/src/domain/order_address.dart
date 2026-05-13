import 'identity.dart';

class OrderAddress implements Identity {
  @override
  final String id;
  final String addressText;

  const OrderAddress({required this.id, required this.addressText});

  Map<String, dynamic> toMap() => {
    'id': id,
    'addressText': addressText,
  };

  factory OrderAddress.fromMap(Map<String, dynamic> map) {
    return OrderAddress(
      id: map['id'] as String,
      addressText: map['addressText'] as String,
    );
  }

  @override
  String toString() => 'Адрес: $addressText (id: $id)';
}