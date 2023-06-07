import 'dart:math';
// q: how to use iterae exteision

import 'package:flutter/material.dart';
import 'package:local_biz/config.dart';
import 'package:local_biz/modal/commodity.dart';
import 'package:local_biz/modal/merchant.dart';
import 'package:local_biz/utils/img_url.dart';

import './commodities.dart';
import './comments.dart';
import './introduction.dart';
import './shop/shop_scroll_controller.dart';
import './shop/shop_scroll_coordinator.dart';

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
              title: const InvisibleExpandedHeader(
                  child: Text("首页", style: TextStyle(color: Colors.black))),
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
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage>
    with SingleTickerProviderStateMixin {
  ///页面滑动协调器
  late ShopScrollCoordinator _shopCoordinator;
  ShopScrollController? _pageScrollController;

  late TabController _tabController;

  final double _sliverAppBarInitHeight = 200;
  final double _tabBarHeight = 50;
  final double _sliverAppBarMaxHeight = 300;
  late final Merchant merchant;
  List<Commodity> commodities = [];
  Map<int, List<Commodity>> _catId2Commodities = {};

  MediaQueryData? mediaQuery;
  double? statusBarHeight;

  @override
  void initState() {
    merchant = widget.merchant;
    super.initState();
    _shopCoordinator = ShopScrollCoordinator();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var titleStyle =
        textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w500);
    mediaQuery ??= MediaQuery.of(context);
    statusBarHeight ??= mediaQuery?.padding.top;

    _pageScrollController ??= _shopCoordinator
        .pageScrollController(_sliverAppBarMaxHeight - _sliverAppBarInitHeight);

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
              title: InvisibleExpandedHeader(
                  // only show in collaspe mode
                  child: Text(merchant.name, style: titleStyle)),
              backgroundColor: theme.colorScheme.tertiaryContainer,
              expandedHeight: _sliverAppBarMaxHeight,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background: Image.network(
                      getImgUrl(
                          widget.merchant.introImg ?? defaultMerchantImage),
                      fit: BoxFit.cover)),
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
                  CommodityWithCategoryList(
                      shopCoordinator: _shopCoordinator, merchant: merchant),
                  Comments(shopCoordinator: _shopCoordinator),
                  const Introduction(),
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

class InvisibleExpandedHeader extends StatefulWidget {
  final Widget child;
  const InvisibleExpandedHeader({
    super.key,
    required this.child,
  });
  @override
  State<InvisibleExpandedHeader> createState() =>
      _InvisibleExpandedHeaderState();
}

class _InvisibleExpandedHeaderState extends State<InvisibleExpandedHeader> {
  ScrollPosition? _position;
  bool? _visible;

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removeListener();
    _addListener();
  }

  void _addListener() {
    _position = Scrollable.of(context).position;
    _position?.addListener(_positionListener);
    _positionListener();
  }

  void _removeListener() {
    _position?.removeListener(_positionListener);
  }

  void _positionListener() {
    final FlexibleSpaceBarSettings? settings =
        context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    bool visible =
        settings == null || settings.currentExtent <= settings.minExtent;
    if (_visible != visible) {
      setState(() {
        _visible = visible;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _visible ?? false,
      child: widget.child,
    );
  }
}
