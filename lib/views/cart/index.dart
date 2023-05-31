import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:local_biz/api/cart.dart' as cart_client;
import 'package:local_biz/component/image.dart';
import 'package:local_biz/component/price.dart';
import 'package:local_biz/config.dart';
import 'package:local_biz/modal/cart.dart';
import 'package:local_biz/views/merchant/commodities.dart';
import 'package:provider/provider.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  bool _loading = true;
  late List<Cart> carts;
  Set<int> selectedCartIds = {};

  @override
  void initState() {
    super.initState();
    _retriveCart();
  }

  void _retriveCart() async {
    var newCarts = await cart_client.fetchCarts();
    setState(() {
      carts = newCarts;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (carts.isEmpty) {
      return const Center(child: Text("购物车空空如也"));
    }
    var cartMap = carts.groupListsBy((c) => c.merchant?.mid ?? 0);
    var keys = cartMap.keys.toList();

    return ChangeNotifierProvider(
      create: (ctx) => ShoppingCartModel(carts),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 7,
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                itemCount: cartMap.length,
                // itemExtent: 200, // the length is not fixed, it's based the merchant's commodities number
                itemBuilder: (BuildContext context, int idx) {
                  return MerchantItem(commodities: cartMap[keys[idx]] ?? []);
                },
              ),
            ),
          ),
          const Expanded(flex: 1, child: Bottom())
        ],
      ),
    );
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
    var shoppingCart = Provider.of<ShoppingCartModel>(context);
    var isAllSelected =
        commodities.every((c) => shoppingCart.isCartSelected(c.carId));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
          child: Column(
        children: [
          Row(
            children: [
              Checkbox(
                  value: isAllSelected,
                  onChanged: (b) {
                    if (b == true) {
                      shoppingCart.adds(commodities.map((c) => c.carId));
                    } else {
                      shoppingCart.removes(commodities.map((c) => c.carId));
                    }
                    // add all cart in the merchant
                  }),
              _title(context, merchant.name),
            ],
          ),
          for (var c in commodities) CommodityItem(cart: c),
        ],
      )),
    );
  }

  Widget _title(BuildContext ctx, String name) {
    var theme = Theme.of(ctx);
    var style = theme.textTheme.titleMedium?.copyWith(
        color: theme.colorScheme.onSecondaryContainer,
        fontWeight: FontWeight.bold,
        fontSize: 16);

    return Row(
      children: [
        Text(name, style: style),
        Icon(Icons.arrow_right_rounded,
            color: theme.colorScheme.onSecondaryContainer)
      ],
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
    var shoppingCart = Provider.of<ShoppingCartModel>(context);
    var titleStyle = Theme.of(context).textTheme.titleMedium!.copyWith(
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        fontWeight: FontWeight.bold,
        fontSize: 16);

    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Checkbox(
              value: shoppingCart.isCartSelected(cart.carId),
              onChanged: (b) {
                if (b == true) {
                  shoppingCart.add(cart.carId);
                } else {
                  shoppingCart.remove(cart.carId);
                }
              }),
          SizedBox(
            height: 80,
            width: 80,
            child: LbImage(
              imgUrl: commodity.img,
              defaultImage: const AssetImage(defaultCommodityImage),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(commodity.name, style: titleStyle),
                Row(
                  children: spec.atbs
                      .map((atb) => Tag("${atb.key}: ${atb.value}"))
                      .toList(),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Price(
                      spec.price,
                      fontSize: 14,
                    ),
                    // Expanded(child: Container()),
                    SizedBox(
                      height: 30,
                      child: Counter(
                        amount: cart.count,
                        onAdd: () {
                          shoppingCart.changeCount(cart.carId, cart.count + 1);
                        },
                        onSub: () {
                          shoppingCart.changeCount(cart.carId, cart.count - 1);
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Bottom extends StatelessWidget {
  const Bottom({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    var littleStyle = theme.textTheme.bodySmall
        ?.copyWith(fontWeight: FontWeight.w200, fontSize: 12);

    var shoppingCart = Provider.of<ShoppingCartModel>(context);
    var selectedCartIds = shoppingCart.selectedCartIds;
    var total = 0.0;

    for (var cid in selectedCartIds) {
      var cart = shoppingCart.getById(cid);
      total += cart.specification.price * cart.count;
    }
    var isAllSelected = shoppingCart.isAllSelected;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: const Border(top: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(
                  value: isAllSelected,
                  onChanged: (b) => b == true
                      ? shoppingCart.selectAll()
                      : shoppingCart.unSelectedAll()),
              const Text("全选"),
            ],
          ),
          Row(children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text("已选${shoppingCart.selectedCount}件", style: littleStyle),
                const SizedBox(
                  width: 10,
                ),
                const Text("合计："),
                Price(
                  total,
                  fontSize: 15,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: colorScheme.secondaryContainer,
                      textStyle: TextStyle(
                          fontSize: 16, color: colorScheme.onSecondary)),
                  onPressed: () {},
                  child: const Text("结算")),
            )
          ]),
        ],
      ),
    );
  }
}

class ShoppingCartModel extends ChangeNotifier {
  ShoppingCartModel(this.cars);
  List<Cart> cars;
  Set<int> selectedCartIds = {};

  Set<int> get selectedCarts => selectedCartIds;
  bool get isAllSelected => selectedCartIds.length == cars.length;

  int get selectedCount {
    var count = 0;
    for (var cid in selectedCartIds) {
      var cart = getById(cid);
      count += cart.count;
    }
    return count;
  }

  void selectAll() {
    selectedCartIds = cars.map((c) => c.carId).toSet();
    notifyListeners();
  }

  void unSelectedAll() {
    selectedCartIds = {};
    notifyListeners();
  }

  Cart getById(int id) {
    return cars.firstWhere((c) => c.carId == id);
  }

  void add(int cid) {
    selectedCartIds.add(cid);
    notifyListeners();
  }

  void adds(Iterable<int> cids) {
    for (var cid in cids) {
      selectedCartIds.add(cid);
    }
    notifyListeners();
  }

  void changeCount(int cid, int count) {
    var cart = getById(cid);
    cart.count = count;
    notifyListeners();
  }

  void remove(int cid) {
    selectedCartIds.remove(cid);
    notifyListeners();
  }

  void removes(Iterable<int> cids) {
    for (var cid in cids) {
      selectedCartIds.remove(cid);
    }
    notifyListeners();
  }

  bool isCartSelected(int cid) {
    return selectedCartIds.contains(cid);
  }
}
