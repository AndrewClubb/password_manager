import 'package:flutter/foundation.dart';

class siteViewModel extends ChangeNotifier {
  String _url = "";
  String _username = "";
  String _password = "";

  String get url => _url;
  String get password => _password;
  String get username => _username;

  void changeUrl(String value) {
    _url = value;
    notifyListeners();
  }
  void changePassword(String value) {
    _password = value;
    notifyListeners();
  }
  void changeUsername(String value) {
    _username = value;
    notifyListeners();
  }
}