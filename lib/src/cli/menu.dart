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

import '../data/repositories/account_repository.dart';
import '../data/repositories/cart_repository.dart';
import '../data/repositories/cart_technique_repository.dart';
import '../data/repositories/order_address_repository.dart';
import '../data/repositories/order_information_repository.dart';
import '../data/repositories/order_repository.dart';
import '../data/repositories/role_repository.dart';
import '../data/repositories/technique_repository.dart';

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

// === ВАЛИДАТОРЫ ===
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

// === МЕНЮ СУЩНОСТЕЙ ===

void _roleMenu(StoreDatabase db) {
  final repo = RoleRepository(db.sqlite);
  stdout.writeln('1-Список, 2-Добавить, 3-Удалить, 4-Обновить');
  final c = stdin.readLineSync()?.trim();

  if (c == '1') {
    for (var r in repo.getAllRoles()) stdout.writeln(r);
  } else if (c == '2') {
    repo.insertRole(
      Role(
        id: _readValidString('id: '),
        name: _readValidString('название (Admin/User): '),
      ),
    );
    stdout.writeln('Сохранено.');
  } else if (c == '3') {
    repo.deleteRole(_readValidString('id для удаления: '));
  } else if (c == '4') {
    repo.updateRole(
      Role(
        id: _readValidString('Введите id роли для обновления: '),
        name: _readValidString('Новое название: '),
      ),
    );
    stdout.writeln('Обновлено.');
  }
}

