import 'package:sqlite3/sqlite3.dart';
import '../../domain/account.dart';

class AccountRepository {
  final Database db;

  AccountRepository(this.db);

  // --- CRUD Пользователи (Accounts) ---
  void insertAccount(Account account) {
    db.execute(
      'INSERT OR REPLACE INTO accounts(id,login,email,isActive,roleId) VALUES(?,?,?,?,?)',
      [
        account.id,
        account.login,
        account.email,
        account.isActive ? 1 : 0,
        account.roleId,
      ],
    );
  }

  List<Account> getAllAccounts() {
    final rows = db.select(
      'SELECT id,login,email,isActive,roleId FROM accounts',
    );
    return rows.map((row) => Account.fromMap(row)).toList();
  }

  void deleteAccount(String id) {
    db.execute('DELETE FROM accounts WHERE id=?', [id]);
  }

  void updateAccount(Account account) {
    db.execute(
      'UPDATE accounts SET login = ?, email = ?, isActive = ?, roleId = ? WHERE id = ?',
      [
        account.login,
        account.email,
        account.isActive ? 1 : 0,
        account.roleId,
        account.id,
      ],
    );
  }
}
