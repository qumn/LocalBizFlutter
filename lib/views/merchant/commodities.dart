import 'package:flutter/material.dart';
import 'package:local_biz/component/image.dart';
import 'package:local_biz/component/price.dart';
import 'package:local_biz/config.dart';
import 'package:local_biz/modal/category.dart';
import 'package:local_biz/modal/commodity.dart';
import 'package:local_biz/modal/merchant.dart';
import 'package:local_biz/views/merchant/shopping_card_model.dart';
import 'package:provider/provider.dart';

import 'shop/shop_scroll_controller.dart';
import 'shop/shop_scroll_coordinator.dart';
import 'package:local_biz/api/category.dart' as category_client;

import 'shopping_cart/index.dart';

const commodityItemExtent = 120.0;

class CommodityWithCategoryList extends StatefulWidget {
  const CommodityWithCategoryList(
      {super.key, required this.shopCoordinator, required this.merchant});

  final Merchant merchant;
  final ShopScrollCoordinator shopCoordinator;

  @override
  State<CommodityWithCategoryList> createState() =>
      _CommodityWithCategoryListState();
}

class _CommodityWithCategoryListState extends State<CommodityWithCategoryList>
    with TickerProviderStateMixin {
  late ShopScrollCoordinator _shopCoordinator;
  late ShopScrollController _listScrollController1;
  late ShopScrollController _listScrollController2;

  late AnimationController _controller;
  // Animation Controller for expanding/collapsing the cart menu.
  late AnimationController _expandingController;

  int _currentCategoryIndex = 0;
  List<Category> categories = [];
  List<int> lenPerCategory = [];
  int totalLen = 0;
  List<double> positionPerCategory = [];
  // the key is commodity id, the value is the number of the commodity
  Map<int, Commodity> commoditiesMap = {};

  @override
  void initState() {
    _retieveCommodities();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 255),
      value: 1,
    );
    _expandingController = AnimationController(
      duration: const Duration(milliseconds: 255),
      vsync: this,
    );
    _shopCoordinator = widget.shopCoordinator;
    _listScrollController1 = _shopCoordinator.newChildScrollController();
    _listScrollController2 = _shopCoordinator.newChildScrollController();
    _listScrollController2.addListener(() {
      setState(() {
        var offset = _listScrollController2.offset.round();
        for (var i = 0; i < positionPerCategory.length; i++) {
          if (offset < positionPerCategory[i]) {
            _currentCategoryIndex = i - 1 < 0 ? 0 : i - 1;
            break;
          }
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _expandingController.dispose();
    _listScrollController1.dispose();
    _listScrollController2.dispose();
    //_listScrollController1 = _listScrollController2 = null;
    super.dispose();
  }

  void _retieveCommodities() async {
    var freshCategories = await category_client.fetchByMid(widget.merchant.mid);
    setState(() {
      categories.clear();
      categories.addAll(freshCategories);
      lenPerCategory = categories.map((e) => e.commodities.length).toList();
      totalLen = lenPerCategory.fold(0, (a, b) => a + b);
      positionPerCategory = lenPerCategory.fold<List<double>>(
          [0], (a, b) => a..add(a.last + b * commodityItemExtent));
      commoditiesMap.clear();
      for (var category in categories) {
        for (var commodity in category.commodities) {
          commoditiesMap[commodity.cid] = commodity;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getCommodity(int index) {
      var offset = 0;
      for (var i = 0; i < categories.length; i++) {
        if (index < offset + lenPerCategory[i]) {
          return categories[i].commodities[index - offset];
        }
        offset += lenPerCategory[i];
      }
      throw Exception("Index out of range");
    }

    return ChangeNotifierProvider(
      create: (context) => ShoppingCartModel(),
      child: Stack(
        children: [
          Row(
            children: <Widget>[
              Expanded(child: _categories()),
              Expanded(
                  flex: 4,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(0),
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _listScrollController2,
                    itemExtent: commodityItemExtent,
                    itemCount: totalLen,
                    itemBuilder: (context, index) {
                      var commodity = getCommodity(index);
                      return CommodityItem(
                        commodity: commodity,
                        hideController: _controller,
                      );
                    },
                  )),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: ExpandingBottomSheet(
              expandingController: _expandingController,
            ),
          )
        ],
      ),
    );
  }

  ListView _categories() {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _listScrollController1,
      itemExtent: 50.0,
      itemCount: categories.length,
      itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            _listScrollController2.animateTo(positionPerCategory[index],
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease);
          },
          child: CategoryItem(
            categoryName: categories[index].name,
            isSelected: index == _currentCategoryIndex,
          )),
    );
  }
}

class CategoryItem extends StatelessWidget {
  const CategoryItem(
      {super.key, required this.categoryName, this.isSelected = false});
  final String categoryName;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
        color:
            isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
        child: Center(child: Text(categoryName)));
  }
}

class CommodityItem extends StatelessWidget {
  const CommodityItem(
      {super.key, required this.commodity, required this.hideController});
  final Commodity commodity;
  final AnimationController hideController;

  Set<String> getKeys(Commodity commodity) {
    Set<String> keys = {};
    for (var spec in commodity.specifications) {
      keys.addAll(
          spec.atbs.where((atb) => atb.key != null).map((atb) => atb.key!));
    }
    return keys;
  }

  double getMinPrice(Commodity commodity) {
    double minPrice = double.infinity;
    for (var spec in commodity.specifications) {
      if (spec.price < minPrice) {
        minPrice = spec.price;
      }
    }
    return minPrice;
  }

  // get integer part
  String integerPart(double price) {
    return price.toStringAsFixed(0);
  }

  // get decimal part
  String decimalPart(double price) {
    return price.toStringAsFixed(2).split('.')[1];
  }

  @override
  Widget build(BuildContext context) {
    var shoppingCartModel = Provider.of<ShoppingCartModel>(context);
    var amount = shoppingCartModel.getQuantity(commodity.cid);

    var minPrice = getMinPrice(commodity);

    void onAdd() {
      shoppingCartModel.add(commodity);
    }

    void onSub() {
      shoppingCartModel.sub(commodity);
    }

    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    var titleStyle = theme.textTheme.bodyLarge!.copyWith(
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface,
        fontSize: 20);

    return Card(
      color: theme.colorScheme.surface,
      child: Row(children: [
        Expanded(
            flex: 2,
            child: LbImage(
                imgUrl: commodity.img,
                defaultImage: const AssetImage(defaultMerchantImage))),
        const SizedBox(
          width: 20,
        ),
        Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(commodity.name, style: titleStyle),
                const SizedBox(
                  height: 6,
                ),
                if (commodity.specifications.isNotEmpty) _tagRow(),
                Expanded(child: Container()),
                if (commodity.specifications.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Price(minPrice),
                      Counter(onAdd: onAdd, onSub: onSub, amount: amount)
                    ],
                  ),
                const SizedBox(height: 6), // padding to bottom
              ],
            ))
      ]),
    );
  }

  Row _tagRow() {
    return Row(
      children: getKeys(commodity)
          .take(4) // max can display 4 tags
          .map((key) => Padding(
                padding: const EdgeInsets.only(right: 3.0),
                child: Tag(key),
              ))
          .toList(),
    );
  }
}

