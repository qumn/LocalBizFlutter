import 'package:flutter/material.dart';
import 'package:local_biz/api/user.dart';

import '../../modal/user.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late User user;
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
      body: const Center(
        child: Text('设置'),
      ),
    );
  }

  Widget _userProfile() {
    if (user == null) {
      return const CircularProgressIndicator();
    }

    return Container(
      child: Row(
        children: [
          Container(
            child: Image.asset('assets/images/user.png'),
          ),
          Container(
            child: Column(
              children: [
                Text('用户名'),
                Text('手机号'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
