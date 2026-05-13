import 'package:test/test.dart';
import 'package:main/src/domain/role.dart';
import 'package:main/src/domain/account.dart';

void main() {
  group('Domain Models Test', () {
    
    test('Role fromMap/toMap validation', () {
      final role = Role(id: 'r1', name: 'Admin');
      final map = role.toMap();
      
      expect(map['id'], 'r1');
      expect(map['name'], 'Admin');

      final newRole = Role.fromMap(map);
      expect(newRole.id, 'r1');
      expect(newRole.name, 'Admin');
    });

    test('Account boolean parsing (isActive)', () {
      final acc = Account(id: 'a1', login: 'test', email: 'test@mail.com', isActive: true, roleId: 'r1');
      
      final map = acc.toMap();
      expect(map['isActive'], 1);

      final newAcc = Account.fromMap(map);
      expect(newAcc.isActive, true);
    });

  });
}