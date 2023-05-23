import 'dart:math';

import 'package:flutter/material.dart';
import 'package:local_biz/modal/merchant.dart';
import './page1.dart';
import './page2.dart';
import './page3.dart';
import './shop/shop_scroll_controller.dart';
import './shop/shop_scroll_coordinator.dart';

const defaultMerchantImage = 'assets/merchant.jpeg';

class MerchantDetailScreen extends StatefulWidget {
  const MerchantDetailScreen({super.key, required this.merchant});
  final Merchant merchant;

  @override
  State<StatefulWidget> createState() => _MerchantDetailScreenState();
}

class _MerchantDetailScreenState extends State<MerchantDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    //var _tabController = TabController(length: 3, vsync: Scaffold.of(context));
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              title: const Text("首页", style: TextStyle(color: Colors.black)),
              backgroundColor: Colors.transparent,
              bottom: TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                tabs: const <Widget>[
                  Tab(text: "商品"),
                  Tab(text: "评价"),
                  Tab(text: "商家"),
                ],
              ),
            )
          ];
        },
        body: Container(
          color: Colors.blue,
          child: const Center(
            child: Text("Body部分"),
          ),
        ),
      ),
    );
  }
}

class _MerchantImage extends StatelessWidget {
  const _MerchantImage(this.img);

  final String? img;

  @override
  Widget build(BuildContext context) {
    ImageProvider image = img != null
        ? NetworkImage(img!)
        : const AssetImage(defaultMerchantImage) as ImageProvider;
    return Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            image: DecorationImage(image: image, fit: BoxFit.cover)));
  }
}

class ShopPage extends StatefulWidget {
  const ShopPage({super.key, required this.merchant});
  final Merchant merchant;

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage>
    with SingleTickerProviderStateMixin {
  ///页面滑动协调器
  late ShopScrollCoordinator _shopCoordinator;
  ShopScrollController? _pageScrollController;

  late TabController _tabController;

  final double _sliverAppBarInitHeight = 200;
  final double _tabBarHeight = 50;
  double? _sliverAppBarMaxHeight;
  MediaQueryData? mediaQuery;
  double? screenHeight;
  double? statusBarHeight;

  @override
  void initState() {
    super.initState();
    _shopCoordinator = ShopScrollCoordinator();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    mediaQuery ??= MediaQuery.of(context);
    screenHeight ??= mediaQuery?.size.height;
    statusBarHeight ??= mediaQuery?.padding.top;

    _sliverAppBarMaxHeight ??= screenHeight!;
    _pageScrollController ??= _shopCoordinator
        .pageScrollController(_sliverAppBarMaxHeight! - _sliverAppBarInitHeight);

    _shopCoordinator.pinnedHeaderSliverHeightBuilder ??= () {
      return statusBarHeight! + kToolbarHeight + _tabBarHeight;
    };
    return Scaffold(
      body: Listener(
        onPointerUp: _shopCoordinator.onPointerUp,
        child: CustomScrollView(
          controller: _pageScrollController,
          physics: const ClampingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              title: const Text("店铺首页", style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.blue,
              expandedHeight: _sliverAppBarMaxHeight,
            ),
            SliverPersistentHeader(
              pinned: false,
              floating: true,
              delegate: _SliverAppBarDelegate(
                maxHeight: 100,
                minHeight: 100,
                child: const Center(child: Text("我是活动Header")),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: _SliverAppBarDelegate(
                maxHeight: _tabBarHeight,
                minHeight: _tabBarHeight,
                child: Container(
                  color: Colors.white,
                  child: TabBar(
                    labelColor: Colors.black,
                    controller: _tabController,
                    tabs: const <Widget>[
                      Tab(text: "商品"),
                      Tab(text: "评价"),
                      Tab(text: "商家"),
                    ],
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  Page1(shopCoordinator: _shopCoordinator),
                  Page2(shopCoordinator: _shopCoordinator),
                  Page3(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageScrollController?.dispose();
    super.dispose();
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
