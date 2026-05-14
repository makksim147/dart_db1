import 'package:sqlite3/sqlite3.dart';
import '../../domain/order_address.dart';

class OrderAddressRepository {
  final Database db;

  OrderAddressRepository(this.db);

  // --- CRUD Адрес Заказа ---
  void insertOrderAddress(OrderAddress address) {
    db.execute(
      'INSERT OR REPLACE INTO order_addresses(id,addressText) VALUES(?,?)',
      [address.id, address.addressText],
    );
  }

  List<OrderAddress> getAllOrderAddresses() {
    final rows = db.select('SELECT id,addressText FROM order_addresses');
    return rows.map((row) => OrderAddress.fromMap(row)).toList();
  }

  void deleteOrderAddress(String id) {
    db.execute('DELETE FROM order_addresses WHERE id=?', [id]);
  }

  void updateOrderAddress(OrderAddress orderAddress) {
    db.execute('UPDATE order_addresses SET addressText = ? WHERE id = ?', [
      orderAddress.addressText,
      orderAddress.id,
    ]);
  }
}
