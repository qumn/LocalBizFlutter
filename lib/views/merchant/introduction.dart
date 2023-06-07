import 'package:flutter/material.dart';

import 'shop/shop_scroll_controller.dart';
import 'shop/shop_scroll_coordinator.dart';

class Introduction extends StatefulWidget {
  const Introduction({super.key});

  @override
  _IntroductionState createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("店铺信息页面"),
    );
  }
}
