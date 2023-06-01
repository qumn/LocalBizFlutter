import 'package:flutter/material.dart';
import 'package:local_biz/api/user.dart';
import 'package:local_biz/config.dart';
import 'package:local_biz/utils/img_url.dart';

import '../../modal/user.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  User? user;

  @override
  void initState() {
    _retrieve();
    super.initState();
  }

  void _retrieve() async {
    var user = await getUser();
    setState(() {
      this.user = user!;
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
          Expanded(flex: 5, child: _orderList())
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
    // if use not be retrieved, show loading
    if (user == null) {
      return const CircularProgressIndicator();
    }
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

  Widget _orderList() {
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
        const Expanded(
            flex: 1, child: Center(child: CircularProgressIndicator())),
      ]),
    );
  }
}
