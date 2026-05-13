import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

import '../domain/role.dart';
import '../domain/account.dart';
import '../domain/technique.dart';
import '../domain/cart.dart';
import '../domain/cart_technique.dart';
import '../domain/order_address.dart';
import '../domain/order_information.dart';
import '../domain/order.dart';

class StoreDatabase {
  final Database _sqlite;

  StoreDatabase(String filePath) : _sqlite = sqlite3.open(filePath) {
    _createTables();
  }

  factory StoreDatabase.inApp() {
    final filePath = p.join(Directory.current.path, 'store.db');
    return StoreDatabase(filePath);
  }

  void _createTables() {
    _sqlite.execute('''
      CREATE TABLE IF NOT EXISTS roles (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL
      );
    ''');

    _sqlite.execute('''
      CREATE TABLE IF NOT EXISTS accounts (
        id TEXT PRIMARY KEY,
        login TEXT NOT NULL,
        email TEXT NOT NULL,
        isActive INTEGER NOT NULL,
        roleId TEXT NOT NULL,
        FOREIGN KEY (roleId) REFERENCES roles(id) ON DELETE CASCADE
      );
    ''');

    _sqlite.execute('''
      CREATE TABLE IF NOT EXISTS techniques (
        id TEXT PRIMARY KEY,
        company TEXT NOT NULL,
        country TEXT NOT NULL,
        color TEXT NOT NULL,
        type TEXT NOT NULL,
        model TEXT NOT NULL,
        price REAL NOT NULL
      );
    ''');

    _sqlite.execute('''
      CREATE TABLE IF NOT EXISTS carts (
        id TEXT PRIMARY KEY,
        accountId TEXT NOT NULL,
        FOREIGN KEY (accountId) REFERENCES accounts(id) ON DELETE CASCADE
      );
    ''');

    _sqlite.execute('''
      CREATE TABLE IF NOT EXISTS cart_techniques (
        id TEXT PRIMARY KEY,
        cartId TEXT NOT NULL,
        techniqueId TEXT NOT NULL,
        FOREIGN KEY (cartId) REFERENCES carts(id) ON DELETE CASCADE,
        FOREIGN KEY (techniqueId) REFERENCES techniques(id) ON DELETE CASCADE
      );
    ''');

    _sqlite.execute('''
      CREATE TABLE IF NOT EXISTS order_addresses (
        id TEXT PRIMARY KEY,
        addressText TEXT NOT NULL
      );
    ''');

    _sqlite.execute('''
      CREATE TABLE IF NOT EXISTS order_informations (
        id TEXT PRIMARY KEY,
        orderType TEXT NOT NULL
      );
    ''');

    _sqlite.execute('''
      CREATE TABLE IF NOT EXISTS orders (
        id TEXT PRIMARY KEY,
        hasCredit INTEGER NOT NULL,
        totalPrice REAL NOT NULL,
        cartId TEXT NOT NULL,
        addressId TEXT NOT NULL,
        infoId TEXT NOT NULL,
        orderDate TEXT NOT NULL,
        FOREIGN KEY (cartId) REFERENCES carts(id) ON DELETE CASCADE,
        FOREIGN KEY (addressId) REFERENCES order_addresses(id) ON DELETE CASCADE,
        FOREIGN KEY (infoId) REFERENCES order_informations(id) ON DELETE CASCADE
      );
    ''');
  }

  // --- CRUD Роли ---
  void insertRole(Role role) {
    _sqlite.execute('INSERT OR REPLACE INTO roles(id,name) VALUES(?,?)', [role.id, role.name]);
  }
  List<Role> getAllRoles() {
    final rows = _sqlite.select('SELECT id,name FROM roles');
    return rows.map((row) => Role.fromMap(row)).toList();
  }
  void deleteRole(String id) {
    _sqlite.execute('DELETE FROM roles WHERE id=?', [id]);
  }

  // --- CRUD Пользователи (Accounts) ---
  void insertAccount(Account account) {
    _sqlite.execute(
      'INSERT OR REPLACE INTO accounts(id,login,email,isActive,roleId) VALUES(?,?,?,?,?)',
      [account.id, account.login, account.email, account.isActive ? 1 : 0, account.roleId],
    );
  }
  List<Account> getAllAccounts() {
    final rows = _sqlite.select('SELECT id,login,email,isActive,roleId FROM accounts');
    return rows.map((row) => Account.fromMap(row)).toList();
  }
  void deleteAccount(String id) {
    _sqlite.execute('DELETE FROM accounts WHERE id=?', [id]);
  }

