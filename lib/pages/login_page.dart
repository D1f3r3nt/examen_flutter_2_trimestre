import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../preferences/preferences.dart';
import '../providers/firebase.dart';
import '../providers/person_provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  final GlobalKey<FormState> _key = GlobalKey();

  final RegExp emailRegExp =
      RegExp(r'^\w+[\w-\.]*\@\w+((-\w+)|(\w*))\.[a-z]{2,3}$');
  final RegExp contRegExp = RegExp(r'^([1-zA-Z0-1@.\s]{1,255})$');
  String? _correo;
  String? _contrasena;
  String mensaje = '';
  bool _isChecked = Preferences.remember;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loginForm(context),
    );
  }

  Widget loginForm(BuildContext context) {
    final firebase = Provider.of<Firebase>(context);
    final personProvider = Provider.of<PersonProvider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedLogo(animation: animation),
          ],
        ),
        Container(
          width: 300.0, //size.width * .6,
          child: Form(
            key: _key,
            child: Column(
              children: <Widget>[
                TextFormField(
                  validator: (text) {
                    if (text!.length == 0) {
                      return "Correu es obligatori";
                    } else if (!emailRegExp.hasMatch(text)) {
                      return "Format correu incorrecte";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  maxLength: 50,
                  textAlign: TextAlign.left,
                  initialValue: Preferences.email,
                  decoration: InputDecoration(
                    hintText: 'Escrigui el seu correu',
                    labelText: 'Correu',
                    counterText: '',
                    icon:
                        Icon(Icons.email, size: 32.0, color: Colors.blue[800]),
                  ),
                  onSaved: (text) => _correo = text,
                ),
                TextFormField(
                  validator: (text) {
                    if (text!.length == 0) {
                      return "Contrasenya és obligatori";
                    } else if (text.length < 5) {
                      return "Contrasenya mínim de 5 caràcters";
                    } else if (!contRegExp.hasMatch(text)) {
                      return "Contrasenya incorrecte";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  maxLength: 20,
                  textAlign: TextAlign.left,
                  initialValue: Preferences.password,
                  decoration: InputDecoration(
                    hintText: 'Escrigui la contrasenya',
                    labelText: 'Contrasenya',
                    counterText: '',
                    icon: Icon(Icons.lock, size: 32.0, color: Colors.blue[800]),
                  ),
                  onSaved: (text) => _contrasena = text,
                ),
                CheckboxListTile(
                  value: _isChecked,
                  onChanged: (value) {
                    setState(() {
                      _isChecked = value!;
                    });
                  },
                  title: const Text('Recorda\'m'),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                IconButton(
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                      _key.currentState!.save();
                      setState(() {
                        Preferences.remember = _isChecked;
                        if (_isChecked) {
                          Preferences.email = _correo ?? '';
                          Preferences.password = _contrasena ?? '';
                        } else {
                          Preferences.email = '';
                          Preferences.password = '';
                        }
                        if (firebase.persons.length <
                            personProvider.persons.length) {
                          firebase.updateData(personProvider.persons);
                        } else if (personProvider.persons.length <
                            firebase.persons.length) {
                          personProvider.updateData(firebase.persons);
                        }
                        Navigator.pushReplacementNamed(context, 'home');
                      });
                      mensaje = 'Gràcies \n $_correo \n $_contrasena';
                    }
                  },
                  icon: Icon(
                    Icons.arrow_forward,
                    size: 42.0,
                    color: Colors.blue[800],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AnimatedLogo extends AnimatedWidget {
  // Maneja los Tween estáticos debido a que estos no cambian.
  static final _opacityTween = Tween<double>(begin: 0.1, end: 1.0);
  static final _sizeTween = Tween<double>(begin: 0.0, end: 100.0);

  AnimatedLogo({Key? key, required Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    return Opacity(
      opacity: _opacityTween.evaluate(animation),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        height: _sizeTween.evaluate(animation), // Aumenta la altura
        width: _sizeTween.evaluate(animation), // Aumenta el ancho
        child: const FlutterLogo(),
      ),
    );
  }
}
