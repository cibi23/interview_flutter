import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_flutter/pages/product_list_page.dart';
import 'package:interview_flutter/services/network.dart';
import 'package:interview_flutter/state/product_list_cubit.dart';

void main() {
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Products',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocProvider(
          create: (_) => ProductListCubit(),
          child: ProductListPage(),
        ));
  }
}