  // --- CRUD Техника ---
  void insertTechnique(Technique technique) {
    _sqlite.execute(
      'INSERT OR REPLACE INTO techniques(id,company,country,color,type,model,price) VALUES(?,?,?,?,?,?,?)',
      [technique.id, technique.company, technique.country, technique.color, technique.type, technique.model, technique.price],
    );
  }
  List<Technique> getAllTechniques() {
    final rows = _sqlite.select('SELECT id,company,country,color,type,model,price FROM techniques');
    return rows.map((row) => Technique.fromMap(row)).toList();
  }
  void deleteTechnique(String id) {
    _sqlite.execute('DELETE FROM techniques WHERE id=?', [id]);
  }

  // --- CRUD Корзина ---
  void insertCart(Cart cart) {
    _sqlite.execute('INSERT OR REPLACE INTO carts(id,accountId) VALUES(?,?)', [cart.id, cart.accountId]);
  }
  List<Cart> getAllCarts() {
    final rows = _sqlite.select('SELECT id,accountId FROM carts');
    return rows.map((row) => Cart.fromMap(row)).toList();
  }
  void deleteCart(String id) {
    _sqlite.execute('DELETE FROM carts WHERE id=?', [id]);
  }

  // --- CRUD Связь Корзина-Техника ---
  void insertCartTechnique(CartTechnique cartTechnique) {
    _sqlite.execute('INSERT OR REPLACE INTO cart_techniques(id,cartId,techniqueId) VALUES(?,?,?)', 
      [cartTechnique.id, cartTechnique.cartId, cartTechnique.techniqueId]);
  }
  List<CartTechnique> getAllCartTechniques() {
    final rows = _sqlite.select('SELECT id,cartId,techniqueId FROM cart_techniques');
    return rows.map((row) => CartTechnique.fromMap(row)).toList();
  }
  void deleteCartTechnique(String id) {
    _sqlite.execute('DELETE FROM cart_techniques WHERE id=?', [id]);
  }

  // --- CRUD Адрес Заказа ---
  void insertOrderAddress(OrderAddress address) {
    _sqlite.execute('INSERT OR REPLACE INTO order_addresses(id,addressText) VALUES(?,?)', [address.id, address.addressText]);
  }
  List<OrderAddress> getAllOrderAddresses() {
    final rows = _sqlite.select('SELECT id,addressText FROM order_addresses');
    return rows.map((row) => OrderAddress.fromMap(row)).toList();
  }
  void deleteOrderAddress(String id) {
    _sqlite.execute('DELETE FROM order_addresses WHERE id=?', [id]);
  }

  // --- CRUD Инфо Заказа ---
  void insertOrderInfo(OrderInformation info) {
    _sqlite.execute('INSERT OR REPLACE INTO order_informations(id,orderType) VALUES(?,?)', [info.id, info.orderType]);
  }
  List<OrderInformation> getAllOrderInfos() {
    final rows = _sqlite.select('SELECT id,orderType FROM order_informations');
    return rows.map((row) => OrderInformation.fromMap(row)).toList();
  }
  void deleteOrderInfo(String id) {
    _sqlite.execute('DELETE FROM order_informations WHERE id=?', [id]);
  }

  // --- CRUD Заказы ---
  void insertOrder(Order order) {
    _sqlite.execute(
      'INSERT OR REPLACE INTO orders(id,hasCredit,totalPrice,cartId,addressId,infoId,orderDate) VALUES(?,?,?,?,?,?,?)',
      [order.id, order.hasCredit ? 1 : 0, order.totalPrice, order.cartId, order.addressId, order.infoId, order.orderDate.toIso8601String()],
    );
  }
  List<Order> getAllOrders() {
    final rows = _sqlite.select('SELECT id,hasCredit,totalPrice,cartId,addressId,infoId,orderDate FROM orders');
    return rows.map((row) => Order.fromMap(row)).toList();
  }
  void deleteOrder(String id) {
    _sqlite.execute('DELETE FROM orders WHERE id=?', [id]);
  }

  void close() {
    _sqlite.dispose();
  }
}