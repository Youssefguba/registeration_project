import 'package:flutter/material.dart';

import 'app.dart';
import 'configs/config.export.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjectionInit().registerSingleton();
  runApp(const MyApp());
}
