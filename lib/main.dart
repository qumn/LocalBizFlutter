import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
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

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

class MerchantPage extends StatefulWidget {
  const MerchantPage({super.key});

  @override
  State<StatefulWidget> createState() => _MerchantPageState();
}

class _MerchantPageState extends State<MerchantPage> {
  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  Future<Album> fetchAlbum() async {
    final respose = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
    if (respose.statusCode == 200) {
      return Album.fromJson(jsonDecode(respose.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureAlbum,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data.toString());
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
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
