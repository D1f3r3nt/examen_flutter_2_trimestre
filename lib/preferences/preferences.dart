import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _prefs;

  static String _email = '';
  static String _password = '';
  static bool _remember = false;
  static bool _online = false;

  // Para coger la instancia
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Getter y Setters
  /* 
  IMPORTANTE: Donde ponga "variable" cambialo por la autentica
  */
  static String get email {
    return _prefs.getString('email') ?? _email;
  }

  static set email(String email) {
    _email = email;
    _prefs.setString('email', email);
  }

  static String get password {
    return _prefs.getString('password') ?? _password;
  }

  static set password(String password) {
    _password = password;
    _prefs.setString('password', password);
  }

  static bool get remember {
    return _prefs.getBool('remember') ?? _remember;
  }

  static set remember(bool remember) {
    _remember = remember;
    _prefs.setBool('remember', remember);
  }

  static bool get online {
    return _prefs.getBool('online') ?? _online;
  }

  static set online(bool online) {
    _online = online;
    _prefs.setBool('online', online);
  }
}
