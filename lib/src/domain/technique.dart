import 'identity.dart';

class Technique implements Identity {
  @override
  final String id;
  final String company;
  final String country;
  final String color;
  final String type;
  final String model;
  final double price;

  const Technique({
    required this.id,
    required this.company,
    required this.country,
    required this.color,
    required this.type,
    required this.model,
    required this.price,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'company': company,
    'country': country,
    'color': color,
    'type': type,
    'model': model,
    'price': price,
  };

  factory Technique.fromMap(Map<String, dynamic> map) {
    return Technique(
      id: map['id'] as String,
      company: map['company'] as String,
      country: map['country'] as String,
      color: map['color'] as String,
      type: map['type'] as String,
      model: map['model'] as String,
      price: map['price'] as double,
    );
  }

  @override
  String toString() => '$company $model ($color, $type, $country) | $price ₽ (id: $id)';
}