void _accountMenu(StoreDatabase db) {
  final repo = AccountRepository(db.sqlite);
  stdout.writeln('1-Список, 2-Добавить, 3-Удалить, 4-Обновить');
  final c = stdin.readLineSync()?.trim();

  if (c == '1') {
    for (var a in repo.getAllAccounts()) stdout.writeln(a);
  } else if (c == '2') {
    repo.insertAccount(
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
    repo.deleteAccount(_readValidString('id для удаления: '));
  } else if (c == '4') {
    repo.updateAccount(
      Account(
        id: _readValidString('Введите id аккаунта для обновления: '),
        login: _readValidString('Новый логин: '),
        email: _readValidString('Новый email: '),
        isActive: _readBool('Активен?'),
        roleId: _readValidString('Новый id роли: '),
      ),
    );
    stdout.writeln('Обновлено.');
  }
}

void _techniqueMenu(StoreDatabase db) {
  final repo = TechniqueRepository(db.sqlite);
  stdout.writeln('1-Список, 2-Добавить, 3-Удалить, 4-Обновить');
  final c = stdin.readLineSync()?.trim();

  if (c == '1') {
    for (var t in repo.getAllTechniques()) stdout.writeln(t);
  } else if (c == '2') {
    repo.insertTechnique(
      Technique(
        id: _readValidString('id: '),
        company: _readValidString('компания: '),
        country: _readValidString('страна: '),
        color: _readValidString('цвет: '),
        type: _readValidString('тип: '),
        model: _readValidString('модель: '),
        price: _readPositiveDouble('цена (> 0): '),
      ),
    );
    stdout.writeln('Сохранено.');
  } else if (c == '3') {
    repo.deleteTechnique(_readValidString('id для удаления: '));
  } else if (c == '4') {
    repo.updateTechnique(
      Technique(
        id: _readValidString('Введите id техники для обновления: '),
        company: _readValidString('Новая компания: '),
        country: _readValidString('Новая страна: '),
        color: _readValidString('Новый цвет: '),
        type: _readValidString('Новый тип: '),
        model: _readValidString('Новая модель: '),
        price: _readPositiveDouble('Новая цена (> 0): '),
      ),
    );
    stdout.writeln('Обновлено.');
  }
}

void _cartMenu(StoreDatabase db) {
  final repo = CartRepository(db.sqlite);
  stdout.writeln('1-Список, 2-Добавить, 3-Удалить, 4-Обновить');
  final c = stdin.readLineSync()?.trim();

  if (c == '1') {
    for (var cart in repo.getAllCarts()) stdout.writeln(cart);
  } else if (c == '2') {
    repo.insertCart(
      Cart(
        id: _readValidString('id корзины: '),
        accountId: _readValidString('id пользователя: '),
      ),
    );
    stdout.writeln('Сохранено.');
  } else if (c == '3') {
    repo.deleteCart(_readValidString('id для удаления: '));
  } else if (c == '4') {
    repo.updateCart(
      Cart(
        id: _readValidString('Введите id корзины для обновления: '),
        accountId: _readValidString('Новый id пользователя: '),
      ),
    );
    stdout.writeln('Обновлено.');
  }
}

void _cartTechniqueMenu(StoreDatabase db) {
  final repo = CartTechniqueRepository(db.sqlite);
  stdout.writeln('1-Список, 2-Добавить, 3-Удалить, 4-Обновить');
  final c = stdin.readLineSync()?.trim();

  if (c == '1') {
    for (var ct in repo.getAllCartTechniques()) stdout.writeln(ct);
  } else if (c == '2') {
    repo.insertCartTechnique(
      CartTechnique(
        id: _readValidString('id связи: '),
        cartId: _readValidString('id корзины: '),
        techniqueId: _readValidString('id техники: '),
      ),
    );
    stdout.writeln('Сохранено.');
  } else if (c == '3') {
    repo.deleteCartTechnique(_readValidString('id для удаления: '));
  } else if (c == '4') {
    repo.updateCartTechnique(
      CartTechnique(
        id: _readValidString('Введите id связи для обновления: '),
        cartId: _readValidString('Новый id корзины: '),
        techniqueId: _readValidString('Новый id техники: '),
      ),
    );
    stdout.writeln('Обновлено.');
  }
}

void _addressMenu(StoreDatabase db) {
  final repo = OrderAddressRepository(db.sqlite);
  stdout.writeln('1-Список, 2-Добавить, 3-Удалить, 4-Обновить');
  final c = stdin.readLineSync()?.trim();

  if (c == '1') {
    for (var addr in repo.getAllOrderAddresses()) stdout.writeln(addr);
  } else if (c == '2') {
    repo.insertOrderAddress(
      OrderAddress(
        id: _readValidString('id адреса: '),
        addressText: _readValidString('полный адрес: '),
      ),
    );
    stdout.writeln('Сохранено.');
  } else if (c == '3') {
    repo.deleteOrderAddress(_readValidString('id для удаления: '));
  } else if (c == '4') {
    repo.updateOrderAddress(
      OrderAddress(
        id: _readValidString('Введите id адреса для обновления: '),
        addressText: _readValidString('Новый адрес: '),
      ),
    );
    stdout.writeln('Обновлено.');
  }
}

void _infoMenu(StoreDatabase db) {
  final repo = OrderInformationRepository(db.sqlite);
  stdout.writeln('1-Список, 2-Добавить, 3-Удалить, 4-Обновить');
  final c = stdin.readLineSync()?.trim();

  if (c == '1') {
    for (var info in repo.getAllOrderInfos()) stdout.writeln(info);
  } else if (c == '2') {
    repo.insertOrderInfo(
      OrderInformation(
        id: _readValidString('id инфо: '),
        orderType: _readValidString('тип заказа: '),
      ),
    );
    stdout.writeln('Сохранено.');
  } else if (c == '3') {
    repo.deleteOrderInfo(_readValidString('id для удаления: '));
  } else if (c == '4') {
    repo.updateOrderInfo(
      OrderInformation(
        id: _readValidString('Введите id инфо для обновления: '),
        orderType: _readValidString('Новый тип заказа: '),
      ),
    );
    stdout.writeln('Обновлено.');
  }
}

void _orderMenu(StoreDatabase db) {
  final repo = OrderRepository(db.sqlite);
  stdout.writeln('1-Список, 2-Добавить, 3-Удалить, 4-Обновить');
  final c = stdin.readLineSync()?.trim();

  if (c == '1') {
    for (var o in repo.getAllOrders()) stdout.writeln(o);
  } else if (c == '2') {
    repo.insertOrder(
      Order(
        id: _readValidString('id заказа: '),
        hasCredit: _readBool('в кредит?'),
        totalPrice: _readPositiveDouble('сумма: '),
        cartId: _readValidString('id корзины: '),
        addressId: _readValidString('id адреса: '),
        infoId: _readValidString('id инфо: '),
        orderDate: _readDateTime('дата: '),
      ),
    );
    stdout.writeln('Сохранено.');
  } else if (c == '3') {
    repo.deleteOrder(_readValidString('id для удаления: '));
  } else if (c == '4') {
    repo.updateOrder(
      Order(
        id: _readValidString('Введите id заказа для обновления: '),
        hasCredit: _readBool('Новое - в кредит?'),
        totalPrice: _readPositiveDouble('Новая сумма: '),
        cartId: _readValidString('Новый id корзины: '),
        addressId: _readValidString('Новый id адреса: '),
        infoId: _readValidString('Новый id инфо: '),
        orderDate: _readDateTime('Новая дата: '),
      ),
    );
    stdout.writeln('Обновлено.');
  }
}

void _printAllFromDb(StoreDatabase db) {
  stdout.writeln('\n--- ВСЕ ДАННЫЕ В БАЗЕ ---');
  stdout.writeln('\n1. Роли:');
  for (var i in RoleRepository(db.sqlite).getAllRoles()) stdout.writeln(i);
  stdout.writeln('\n2. Пользователи:');
  for (var i in AccountRepository(db.sqlite).getAllAccounts())
    stdout.writeln(i);
  stdout.writeln('\n3. Техника:');
  for (var i in TechniqueRepository(db.sqlite).getAllTechniques())
    stdout.writeln(i);
  stdout.writeln('\n4. Корзины:');
  for (var i in CartRepository(db.sqlite).getAllCarts()) stdout.writeln(i);
  stdout.writeln('\n5. Товары в корзинах (Связи):');
  for (var i in CartTechniqueRepository(db.sqlite).getAllCartTechniques())
    stdout.writeln(i);
  stdout.writeln('\n6. Адреса:');
  for (var i in OrderAddressRepository(db.sqlite).getAllOrderAddresses())
    stdout.writeln(i);
  stdout.writeln('\n7. Информация о заказах:');
  for (var i in OrderInformationRepository(db.sqlite).getAllOrderInfos())
    stdout.writeln(i);
  stdout.writeln('\n8. Заказы:');
  for (var i in OrderRepository(db.sqlite).getAllOrders()) stdout.writeln(i);
  stdout.writeln('-------------------------\n');
}
