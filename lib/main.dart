import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:route_index/models/route_model.dart';

import 'screens/edit_route_screen.dart';
import 'screens/home_screen.dart';
import 'screens/route_screen.dart';

Future<void> main() async {
  // init Hive and open the routes box
  await Hive.initFlutter();
  Hive.registerAdapter(RouteModelAdapter());
  await Hive.openBox('routes');
  // add random routes for testing
  await Hive.box('routes').add(RouteModel());
  await Hive.box('routes').add(RouteModel()
    ..name = "Seegurke"
    ..grade = 8
    ..sector = "Grotte"
    ..setter = "Blub");
  await Hive.box('routes').add(RouteModel()
    ..name = "Essiggurke"
    ..grade = 2
    ..sector = "Garage"
    ..setter = "Quarkus");
  await Hive.box('routes').add(RouteModel()
    ..name = "Wieso bisch so schlecht?"
    ..grade = 3
    ..sector = "Flachland"
    ..setter = "Ferdinand");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boulder App Test',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/info': (context) => RouteScreen(
            route: ModalRoute.of(context)!.settings.arguments as RouteModel),
        '/edit': (context) => EditRouteScreen(
            route: ModalRoute.of(context)!.settings.arguments as RouteModel),
      },
    );
  }
}
