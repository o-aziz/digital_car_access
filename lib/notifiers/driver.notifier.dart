import 'package:flutter/cupertino.dart';

class DriverNotifier extends ChangeNotifier {
  int _length = 1;

  int get length => _length;

  set length(value) {
    _length = value;
    notifyListeners();
  }
}
