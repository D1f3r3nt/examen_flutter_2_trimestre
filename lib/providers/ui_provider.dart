import 'package:examen_practic_2_trimestre/preferences/preferences.dart';
import 'package:flutter/cupertino.dart';

class UIProvider extends ChangeNotifier {
  bool online = Preferences.online;

  updateType(bool type) {
    online = type;
    Preferences.online = type;
    notifyListeners();
  }
}
