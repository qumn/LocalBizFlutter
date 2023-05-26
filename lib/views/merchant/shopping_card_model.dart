import 'package:flutter/material.dart';
import 'package:local_biz/modal/commodity.dart';

// the key is the commodity id, the value is the commodity and the quantity
typedef ShoppingCartMap = Map<int, (Commodity, int)>;

class ShoppingCartModel extends ChangeNotifier {
  final ShoppingCartMap _map = {};

  void add(Commodity commodity) {
    if (_map.containsKey(commodity.cid)) {
      _map[commodity.cid] = (commodity, _map[commodity.cid]!.$2 + 1);
    } else {
      _map[commodity.cid] = (commodity, 1);
    }
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void sub(Commodity commodity) {
    if (_map.containsKey(commodity.cid)) {
      if (_map[commodity.cid]!.$2 > 1) {
        _map[commodity.cid] = (commodity, _map[commodity.cid]!.$2 - 1);
      } else {
        _map.remove(commodity.cid);
      }
    }
    notifyListeners();
  }

  int getQuantity(int cid) {
    return _map[cid]?.$2 ?? 0;
  }
  int getAllQuantity() {
    int sum = 0;
    _map.forEach((key, value) {
      sum += value.$2;
    });
    return sum;
  }

  Commodity? getCommodity(int cid) {
    return _map[cid]?.$1;
  }

  List<Commodity> getCommodities() {
    return _map.values.map((e) => e.$1).toList();
  }

  List<int> getCommodityIds() {
    return _map.keys.toList();
  }

  int length() {
    return _map.length;
  }

  /// Removes all items from the cart.
  void clear() {
    _map.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
