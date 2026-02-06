import 'package:hive/hive.dart';

class AuthHelper {
  static final Box _box = Hive.box('authBox');

  static bool isLoggedIn() {
    return _box.get('loggedIn', defaultValue: false);
  }

  static void setLoggedIn() {
    _box.put('loggedIn', true);
  }

  static void logout() {
    _box.put('loggedIn', false);
  }
}
