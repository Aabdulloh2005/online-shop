import 'package:flutter/cupertino.dart';
import 'package:online_shop_animation/services/user_auth_service.dart';

class UserController {
  final _userAuthentication = UserAuthService();

  Future<void> registerUser(String email, String password, String username,
      BuildContext context) async {
    await _userAuthentication.registerUser(context, email, password, username);
  }

  void logInUser(String email, String password) async {
    _userAuthentication.logInUser(email, password);
  }

  void resetPasswordUser(String email) async {
    _userAuthentication.resetPasswordUser(email);
  }

  void signOut() async {
    _userAuthentication.signOut();
  }
}