class Tag extends StatelessWidget {
  const Tag(this.tag, {super.key});
  final String tag;

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.bodySmall!.copyWith(
        color: Theme.of(context).colorScheme.onTertiaryContainer,
        fontWeight: FontWeight.w600);
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      child: Text(tag, style: textStyle),
    );
  }
}

class Counter extends StatelessWidget {
  const Counter(
      {super.key, this.amount = 0, required this.onAdd, required this.onSub});

  final int amount;
  final void Function() onAdd;
  final void Function() onSub;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    // get font size
    var fontSize = theme.textTheme.bodyLarge!.fontSize!;

    var colorScheme = theme.colorScheme;
    // only show add button if amount is 0
    var addBtn = CircleAvatar(
      radius: fontSize + 1,
      backgroundColor: colorScheme.primaryContainer,
      child: Center(
        child: IconButton(
          onPressed: onAdd,
          icon: Icon(
            Icons.add,
            size: fontSize,
            color: colorScheme.primary,
          ),
        ),
      ),
    );
    var subBtn = CircleAvatar(
      radius: fontSize + 1,
      backgroundColor: colorScheme.primary,
      child: CircleAvatar(
        radius: fontSize,
        backgroundColor: colorScheme.surface,
        child: IconButton(
          onPressed: onSub,
          icon: Icon(
            Icons.remove,
            size: fontSize,
          ),
        ),
      ),
    );

    if (amount == 0) {
      return Container(
        child: addBtn,
      );
    }

    return Container(
        child: Row(
      children: [
        subBtn,
        const SizedBox(
          width: 3,
        ),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Center(child: Text(amount.toString()))),
        const SizedBox(
          width: 3,
        ),
        addBtn
      ],
    ));
  }
}
