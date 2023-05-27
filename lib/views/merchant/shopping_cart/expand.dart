import 'package:flutter/material.dart';
import 'package:local_biz/component/image.dart';
import 'package:local_biz/config.dart';
import 'package:local_biz/modal/commodity.dart';
import 'package:local_biz/views/merchant/commodities.dart';
import 'package:local_biz/views/merchant/shopping_card_model.dart';
import 'package:provider/provider.dart';

const _itemHeight = 80.0;
const _floatButtonHeight = 90.0;

class ExpandShoppingCart extends StatelessWidget {
  const ExpandShoppingCart({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    var shoppingCartModel = Provider.of<ShoppingCartModel>(context);
    var keys = shoppingCartModel.getCommodityIds();

    return Scaffold(
      body: Container(
        color: colorScheme.secondaryContainer,
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, _floatButtonHeight),
          scrollDirection: Axis.vertical,
          itemCount: keys.length,
          itemExtent: _itemHeight,
          itemBuilder: (ctx, idx) {
            var commodity = shoppingCartModel.getCommodity(keys[idx])!;
            var count = shoppingCartModel.getQuantity(keys[idx]);
            void onAdd() {
              shoppingCartModel.add(commodity);
            }

            void onSub() {
              shoppingCartModel.sub(commodity);
            }

            return ShoppingCartItem(
              commodity: commodity,
              amount: count,
              onAdd: onAdd,
              onSub: onSub,
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => Commodities(),
          //   ),
          // );
        },
        child: const SizedBox(
            height: 60, width: 90, child: Center(child: Text('去结算'))),
      ),
    );
  }
}

class ShoppingCartItem extends StatelessWidget {
  const ShoppingCartItem({
    super.key,
    required this.commodity,
    required this.amount,
    required this.onAdd,
    required this.onSub,
  });
  final Commodity commodity;
  final int amount;
  final void Function() onAdd;
  final void Function() onSub;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    var titleStyle = theme.textTheme.titleLarge;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        // divider
        border: Border(
          bottom: BorderSide(color: colorScheme.secondary, width: 1),
        ),
      ),
      child: Row(children: [
        Expanded(
          flex: 1,
          child: TweenAnimationBuilder(
            duration: const Duration(milliseconds: 255),
            tween: Tween(begin: 00.0, end: 1.0),
            curve: const Interval(0.3, 1, curve: Curves.easeIn),
            builder: (ctx, value, child) => Transform.scale(
              scale: value,
              child: Opacity(
                opacity: value,
                child: LbImage(
                  imgUrl: commodity.img,
                  defaultImage: const AssetImage(defaultCommodityImage),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(commodity.name, style: titleStyle),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Counter(amount: amount, onAdd: onAdd, onSub: onSub),
              ])
            ],
          ),
        )
      ]),
    );
  }
}
