import 'dart:io';

import '../data/main_database.dart';
import '../domain/role.dart';
import '../domain/account.dart';
import '../domain/technique.dart';
import '../domain/cart.dart';
import '../domain/cart_technique.dart';
import '../domain/order_address.dart';
import '../domain/order_information.dart';
import '../domain/order.dart';

void runMenu(StoreDatabase db) {
  while (true) {
    stdout.writeln('''
--- МАГАЗИН ТЕХНИКИ ---
1 — Управление ролями
2 — Управление пользователями (Accounts)
3 — Управление техникой
4 — Управление корзинами
5 — Управление связями (Товары в корзине)
6 — Управление адресами доставки
7 — Управление инфо заказа (Самовывоз/Доставка)
8 — Управление заказами
9 — ПОКАЗАТЬ ВСЁ ИЗ БАЗЫ (Дамп)
0 — выход
Выберите пункт:''');

    final choice = stdin.readLineSync()?.trim() ?? '';
    switch (choice) {
      case '1':
        _roleMenu(db);
        break;
      case '2':
        _accountMenu(db);
        break;
      case '3':
        _techniqueMenu(db);
        break;
      case '4':
        _cartMenu(db);
        break;
      case '5':
        _cartTechniqueMenu(db);
        break;
      case '6':
        _addressMenu(db);
        break;
      case '7':
        _infoMenu(db);
        break;
      case '8':
        _orderMenu(db);
        break;
      case '9':
        _printAllFromDb(db);
        break;
      case '0':
        stdout.writeln('До свидания.');
        return;
      default:
        stdout.writeln('Неизвестная команда.');
    }
  }
}

String _readValidString(String label) {
  while (true) {
    stdout.write(label);
    final input = stdin.readLineSync()?.trim() ?? '';
    if (input.isNotEmpty) return input;
    stdout.writeln('Ошибка: Поле не может быть пустым!');
  }
}

double _readPositiveDouble(String label) {
  while (true) {
    stdout.write(label);
    final input = stdin.readLineSync()?.trim().replaceAll(',', '.') ?? '';
    final number = double.tryParse(input);
    if (number != null && number > 0) return number;
    stdout.writeln('Ошибка: Введите корректное число больше 0!');
  }
}

bool _readBool(String label) {
  while (true) {
    stdout.write('$label (y/n): ');
    final input = stdin.readLineSync()?.trim().toLowerCase();
    if (input == 'y') return true;
    if (input == 'n') return false;
    stdout.writeln('Ошибка: Введите "y" или "n".');
  }
}

DateTime _readDateTime(String label) {
  while (true) {
    stdout.write(label);
    final input = stdin.readLineSync()?.trim() ?? '';
    try {
      return DateTime.parse(input);
    } catch (e) {
      stdout.writeln('Ошибка: Неверный формат даты! Пример: 2026-05-07 14:30');
    }
  }
}

void _roleMenu(StoreDatabase db) {
  stdout.writeln('1-Список, 2-Добавить, 3-Удалить');
  final c = stdin.readLineSync()?.trim();
  if (c == '1') {
    for (var r in db.getAllRoles()) stdout.writeln(r);
  } else if (c == '2') {
    db.insertRole(
      Role(
        id: _readValidString('id: '),
        name: _readValidString('название (Admin/User): '),
      ),
    );
    stdout.writeln('Сохранено.');
  } else if (c == '3') {
    db.deleteRole(_readValidString('id для удаления: '));
  }
}

void _accountMenu(StoreDatabase db) {
  stdout.writeln('1-Список, 2-Добавить, 3-Удалить');
  final c = stdin.readLineSync()?.trim();
  if (c == '1') {
    for (var a in db.getAllAccounts()) stdout.writeln(a);
  } else if (c == '2') {
    db.insertAccount(
      Account(
        id: _readValidString('id: '),
        login: _readValidString('логин: '),
        email: _readValidString('email: '),
        isActive: _readBool('активен?'),
        roleId: _readValidString('id роли: '),
      ),
    );
    stdout.writeln('Сохранено.');
  } else if (c == '3') {
    db.deleteAccount(_readValidString('id для удаления: '));
  }
}

void _techniqueMenu(StoreDatabase db) {
  stdout.writeln('1-Список, 2-Добавить, 3-Удалить');
  final c = stdin.readLineSync()?.trim();
  if (c == '1') {
    for (var t in db.getAllTechniques()) stdout.writeln(t);
  } else if (c == '2') {
    db.insertTechnique(
      Technique(
        id: _readValidString('id: '),
        company: _readValidString('компания: '),
        country: _readValidString('страна: '),
        color: _readValidString('цвет: '),
        type: _readValidString('тип (телефон/тв): '),
        model: _readValidString('модель: '),
        price: _readPositiveDouble('цена (> 0): '),
      ),
    );
    stdout.writeln('Сохранено.');
  } else if (c == '3') {
    db.deleteTechnique(_readValidString('id для удаления: '));
  }
}

