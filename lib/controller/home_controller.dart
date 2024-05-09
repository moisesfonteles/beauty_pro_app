import 'package:beauty_pro/services/user_authentication.dart';

class HomeController {

  final _userAuthentication = UserAuthentication();

  void logout() {
    _userAuthentication.logout();
  }

}