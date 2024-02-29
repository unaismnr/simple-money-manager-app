import 'package:flutter/material.dart';
import 'package:simple_money_manager/hive_init.dart';
import 'package:simple_money_manager/screens/add_transaction_screen.dart';
import 'package:simple_money_manager/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await hiveInit();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Money Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: false,
      ),
      home: HomeScreen(),
      routes: {
        AddTransactionScreen.routeName: (context) =>
            const AddTransactionScreen(),
      },
    );
  }
}
