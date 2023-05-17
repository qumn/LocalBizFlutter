import 'package:flutter/material.dart';

import 'pages/merchant.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LocalBiz',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  changeSelectedIndex(int index) {
    setState(() => selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("LocalBiz"),
        leading: const Icon(Icons.menu),
        actions: const [
          Icon(Icons.search),
        ],
      ),
      body: AppBody(selectedIndex: selectedIndex),
      bottomNavigationBar: BottomNavigation(
          selectedIndex: selectedIndex,
          onDestinationSelected: changeSelectedIndex),
    );
  }
}

// Page router based on selectedIndex
class AppBody extends StatelessWidget {
  const AppBody({super.key, required this.selectedIndex});
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    Widget page;
    if (selectedIndex == 0) {
      page = const MerchantPage();
    } else if (selectedIndex == 1) {
      page = Container(
        color: Colors.green,
        alignment: Alignment.center,
        child: const Text('Page 2'),
      );
    } else if (selectedIndex == 2) {
      page = Container(
        color: Colors.blue,
        alignment: Alignment.center,
        child: const Text('Page 3'),
      );
    } else {
      throw UnimplementedError("exceeds number of pages");
    }
    return page;
  }
}


// Bottom Navigation
typedef OnDestinationSelected = void Function(int idx);

class BottomNavigation extends StatelessWidget {
  const BottomNavigation(
      {required this.onDestinationSelected,
      required this.selectedIndex,
      super.key});
  final OnDestinationSelected onDestinationSelected;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: onDestinationSelected,
      selectedIndex: selectedIndex,
      destinations: const <Widget>[
        NavigationDestination(icon: Icon(Icons.home), label: '主页'),
        NavigationDestination(icon: Icon(Icons.shopping_cart), label: '购物车'),
        NavigationDestination(icon: Icon(Icons.person), label: '设置'),
      ],
    );
  }
}
