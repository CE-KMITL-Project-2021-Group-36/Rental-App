import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:rental_app/injection.dart';
import 'package:rental_app/presentation/core/app_widget.dart';

import 'presentation/bottom_nav_bar.dart';

void main() {
  configureInjection(Environment.prod);
  runApp(const AppWidget());
}
