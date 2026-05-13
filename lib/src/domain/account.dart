import 'identity.dart';

class Account implements Identity {
  @override
  final String id;
  final String login;
  final String email;
  final bool isActive;
  final String roleId;

  const Account({
    required this.id,
    required this.login,
    required this.email,
    required this.isActive,
    required this.roleId,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'login': login,
    'email': email,
    'isActive': isActive ? 1 : 0,
    'roleId': roleId,
  };

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'] as String,
      login: map['login'] as String,
      email: map['email'] as String,
      isActive: (map['isActive'] as int) == 1,
      roleId: map['roleId'] as String,
    );
  }

  @override
  String toString() => 'Аккаунт: $login | $email | Активен: $isActive | Роль(id): $roleId (id: $id)';
}