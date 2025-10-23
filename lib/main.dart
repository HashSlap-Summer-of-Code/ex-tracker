import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackerop/NewhomePage.dart';
import 'package:trackerop/money/database/expenses_database.dart';
import 'package:trackerop/money/models/expenses.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

//initialize  money db
  await expenses_database.initialize();

  runApp(MultiProvider(
    providers: [
      //money provider
      ChangeNotifierProvider(create: (context) => expenses_database()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Widget home = const NewhomePage();
    final Widget wrappedHome = (kDebugMode && expenses_database.isTestMode)
        ? Banner(
            message: 'TEST DATA',
            location: BannerLocation.topStart,
            color: Colors.redAccent,
            child: home,
          )
        : home;

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: wrappedHome,
    );
  }
}
