import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:local_biz/root_layout.dart';
import 'package:local_biz/views/cart/index.dart';
import 'package:local_biz/views/login.dart';
import 'package:local_biz/views/setting/index.dart';
import 'package:local_biz/views/settlement/index.dart';

import 'views/merchant/merchant.dart';

const _pageKey = ValueKey('_pageKey');
const _scaffoldKey = ValueKey('_scaffoldKey');

const List<NavigationDestination> destinations = [
  NavigationDestination(
    label: '主页',
    icon: Icon(Icons.home), // Modify this line
    route: '/merchant',
  ),
  NavigationDestination(
    label: '购物车',
    icon: Icon(Icons.shopping_cart), // Modify this line
    route: '/shopping_cart',
  ),
  NavigationDestination(
    label: '设置',
    icon: Icon(Icons.settings), // Modify this line
    route: '/settings',
  ),
];

class NavigationDestination {
  const NavigationDestination({
    required this.route,
    required this.label,
    required this.icon,
    this.child,
  });

  final String route;
  final String label;
  final Icon icon;
  final Widget? child;
}

final appRouter = GoRouter(
  initialLocation: '/merchant',
  routes: [
    // loginScreen
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) =>
          MaterialPage<void>(key: _pageKey, child: LoginScreen()),
      // child: RootLayout(
      //     key: _scaffoldKey, currentIndex: 0, child: LoginScreen())),
    ),
    // MerchantScreen
    GoRoute(
      path: '/merchant',
      pageBuilder: (context, state) => const MaterialPage<void>(
        key: _pageKey,
        child: RootLayout(
            key: _scaffoldKey, currentIndex: 0, child: MerchantScreen()),
      ),
    ),
    GoRoute(
      path: '/shopping_cart',
      pageBuilder: (context, state) => const MaterialPage<void>(
          key: _pageKey,
          child: RootLayout(
              key: _scaffoldKey, currentIndex: 1, child: ShoppingCartScreen())),
    ),
    GoRoute(
        path: '/settings',
        pageBuilder: (context, state) => const MaterialPage<void>(
            key: _pageKey,
            child: RootLayout(
                key: _scaffoldKey, currentIndex: 2, child: SettingScreen()))),
    GoRoute(
        path: '/settlement',
        pageBuilder: (context, state) {
          var shoppingCartModel = state.extra as ShoppingCartModel;
          return MaterialPage<void>(
              key: _pageKey, child: SettelMentScreen(shoppingCartModel));
        }),
  ],
);
