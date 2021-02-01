import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnvironmentConfig {
  final appApiKey =const String.fromEnvironment("appApiKey");
}

final environmentConfigProvider = Provider<EnvironmentConfig>((ref){
  return EnvironmentConfig();
});