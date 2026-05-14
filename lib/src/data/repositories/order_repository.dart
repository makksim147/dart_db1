import 'package:sqlite3/sqlite3.dart';
import '../../domain/order.dart';

class OrderRepository {
  final Database db;

  OrderRepository(this.db);
  // --- CRUD Заказы ---
  void insertOrder(Order order) {
    db.execute(
      'INSERT OR REPLACE INTO orders(id,hasCredit,totalPrice,cartId,addressId,infoId,orderDate) VALUES(?,?,?,?,?,?,?)',
      [
        order.id,
        order.hasCredit ? 1 : 0,
        order.totalPrice,
        order.cartId,
        order.addressId,
        order.infoId,
        order.orderDate.toIso8601String(),
      ],
    );
  }

  List<Order> getAllOrders() {
    final rows = db.select(
      'SELECT id,hasCredit,totalPrice,cartId,addressId,infoId,orderDate FROM orders',
    );
    return rows.map((row) => Order.fromMap(row)).toList();
  }

  void deleteOrder(String id) {
    db.execute('DELETE FROM orders WHERE id=?', [id]);
  }

  void updateOrder(Order order) {
    db.execute(
      'UPDATE orders SET hasCredit = ?, totalPrice = ?, cartId = ?, addressId = ?, infoId = ?, orderDate = ? WHERE id = ?',
      [
        order.hasCredit ? 1 : 0,
        order.totalPrice,
        order.cartId,
        order.addressId,
        order.infoId,
        order.orderDate.toIso8601String(),
        order.id,
      ],
    );
  }
}
