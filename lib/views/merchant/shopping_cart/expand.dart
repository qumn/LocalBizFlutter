import 'package:flutter/material.dart';
import 'package:local_biz/views/merchant/shopping_card_model.dart';
import 'package:provider/provider.dart';

class ExpandShoppingCart extends StatelessWidget {
  const ExpandShoppingCart({super.key});

  @override
  Widget build(BuildContext context) {
    var shoppingCartModel = Provider.of<ShoppingCartModel>(context);
    var keys = shoppingCartModel.getCommodityIds();

    return ListView.builder(
      itemCount: keys.length,
      itemExtent: 200,
      itemBuilder: (ctx, idx) {
        return Text(shoppingCartModel.getCommodity(keys[idx])?.name ?? "");
      },
    );
  }
}
