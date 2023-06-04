import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:local_biz/component/image.dart';
import 'package:local_biz/component/price.dart';
import 'package:local_biz/config.dart';
import 'package:local_biz/modal/cart.dart';
import 'package:local_biz/modal/order.dart';
import 'package:local_biz/modal/specification.dart';
import 'package:local_biz/modal/specification_atb.dart';
import 'package:local_biz/views/cart/index.dart';
import 'package:local_biz/views/merchant/commodities.dart';
import 'package:go_router/go_router.dart' as go;
import 'package:local_biz/api/order.dart' as order_client;
import 'package:local_biz/api/cart.dart' as cart_client;

class SettelMentScreen extends StatefulWidget {
  const SettelMentScreen(
    this.shoppingCartModel, {
    super.key,
  });
  final ShoppingCartModel shoppingCartModel;

  @override
  State<SettelMentScreen> createState() => _SettelMentState();
}

class _SettelMentState extends State<SettelMentScreen> {
  Widget _address(BuildContext ctx, Address address) {
    var theme = Theme.of(ctx);
    var colorScheme = theme.colorScheme;
    var fontSize = theme.textTheme.bodyMedium!.fontSize;
    var addressStyle = theme.textTheme.titleLarge!.copyWith(
      fontWeight: FontWeight.bold,
    );
    var lilteTextStyle = theme.textTheme.titleMedium!.copyWith(
      fontWeight: FontWeight.w300,
    );
    // current time add 1 hour
    var time = DateTime.now().add(const Duration(minutes: 45));
    // format time
    var timeStr = "${time.hour}:${time.minute}";
    var primaryStyle = theme.textTheme.bodyMedium!.copyWith(
      color: colorScheme.primary,
    );

    return Card(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(address.address, style: addressStyle),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Text(address.name, style: lilteTextStyle),
                const SizedBox(width: 10),
                Text(address.phone, style: lilteTextStyle)
              ],
            ),
            SizedBox(height: fontSize! * 2.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("立即送出"),
                Row(
                  children: [
                    Text("大约$timeStr送达", style: primaryStyle),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios,
                        size: 12, color: colorScheme.primary)
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _merchantItem(List<Cart> carts) {
    if (carts.isEmpty) {
      return const SizedBox();
    }
    var theme = Theme.of(context);
    var merchantNameStyel = theme.textTheme.bodyMedium!.copyWith(
      fontWeight: FontWeight.bold,
    );

    var name = carts.first.merchant!.name;
    var specs = carts.map((cart) {
      cart.specification?.commodity = cart.commodity;
      return cart.specification!;
    }).toList();

    return Card(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Text(name, style: merchantNameStyel),
              const SizedBox(width: 2),
              const Icon(Icons.arrow_forward_ios, size: 12)
            ],
          ),
          Column(
            children: specs.map((spec) => _commodityItem(spec)).toList(),
          )
        ]),
      ),
    );
  }

  Widget _tagRow(List<SpecificationAtb> atbs) {
    return Row(
      children: atbs
          .take(3)
          .map((atb) => Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: Tag("${atb.key}:${atb.value}"),
              ))
          .toList(),
    );
  }

  Widget _commodityItem(Specification spec) {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    var titleStyle = theme.textTheme.titleMedium!.copyWith(
      fontWeight: FontWeight.bold,
    );
    var priceStyle = theme.textTheme.titleMedium!.copyWith(
      fontWeight: FontWeight.bold,
      color: colorScheme.primary,
    );
    var commodity = spec.commodity!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      height: 100,
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: TweenAnimationBuilder(
              duration: const Duration(milliseconds: 255),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: const Interval(0.3, 1, curve: Curves.easeIn),
              builder: (ctx, value, child) => Transform.scale(
                scale: value,
                child: Opacity(
                  opacity: value,
                  child: SizedBox(
                    height: 80,
                    child: LbImage(
                      imgUrl: commodity.img,
                      defaultImage: const AssetImage(defaultCommodityImage),
                    ),
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
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(commodity.name, style: titleStyle),
                const SizedBox(height: 8),
                _tagRow(spec.atbs),
                Expanded(child: Container()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("￥${spec.price}", style: priceStyle),
                  ],
                ),
                const SizedBox(height: 4,)
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var address = Address(
      name: "张三",
      phone: "12345678901",
      address: "北京市海淀区",
    );

    var shoppingCartmodel = widget.shoppingCartModel;
    var carts = shoppingCartmodel.selectedCarts;

    var mid2cart = carts
        .where((cart) => cart.commodity != null && cart.merchant != null)
        .groupListsBy((cart) => cart.merchant!.mid);
    var mids = mid2cart.keys.toList();

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          go.GoRouter.of(context).go("/merchant");
        }),
        title: const Text("提交订单"),
      ),
      body: Stack(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Column(
              children: [
                _address(context, address),
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                      itemCount: mids.length,
                      itemBuilder: (ctx, idx) =>
                          _merchantItem(mid2cart[mids[idx]] ?? <Cart>[])),
                ),
                // Expanded(flex: 1, child: _body(specs, "张三的麻辣香锅")),
              ],
            ),
          ),
          Align(alignment: const Alignment(0, 0.90), child: _floatLine()),
        ],
      ),
    );
  }

  void _submit(BuildContext context) async {
    var theme = Theme.of(context);
    var shoppingCart = widget.shoppingCartModel;
    var items = shoppingCart.selectedCarts
        .map((c) => OrderItem(sid: c.specification!.sid, count: c.count))
        .toList();
    var order = Order(items: items);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                Text("正在加入购物车",
                    style: theme.textTheme.titleMedium!
                        .copyWith(color: theme.colorScheme.primary)),
              ],
            )));
    try {
      await order_client.postOrder(order);
      // delete item
      await cart_client.delteCarts(shoppingCart.selectedCartIds);
    } finally {
      Navigator.of(context).pop();
      go.GoRouter.of(context).go("/merchant");
    }
  }

  Widget _floatLine() {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    var shoppingCart = widget.shoppingCartModel;
    var price = shoppingCart.selectedCarts
        .map((c) => c.specification!.price * c.count)
        .reduce((a, b) => a + b);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // width: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: const BorderRadius.all(Radius.circular(40)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Price(price ?? 0.0, fontSize: 16),
            ElevatedButton(
              onPressed: () => _submit(context),
              child: const Text("提交订单"),
            ),
          ],
        ),
      ),
    );
  }
}

class Address {
  final String name;
  final String phone;
  final String address;
  Address({required this.name, required this.phone, required this.address});
}
