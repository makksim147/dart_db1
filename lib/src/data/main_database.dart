import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

class StoreDatabase {
  final Database _sqlite;
  Database get sqlite => _sqlite;
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

  void close() {
    _sqlite.dispose();
  }
}
