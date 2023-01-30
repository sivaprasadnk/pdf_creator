import 'package:flutter/cupertino.dart';

class AppProvider extends ChangeNotifier {
  String _version = "";
  String get version => _version;

  void updateVersion(String value) {
    _version = value;
    notifyListeners();
  }
}
