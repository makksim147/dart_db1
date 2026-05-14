import 'package:sqlite3/sqlite3.dart';
import '../../domain/role.dart';

// --- CRUD Роли ---
class RoleRepository {
  final Database db;

  RoleRepository(this.db);

  void insertRole(Role role) {
    db.execute('INSERT OR REPLACE INTO roles(id,name) VALUES(?,?)', [
      role.id,
      role.name,
    ]);
  }

  List<Role> getAllRoles() {
    final rows = db.select('SELECT id,name FROM roles');
    return rows.map((row) => Role.fromMap(row)).toList();
  }

  void deleteRole(String id) {
    db.execute('DELETE FROM roles WHERE id=?', [id]);
  }

  void updateRole(Role role) {
    db.execute('UPDATE roles SET name = ? WHERE id = ?', [role.name, role.id]);
  }
}
