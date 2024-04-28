import 'package:flutter_task/model/cart_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDatabase();
  }

  Future<Database?> initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'cart.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE CART (primaryKey INTEGER PRIMARY KEY , id INTEGER , categoryName TEXT , name TEXT , quantity INTEGER , totalPrice TEXT , colour TEXT , brandName TEXT , price TEXT , image TEXT)');
  }

  Future<CartModel> insert(CartModel cartModel) async {
    var dbClient = await db;
    await dbClient?.insert('cart', cartModel.toMap());
    return cartModel;
  }

  Future<List<CartModel>> getCartList() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult =
        await dbClient!.query('cart');

    return queryResult.map((e) => CartModel.fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient!
        .delete('cart', where: 'primaryKey = ?', whereArgs: [id]);
  }

  Future<int> update(CartModel cartModel) async {
    var dbClient = await db;
    return await dbClient!.update('cart', cartModel.toMap(),
        where: 'primaryKey = ?', whereArgs: [cartModel.primaryKey]);
  }

  Future<bool> isItemInCart(int primaryKey) async {
    var dbClient = await db;
    List<Map<String, Object?>>? result = await dbClient?.query(
      'cart',
      where: 'primaryKey = ?',
      whereArgs: [primaryKey],
    );
    return result?.isNotEmpty ?? false;
  }
}
