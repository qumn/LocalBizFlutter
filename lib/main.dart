import 'package:flutter/material.dart';
import 'package:local_biz/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'LocalBiz',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      routeInformationParser: appRouter.routeInformationParser,
      routeInformationProvider: appRouter.routeInformationProvider,
      routerDelegate: appRouter.routerDelegate,
    );
  }
}
