import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/location_bloc.dart';
import 'screens/input_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Location Based App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const InputScreen(),
      ),
    );
  }
}
