import 'package:flutter/material.dart';

import 'shop/shop_scroll_controller.dart';
import 'shop/shop_scroll_coordinator.dart';

class Page1 extends StatefulWidget {
  final ShopScrollCoordinator shopCoordinator;

  const Page1({super.key, required this.shopCoordinator});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  late ShopScrollCoordinator _shopCoordinator;
  late ShopScrollController _listScrollController1;
  late ShopScrollController _listScrollController2;
  int _currentCategoryIndex = 0;

  @override
  void initState() {
    _shopCoordinator = widget.shopCoordinator;
    _listScrollController1 = _shopCoordinator.newChildScrollController();
    _listScrollController2 = _shopCoordinator.newChildScrollController();
    _listScrollController2.addListener(() {
      setState(() {
        var offset = _listScrollController2.offset.round();
        //print("current offset: $offset");
        _currentCategoryIndex = offset ~/ 600;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(0),
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _listScrollController1,
            itemExtent: 50.0,
            itemCount: 20,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                print("tap $index");
                _listScrollController2.animateTo(200.0 * index * 3,
                    duration: Duration(milliseconds: 300), curve: Curves.ease);
              },
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(5.0),
                color: index == _currentCategoryIndex
                    ? Colors.red
                    : index % 2 == 0
                        ? Colors.cyan
                        : Colors.deepOrange,
                child: GestureDetector(
                    child: Center(child: Text(index.toString()))),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: ListView.builder(
            padding: const EdgeInsets.all(0),
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _listScrollController2,
            itemExtent: 200.0,
            itemCount: 30,
            itemBuilder: (context, index) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(5.0),
                color: index % 2 == 0 ? Colors.cyan : Colors.deepOrange,
                child: Center(child: Text(index.toString())),
              ),
            ),
          ),
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