void _cartMenu(StoreDatabase db) {
  stdout.writeln('1-Список, 2-Добавить, 3-Удалить');
  final c = stdin.readLineSync()?.trim();
  if (c == '1') {
    for (var cart in db.getAllCarts()) stdout.writeln(cart);
  } else if (c == '2') {
    db.insertCart(
      Cart(
        id: _readValidString('id корзины: '),
        accountId: _readValidString('id пользователя: '),
      ),
    );
    stdout.writeln('Сохранено.');
  } else if (c == '3') {
    db.deleteCart(_readValidString('id для удаления: '));
  }
}

void _cartTechniqueMenu(StoreDatabase db) {
  stdout.writeln('1-Список, 2-Добавить, 3-Удалить');
  final c = stdin.readLineSync()?.trim();
  if (c == '1') {
    for (var ct in db.getAllCartTechniques()) stdout.writeln(ct);
  } else if (c == '2') {
    db.insertCartTechnique(
      CartTechnique(
        id: _readValidString('id связи: '),
        cartId: _readValidString('id корзины: '),
        techniqueId: _readValidString('id техники: '),
      ),
    );
    stdout.writeln('Сохранено.');
  } else if (c == '3') {
    db.deleteCartTechnique(_readValidString('id для удаления: '));
  }
}

void _addressMenu(StoreDatabase db) {
  stdout.writeln('1-Список, 2-Добавить, 3-Удалить');
  final c = stdin.readLineSync()?.trim();
  if (c == '1') {
    for (var addr in db.getAllOrderAddresses()) stdout.writeln(addr);
  } else if (c == '2') {
    db.insertOrderAddress(
      OrderAddress(
        id: _readValidString('id адреса: '),
        addressText: _readValidString('полный адрес: '),
      ),
    );
    stdout.writeln('Сохранено.');
  } else if (c == '3') {
    db.deleteOrderAddress(_readValidString('id для удаления: '));
  }
}

void _infoMenu(StoreDatabase db) {
  stdout.writeln('1-Список, 2-Добавить, 3-Удалить');
  final c = stdin.readLineSync()?.trim();
  if (c == '1') {
    for (var info in db.getAllOrderInfos()) stdout.writeln(info);
  } else if (c == '2') {
    db.insertOrderInfo(
      OrderInformation(
        id: _readValidString('id инфо: '),
        orderType: _readValidString('тип заказа (Доставка/Самовывоз): '),
      ),
    );
    stdout.writeln('Сохранено.');
  } else if (c == '3') {
    db.deleteOrderInfo(_readValidString('id для удаления: '));
  }
}

void _orderMenu(StoreDatabase db) {
  stdout.writeln('1-Список, 2-Добавить, 3-Удалить');
  final c = stdin.readLineSync()?.trim();
  if (c == '1') {
    for (var o in db.getAllOrders()) stdout.writeln(o);
  } else if (c == '2') {
    db.insertOrder(
      Order(
        id: _readValidString('id заказа: '),
        hasCredit: _readBool('в кредит?'),
        totalPrice: _readPositiveDouble('итоговая сумма: '),
        cartId: _readValidString('id корзины: '),
        addressId: _readValidString('id адреса: '),
        infoId: _readValidString('id инфо: '),
        orderDate: _readDateTime('дата (например 2024-05-07 14:30): '),
      ),
    );
    stdout.writeln('Сохранено.');
  } else if (c == '3') {
    db.deleteOrder(_readValidString('id для удаления: '));
  }
}

void _printAllFromDb(StoreDatabase db) {
  stdout.writeln('\n--- ВСЕ ДАННЫЕ В БАЗЕ ---');

  stdout.writeln('\n1. Роли:');
  for (var i in db.getAllRoles()) stdout.writeln(i);

  stdout.writeln('\n2. Пользователи:');
  for (var i in db.getAllAccounts()) stdout.writeln(i);

  stdout.writeln('\n3. Техника:');
  for (var i in db.getAllTechniques()) stdout.writeln(i);

  stdout.writeln('\n4. Корзины:');
  for (var i in db.getAllCarts()) stdout.writeln(i);

  stdout.writeln('\n5. Товары в корзинах (Связи):');
  for (var i in db.getAllCartTechniques()) stdout.writeln(i);

  stdout.writeln('\n6. Адреса:');
  for (var i in db.getAllOrderAddresses()) stdout.writeln(i);

  stdout.writeln('\n7. Информация о заказах:');
  for (var i in db.getAllOrderInfos()) stdout.writeln(i);

  stdout.writeln('\n8. Заказы:');
  for (var i in db.getAllOrders()) stdout.writeln(i);

  stdout.writeln('-------------------------\n');
}
