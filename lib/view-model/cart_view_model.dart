import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_task/helper/db_helper.dart';
import 'package:flutter_task/model/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CartViewModel with ChangeNotifier {
  DBHelper db = DBHelper();
  int _counter = 0;
  int get counter => _counter;

  // double _totalPrice = 0.00;
  // double get totalPrice => _totalPrice;

  late Future<List<CartModel>> _cart;
  Future<List<CartModel>> get cart => _cart;

  Future<List<CartModel>> getData() async {
    _cart = db.getCartList();

    return _cart;
  }

  Future<void> delete(int primaryKey) async {
    await db.delete(primaryKey);
    notifyListeners();
  }

  void _setPrefItems() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('cart_item', _counter);
    //  preferences.setDouble('total_price', _totalPrice);
    notifyListeners();
  }

  void _getPrefItems() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _counter = preferences.getInt('cart_item')!;
    //  _totalPrice = preferences.getDouble('total_price')!;
    notifyListeners();
  }

  void incrementQuantity(CartModel snapshot, int index) {
    int quantity = snapshot.quantity;
    quantity++;

    String priceString = snapshot.price;

    String cleanPriceString = priceString.replaceAll(RegExp(r'[^\d.]'), '');
    double price = double.parse(cleanPriceString);
    double totalPrice = quantity * price;

    String totalPriceString = '\$${totalPrice.toStringAsFixed(2)}';

    db.update(CartModel(
        primaryKey: index,
        id: snapshot.id,
        categoryName: snapshot.categoryName,
        name: snapshot.name,
        quantity: quantity,
        colour: snapshot.colour,
        brandName: snapshot.brandName,
        price: snapshot.price,
        totalPrice: totalPriceString,
        image: snapshot.image));

    notifyListeners();
  }

  void decrementQuantity(CartModel snapshot, int index) {
    int quantity = snapshot.quantity;
    quantity--;

    String priceString = snapshot.price;
    String totalAmountString = snapshot.totalPrice;

    String cleanPriceString = priceString.replaceAll(RegExp(r'[^\d.]'), '');
    String cleanTotalAmountString =
        totalAmountString.replaceAll(RegExp(r'[^\d.]'), '');

    double price = double.parse(cleanPriceString);
    double totalAmount = double.parse(cleanTotalAmountString);
    double totalPrice = totalAmount - price;
    String totalPriceString = '\$${totalPrice.toStringAsFixed(2)}';
    db.update(CartModel(
        primaryKey: index,
        id: snapshot.id,
        categoryName: snapshot.categoryName,
        name: snapshot.name,
        quantity: quantity,
        colour: snapshot.colour,
        brandName: snapshot.brandName,
        price: snapshot.price,
        totalPrice: totalPriceString,
        image: snapshot.image));

    notifyListeners();
  }

  void addCounter() {
    _counter++;
    _setPrefItems();
    notifyListeners();
  }

  void removeCounter() {
    _counter--;
    _setPrefItems();
    notifyListeners();
  }

  int getCounter() {
    _getPrefItems();
    return _counter;
  }

  Future<Map<String, dynamic>> fetchData() async {
    String apiUrl =
        'https://asos2.p.rapidapi.com/products/v2/list?limit=48&categoryId=4209';

    // Map<String, String> queryParams = {
    //   'store': 'US',
    //   'offset': '0',
    //   'categoryId': '4209',
    //   'limit': '48',
    //   'country': 'US',
    //   'sort': 'freshness',
    //   'currency': 'USD',
    //   'sizeSchema': 'US',
    //   'lang': 'en-US',
    // };

    final Map<String, String> headers = {
      'X-RapidAPI-Key': '5cc739eff9mshf0f0b6760ad82bcp11d58ajsn1e8ced302527',
      'X-RapidAPI-Host': 'asos2.p.rapidapi.com'
    };

    // Uri uri = Uri.parse(apiUrl);
    // uri = uri.replace(queryParameters: queryParams);

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        return jsonData;
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}
