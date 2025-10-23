import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackerop/NewhomePage.dart';
import 'package:trackerop/money/database/expenses_database.dart';
import 'package:trackerop/money/models/expenses.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

//initialize  money db
  await expenses_database.initialize();
  // Purge known test data once at startup (safe no-op if none exist)
  await expenses_database.purgeTestData();

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
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: NewhomePage(),
    );
  }
}
