import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_biz/api/order.dart';
import 'package:local_biz/api/user.dart';
import 'package:local_biz/component/image.dart';
import 'package:local_biz/component/price.dart';
import 'package:local_biz/config.dart';
import 'package:local_biz/log.dart';
import 'package:local_biz/modal/order.dart';
import 'package:local_biz/utils/img_url.dart';

import '../../modal/user.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  User? user;
  List<Order> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    _retrieve();
    _getOrders();
    super.initState();
  }

  void _retrieve() async {
    var user = await getUser();
    setState(() {
      this.user = user!;
    });
  }

  void _getOrders() {
    fetchOrders().then((value) {
      setState(() {
        // value sort by createTime
        value.sort((a, b) {
          if (a.createTime == null || b.createTime == null) return 0;
          return b.createTime!.compareTo(a.createTime!);
        });
        orders = value;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(flex: 1, child: _userProfile()),
          Expanded(flex: 1, child: _overview(context)),
          Expanded(flex: 5, child: _body())
        ],
      ),
    );
  }

  ImageProvider _getAvatarUrl(User? user) {
    if (user == null || user.avatar == null || user.avatar!.isEmpty) {
      return const AssetImage(defaultUserImage);
    }
    return NetworkImage((getImgUrl(user.avatar!)));
  }

  Widget _userProfile() {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    var nameStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: colorScheme.onPrimaryContainer,
    );

    return Container(
      color: colorScheme.surface,
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: _getAvatarUrl(user),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 20, left: 20),
                child: Row(
                  children: [
                    Text(
                      user?.nickName ?? '未知',
                      style: nameStyle,
                    ),
                    const SizedBox(width: 10),
                    Icon(Icons.edit, size: nameStyle!.fontSize),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _overview(BuildContext ctx) {
    return const Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('关注'),
              Text('0'),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('粉丝'),
              Text('0'),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('收藏'),
              Text('0'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _orderItem(Order order) {
    var merchant = order.merchant;
    if (merchant == null) {
      return const SizedBox();
    }
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    var titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: colorScheme.onPrimaryContainer,
    );
    var subtitleStyle = theme.textTheme.titleMedium?.copyWith(
      // fontWeight: FontWeight.w200,
      color: colorScheme.onPrimaryContainer,
    );
    var totalPrice = order.items.fold(0.0, (previousValue, item) {
      return previousValue + (item.specification?.price ?? 0) * item.count;
    });
    String dateFormat(DateTime time) {
      var dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      if (time.isAfter(DateTime.now().subtract(const Duration(days: 1)))) {
        return '${time.hour}:${time.minute}:${time.second}';
      }
      return dateFormat.format(time);
    }

    var totalPriceWidget = ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 90, minHeight: 140),
      child: Container(
          color: colorScheme.errorContainer.withOpacity(0.4),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Price(
                  totalPrice,
                  fontSize: 12,
                ),
                Text('共${order.items.length}件', style: subtitleStyle)
              ])),
    );

    var orderItemList = Stack(
      children: [
        ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children:
              order.items.where((item) => item.commodity != null).map((o) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                children: [
                  SizedBox(
                    height: 90,
                    width: 90,
                    child: LbImage(
                      imgUrl: o.commodity?.img,
                      defaultImage: const AssetImage(defaultCommodityImage),
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(o.commodity?.name ?? "", style: subtitleStyle),
                ],
              ),
            );
          }).toList(),
        ),
        Align(
          alignment: Alignment.topRight,
          child: totalPriceWidget,
        )
      ],
    );

    return Card(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(merchant.name, style: titleStyle),
                      const Icon(Icons.arrow_forward_ios, size: 12)
                    ],
                  ),
                  // if (order.createTime != null)
                  //   Padding(
                  //     padding: const EdgeInsets.only(right: 6),
                  //     child: Text(dateFormat(order.createTime!), style: subtitleStyle),
                  //   ),
                ],
              ),
            ),
            SizedBox(
              height: 140,
              child: orderItemList,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4, right: 4, left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('更多', style: subtitleStyle),
                  // a button again 
                  TextButton(onPressed: (){}, child: const Text('再来一单'),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _orderList() {
    if (isLoading) {
      return const CircularProgressIndicator();
    }
    if (orders.isEmpty) {
      return const Text("暂无订单");
    }

    return ListView.builder(
      itemCount: orders.length,
      // itemBuilder: (ctx, idx) => Container(
      //   width: 100,
      //   height: 100,
      //   color: Colors.red,
      // ),
      //
      itemBuilder: (ctx, idx) => _orderItem(orders[idx]),
    );
  }

  Widget _body() {
    var theme = Theme.of(context);
    var titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: theme.colorScheme.onPrimaryContainer,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text("最近订单", style: titleStyle),
          Icon(
            Icons.arrow_right,
            size: titleStyle!.fontSize,
          ),
        ]),
        Expanded(flex: 1, child: Center(child: _orderList())),
      ]),
    );
  }
}
