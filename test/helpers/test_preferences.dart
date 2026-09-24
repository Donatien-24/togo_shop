import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> buildTestPreferences([
  Map<String, Object> values = const {},
]) async {
  SharedPreferences.setMockInitialValues(values);
  return SharedPreferences.getInstance();
}
