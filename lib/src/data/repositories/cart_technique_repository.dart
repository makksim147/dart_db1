import 'package:sqlite3/sqlite3.dart';
import '../../domain/cart_technique.dart';

class CartTechniqueRepository {
  final Database db;

  CartTechniqueRepository(this.db);

  // --- CRUD Связь Корзина-Техника ---
  void insertCartTechnique(CartTechnique cartTechnique) {
    db.execute(
      'INSERT OR REPLACE INTO cart_techniques(id,cartId,techniqueId) VALUES(?,?,?)',
      [cartTechnique.id, cartTechnique.cartId, cartTechnique.techniqueId],
    );
  }

  List<CartTechnique> getAllCartTechniques() {
    final rows = db.select('SELECT id,cartId,techniqueId FROM cart_techniques');
    return rows.map((row) => CartTechnique.fromMap(row)).toList();
  }

  void deleteCartTechnique(String id) {
    db.execute('DELETE FROM cart_techniques WHERE id=?', [id]);
  }

  void updateCartTechnique(CartTechnique cart_technique) {
    db.execute(
      'UPDATE cart_techniques SET cartId = ?, techniqueId = ? WHERE id = ?',
      [cart_technique.cartId, cart_technique.techniqueId, cart_technique.id],
    );
  }
}
