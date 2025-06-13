import 'package:flutter/material.dart';
import 'package:pruzi_korak/app/app.dart';

import 'app/di/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDI();

  runApp(MyApp());
}

