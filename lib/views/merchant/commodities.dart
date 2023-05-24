import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:local_biz/component/image.dart';
import 'package:local_biz/config.dart';
import 'package:local_biz/modal/category.dart';
import 'package:local_biz/modal/commodity.dart';
import 'package:local_biz/modal/merchant.dart';

import 'shop/shop_scroll_controller.dart';
import 'shop/shop_scroll_coordinator.dart';
import 'package:local_biz/api/category.dart' as category_client;

const commodityItemExtent = 180.0;

class CommodityWithCategoryList extends StatefulWidget {
  const CommodityWithCategoryList(
      {super.key, required this.shopCoordinator, required this.merchant});

  final Merchant merchant;
  final ShopScrollCoordinator shopCoordinator;

  @override
  State<CommodityWithCategoryList> createState() =>
      _CommodityWithCategoryListState();
}

class _CommodityWithCategoryListState extends State<CommodityWithCategoryList> {
  late ShopScrollCoordinator _shopCoordinator;
  late ShopScrollController _listScrollController1;
  late ShopScrollController _listScrollController2;

  int _currentCategoryIndex = 0;
  List<Category> categories = [];
  List<int> lenPerCategory = [];
  int totalLen = 0;
  List<double> positionPerCategory = [];

  @override
  void initState() {

    _retieveCommodities();
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

  void _retieveCommodities() async {
    var freshCategories = await category_client.fetchByMid(widget.merchant.mid);
    setState(() {
      categories.clear();
      categories.addAll(freshCategories);
      lenPerCategory = categories.map((e) => e.commodities.length).toList();
      totalLen = lenPerCategory.fold(0, (a, b) => a + b);
      positionPerCategory = lenPerCategory.fold<List<double>>(
          [0], (a, b) => a..add(a.last + b * commodityItemExtent));
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

    return Row(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
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
          ),
        ),
        Expanded(
          flex: 4,
          child: ListView.builder(
              padding: const EdgeInsets.all(0),
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _listScrollController2,
              itemExtent: commodityItemExtent,
              itemCount: totalLen,
              itemBuilder: (context, index) =>
                  CommodityItem(commodity: getCommodity(index))),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _listScrollController1.dispose();
    _listScrollController2.dispose();
    //_listScrollController1 = _listScrollController2 = null;
    super.dispose();
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
  const CommodityItem({super.key, required this.commodity});
  final Commodity commodity;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.surface,
      child: Row(children: [
        Expanded(
            child: LbImage(
                imgUrl: commodity.img,
                defaultImage: const AssetImage(defaultMerchantImage))),
        Expanded(
            child: Column(
          children: [Text(commodity.name)],
        ))
      ]),
    );
  }
}
