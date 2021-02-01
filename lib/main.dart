import 'package:ceo_events/core/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

void main() {
  XuGetIt.setup();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: App()));
}
