import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:local_biz/api/cart.dart' as cartClient;
import 'package:local_biz/modal/cart.dart';
import 'package:local_biz/modal/commodity.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  late List<Cart> carts;

  @override
  void initState() {
    super.initState();
    _retriveCart();
  }

  void _retriveCart() async {
    var newCarts = await cartClient.fetchCarts();
    setState(() {
      carts = newCarts;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (carts == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (carts.isEmpty) {
      return const Center(child: Text("购物车空空如也"));
    }
    var cartMap = carts.groupListsBy((c) => c.merchant?.mid ?? 0);
    var keys = cartMap.keys.toList();

    return Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: cartMap.length,
          // itemExtent: 200, // the length is not fixed, it's based the merchant's commodities number
          itemBuilder: (BuildContext context, int idx) {
            return MerchantItem(commodities: cartMap[keys[idx]] ?? []);
          },
        ));
  }
}

class MerchantItem extends StatelessWidget {
  const MerchantItem({super.key, required this.commodities});

  // belone to same merchant
  final List<Cart> commodities;
  get merchant => commodities[0].merchant;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    for (var c in commodities) {
      print(c.toJson());
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
          color: theme.colorScheme.secondaryContainer,
          child: Column(
            children: [
              Row(
                children: [
                  Checkbox(value: true, onChanged: (b) {}),
                  Text(merchant.name),
                ],
              ),
              for (var c in commodities) CommodityItem(cart: c),
            ],
          )),
    );
  }
}

class CommodityItem extends StatelessWidget {
  const CommodityItem({super.key, required this.cart});
  final Cart cart;

  @override
  Widget build(BuildContext context) {
    var commodity = cart.commodity;
    var spec = cart.specification;

    return Container(
      child: Row(
        children: [
          Checkbox(value: true, onChanged: (b) {}),
          Text(commodity.name),
        ],
      ),
    );
  }
}
