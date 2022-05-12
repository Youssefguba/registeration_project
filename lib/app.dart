import 'package:flutter/material.dart';
import 'package:signup_project_task/configs/config.export.dart';

import 'features/authentication/auth.export.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return setupDependencies(
      child: MaterialApp(
        title: 'Dukkantek Task',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const LoginScreen(),
      ),
    );
  }
}
