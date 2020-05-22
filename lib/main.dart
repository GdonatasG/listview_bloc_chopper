import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listviewblocflutter/data/repository/user_repository_impl.dart';
import 'package:listviewblocflutter/pages/page_home.dart';

import 'data/service/user_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static UserService userService = UserService.create();
  final UserRepositoryImpl userRepositoryImpl =
      UserRepositoryImpl(userService: userService);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => this.userRepositoryImpl,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ListView with BLoC pattern',
        home: SafeArea(
            child: Scaffold(
          body: HomePage(),
        )),
      ),
    );
  }
}
