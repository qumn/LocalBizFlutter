import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:local_biz/root_layout.dart';
import 'package:local_biz/views/merchat_detail.dart';

import 'views/merchant.dart';

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
    // MerchantScreen
    GoRoute(
      path: '/merchant',
      pageBuilder: (context, state) => const MaterialPage<void>(
        key: _pageKey,
        child: RootLayout(
            key: _scaffoldKey, currentIndex: 0, child: MerchantScreen()),
      ),
      routes: [
        GoRoute(
          path: ':mid',
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const RootLayout(
              key: _scaffoldKey,
              currentIndex: 0,
              child: MerchantDetailScreen()
            ),
          ),
          // builder: (context, state) => ArtistScreen(
          //   id: state.params['aid']!,
          // ),
        ),
      ],

    ),
    GoRoute(
        path: '/shopping_cart',
        pageBuilder: (context, state) => const MaterialPage<void>(
            key: _pageKey,
            child: RootLayout(
                key: _scaffoldKey,
                currentIndex: 1,
                child: Placeholder(
                  key: ValueKey("shopping_cart"),
                  color: Colors.green,
                )))),
    GoRoute(
        path: '/settings',
        pageBuilder: (context, state) => const MaterialPage<void>(
            key: _pageKey,
            child: RootLayout(
                key: _scaffoldKey,
                currentIndex: 2,
                child: Placeholder(
                  key: ValueKey("settings"),
                  color: Colors.red,
                ))))
  ],
);
