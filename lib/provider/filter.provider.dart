import 'package:flutter/cupertino.dart';

// enum contentAlign =

class FilterProvider extends ChangeNotifier {
  String _alignment = "Left";
  String get alignment => _alignment;

  void updateAlignment(String val) {
    _alignment = val;
    notifyListeners();
  }

  bool _enableBorder = false;
  bool get enableBorder => _enableBorder;

  void updateBorder(bool value) {
    _enableBorder = value;
    notifyListeners();
  }

  bool _enableBullets = false;
  bool get enableBullets => _enableBullets;

  void updateBullets(bool value) {
    _enableBullets = value;
    notifyListeners();
  }

  double _fontSize = 12;
  double get fontSize => _fontSize;

  void updateFontSize(double value) {
    _fontSize = value;
    notifyListeners();
  }

  void reduceFontSize() {
    _fontSize = _fontSize - 1;
    notifyListeners();
  }

  void increaseFontSize() {
    _fontSize = _fontSize + 1;
    notifyListeners();
  }

  String _imagePath = "";
  String get imagePath => _imagePath;

  void updateImagePath(String path) {
    _imagePath = path;
    notifyListeners();
  }
}

extension DisplayName on TextAlign {
  String get name {
    switch (this) {
      case TextAlign.left:
        return "Left";
      case TextAlign.right:
        return "Right";
      case TextAlign.center:
        return "Center";

      case TextAlign.justify:
        return "Justify";
      case TextAlign.start:
        return "Start";
      case TextAlign.end:
        return "End";
    }
  }
}
