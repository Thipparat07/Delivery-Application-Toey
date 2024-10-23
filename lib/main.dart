import 'package:flutter/material.dart';
import 'package:flutter_delivery_1/Product.dart';
import 'package:flutter_delivery_1/SearchReceiver.dart';
import 'package:flutter_delivery_1/app_cover.dart';
import 'package:flutter_delivery_1/check_status.dart';
import 'package:flutter_delivery_1/login.dart';
import 'package:flutter_delivery_1/profileU.dart';
import 'package:flutter_delivery_1/registerR.dart';
import 'package:flutter_delivery_1/registerU.dart';
import 'package:get/get.dart';
import 'package:flutter_delivery_1/home_page.dart';
import 'package:get_storage/get_storage.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Login(),
    );
  }
}
