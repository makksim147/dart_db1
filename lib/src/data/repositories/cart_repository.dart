import 'package:sqlite3/sqlite3.dart';
import '../../domain/cart.dart';

class CartRepository {
  final Database db;

  CartRepository(this.db);

  // --- CRUD Корзина ---
  void insertCart(Cart cart) {
    db.execute('INSERT OR REPLACE INTO carts(id,accountId) VALUES(?,?)', [
      cart.id,
      cart.accountId,
    ]);
  }

  List<Cart> getAllCarts() {
    final rows = db.select('SELECT id,accountId FROM carts');
    return rows.map((row) => Cart.fromMap(row)).toList();
  }

  void deleteCart(String id) {
    db.execute('DELETE FROM carts WHERE id=?', [id]);
  }

  void updateCart(Cart cart) {
    db.execute('UPDATE carts SET accountId = ? WHERE id = ?', [
      cart.accountId,
      cart.id,
    ]);
  }
}
