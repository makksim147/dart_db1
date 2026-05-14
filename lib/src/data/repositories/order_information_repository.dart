import 'package:sqlite3/sqlite3.dart';
import '../../domain/order_information.dart';

class OrderInformationRepository {
  final Database db;

  OrderInformationRepository(this.db);

  // --- CRUD Инфо Заказа ---
  void insertOrderInfo(OrderInformation info) {
    db.execute(
      'INSERT OR REPLACE INTO order_informations(id,orderType) VALUES(?,?)',
      [info.id, info.orderType],
    );
  }

  List<OrderInformation> getAllOrderInfos() {
    final rows = db.select('SELECT id,orderType FROM order_informations');
    return rows.map((row) => OrderInformation.fromMap(row)).toList();
  }

  void deleteOrderInfo(String id) {
    db.execute('DELETE FROM order_informations WHERE id=?', [id]);
  }

  void updateOrderInfo(OrderInformation orderInformation) {
    db.execute('UPDATE order_informations SET orderType = ? WHERE id = ?', [
      orderInformation.orderType,
      orderInformation.id,
    ]);
  }
}
